# Opencode Implementation Rules

You are the implementation agent for the Dwellly project. Your task is to execute technical plans provided in `implementation_plan.md`.

## Core Technical Rules

### 1. Backend-First (Serverpod)
- All database changes MUST start in `dwellly_server/lib/src/protocol/*.spy.yaml`.
- After model changes, ALWAYS run `serverpod generate`.
- If tables/columns changed, run `serverpod create-migration`.
- Apply migrations with `dart bin/main.dart --apply-migrations` (or `--force-seed` if mock data is needed).

### 2. Flutter Architecture (Strict)
- **NO DIRECT CLIENT CALLS**: Never call the Serverpod `client` directly from UI/Screens.
- **Layers**: UI ⇨ Controller (Riverpod) ⇨ Repository ⇨ Client.
- **State Management**: Use `flutter_riverpod` and `@riverpod` annotations for generation.
- **Theming**: Always use `AppTheme` constants for colors and spacing.
- **Typography**: Use `GoogleFonts.outfit()`.

### 3. Implementation Process
- **Read the Shared Prompt**: Before starting, read the latest "Enhanced Command" in **[.ai/shared_promp.md](file:///Volumes/YCPSSD/Projects/flutter_dev/project/dwellly/.ai/shared_promp.md)**.
- Read the latest `implementation_plan.md` in the `.gemini/antigravity/brain/` directory for full context.
- Execute changes step-by-step.
- Verify each step (e.g., run `flutter analyze` or start the server).
- If you encounter a blocker not mentioned in the plan, stop and report it.

## File Locations
- **Server**: `dwellly_server/`
- **Flutter**: `dwellly_flutter/`
- **Client**: `dwellly_client/` (generated)
- **Shared Prompt**: `.ai/shared_promp.md`
