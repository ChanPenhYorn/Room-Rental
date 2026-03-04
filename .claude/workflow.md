# 🚀 Dwellly: Flutter + Serverpod Master Workflow

## 1. Backend First: Data & API (Serverpod)

*Always start feature development on the server.*

1. **Model Definition (`.spy.yaml`)**
   - Create or update models in `dwellly_server/lib/src/models/`.
   - Keep models strictly focused on data representation.

2. **Endpoint Logic (`.dart`)**
   - Create or update endpoints in `dwellly_server/lib/src/endpoints/`.
   - **Rule:** Endpoints must be lean. Delegate complex business logic, third-party integrations, and notifications to service classes or utilities (e.g., `NotificationUtils`).

3. **Generate & Migrate**
   - Sync the API, generate DB migrations, and restart the server (or use `/api_sync` command if configured):
     ```bash
     cd dwellly_server
     serverpod generate
     serverpod create-migration
     dart bin/main.dart --apply-migrations
     ```

---

## 2. Client Sync (Flutter)

*Sync the generated client code so the Flutter app can recognize the new endpoints/models.*

1. **Update Client SDK**
   - Navigate to the Flutter app and run pub get to fetch the newly generated code:
     ```bash
     cd dwellly_flutter
     flutter pub get
     ```

---

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

---

## 4. State Management Rules (Anti-Overengineering)

Choose the simplest tool for the job:
- **Small UI State** (e.g., simple toggles, active tabs): `StatefulWidget` or `StateProvider`
- **Derived Data** (e.g., filtered list of rooms from an already fetched list): `Provider`
- **Async Server Data** (e.g., fetching user profile): `AsyncNotifier`
- **Complex Stateful Logic** (e.g., multi-step forms, cart): `Notifier`

---

## 5. Daily Git / Commit Flow
If you work across both repos simultaneously, ensure the server and app are pushed cohesively to avoid state mismatch on environments.
1. `flutter analyze` & `serverpod analyze` (conceptually)
2. Commit server changes first, then flutter changes, or push them together if in a monorepo structure.
