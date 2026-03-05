---
description: Implement new feature using Dwellly Architecture
---

# Dwellly Master Development Workflow
**Flutter + Serverpod — Reference**  
**Last updated: March 2026**

## Prompt / AI Assistant Usage Modes (for LLMs / agents)
When this document (or parts of it) is given to an AI, **automatically choose the lightest appropriate mode** according to these rules — **do not use tools/search unless really necessary**:

- **Light / direct mode** (default – 90%+ of questions)  
  Use internal knowledge only. No tools, no web search, no X search, no code execution.  
  Answer concisely, clearly, directly.  
  Applies to:  
  - questions about this workflow itself  
  - explaining concepts written here  
  - suggesting small improvements/refactors inside the described architecture  
  - asking “what does this rule mean?”, “why this order?”, “is this still best practice?”  
  - simple comparisons (Riverpod 2 vs 3, Serverpod 2 vs 3, etc.) when no very recent breaking change is suspected

- **Verification / update mode** (use only when clearly needed)  
  Allowed: web search, browse page, pub.dev / GitHub lookup  
  Use when the question is about:  
  - current latest versions (Serverpod, Flutter, Riverpod, Dart) in March 2026 or later  
  - “has anything changed since March 2026?”  
  - known breaking changes / migration guides  
  - new recommended best practices that post-date this document

- **Heavy / research mode** (rare – only when explicitly asked)  
  Use X search, deep github commit history, multiple sources, long reasoning chains  
  Triggered only by phrases like:  
  - “deep research”, “find latest discussions”, “what do people on X / Reddit say”,  
  - “analyze open issues / PRs”, “compare with other backends 2026”

**Default assumption**: unless the question clearly matches “Verification” or “Heavy” criteria → stay in **Light / direct mode**.  
Be conservative with tool usage — save tokens and time.

---

**Serverpod v2.x • Flutter 3.24+ • Riverpod 2.5+**  
(versions are likely outdated — see Verification mode above)

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