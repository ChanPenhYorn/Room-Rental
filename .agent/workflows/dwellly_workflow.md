---
description: Implement new feature using Dwellly Architecture
---

# Dwellly Master Development Workflow  
**Flutter + Serverpod — Reference**  
**Last updated: March 2026**  
**Serverpod v2.x • Flutter 3.24+ • Riverpod 2.5+**

## 0. Prerequisites

- Serverpod CLI ≥ 2.0 installed globally (`dart pub global activate serverpod_cli`)
- Flutter ≥ 3.24
- Dart ≥ 3.5
- PostgreSQL running (local or Docker)
- `serverpod` & `dwellly_flutter` folders cloned side-by-side
- VS Code / Android Studio with Dart & Flutter extensions

## Core Principle

**Backend First – always.**  
1. Models & endpoints first  
2. Generate + migrate  
3. Sync Flutter client  
4. Then build Repository → Controller → UI  

**Strict Rule – never broken:**  
**Do NOT call Serverpod `client` from UI/widgets/screens.**  
Flow must be: UI ⇨ Controller ⇨ Repository ⇨ client

## 1. Backend-First: Models & Endpoints

1. **Models**  
   `dwellly_server/lib/src/models/*.yaml`  
   → Pure data only. No logic.

2. **Endpoints**  
   `dwellly_server/lib/src/endpoints/*.dart`  
   → Keep **very thin**  
   → Move business logic / 3rd-party calls / notifications → services  
     (e.g. `lib/src/server/services/notification_service.dart`, `email_service.dart`, etc.)

3. **Generate & Migrate** (run in order)

```bash
cd dwellly_server

# Regenerate code & client protocol (always first)
serverpod generate

# Only if you changed models or added tables/columns
serverpod create-migration

# Apply migrations & start/restart server
# (use --apply-migrations only once after create-migration)
dart bin/main.dart --apply-migrations
```

## 2. Client Sync (Flutter)

*Sync the generated client code so the Flutter app can recognize the new endpoints/models.*

1. **Update Client SDK**
   - Navigate to the Flutter app and run pub get to fetch the newly generated code:
     ```bash
     cd dwellly_flutter
     flutter pub get
     ```

## 3. App Architecture: UI → Domain → Data

*Follow this strict flow. **Never** call the Serverpod `client` directly from UI widgets.*

### Step 3a: Data Layer (Repositories)
- **Location:** `lib/features/<feature>/data/repositories/`
- **Action:** Create a standard repository class that injects the `client`. Wrap Serverpod API calls in `try/catch` and map them to domain-specific failures or Either types.
- **Provider:** Expose the repository via a simple Riverpod provider (`@Riverpod(keepAlive: true)`).

### Step 3b: Domain/State Layer (Controllers)
- **Location:** `lib/features/<feature>/presentation/controllers/`
- **Action:** Create controllers that talk to the Repository.
  - For fetching data from the server: Use **AsyncNotifier** (`@riverpod`).
  - For complex, local UI state management: Use **Notifier** (`@riverpod`).

### Step 3c: UI Layer (Presentation)
- **Location:** `lib/features/<feature>/presentation/screens/` & `widgets/`
- **Action:** Read from controllers. 
  - Use `ref.watch(controllerProvider)` to reactively rebuild UI.
  - Handle `when(data:, error:, loading:)` cleanly for async states.

## 4. State Management Rules (Anti-Overengineering)

Choose the simplest tool for the job:
- **Small UI State** (e.g., simple toggles, active tabs): `StatefulWidget` or `StateProvider`
- **Derived Data** (e.g., filtered list of rooms from an already fetched list): `Provider`
- **Async Server Data** (e.g., fetching user profile): `AsyncNotifier`
- **Complex Stateful Logic** (e.g., multi-step forms, cart): `Notifier`

## 5. Daily Git / Commit Flow
If you work across both repos simultaneously, ensure the server and app are pushed cohesively to avoid state mismatch on environments.
1. `flutter analyze` & `serverpod analyze` (conceptually)
2. Commit server changes first, then flutter changes, or push them together if in a monorepo structure.
