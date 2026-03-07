# Enhanced Opencode Command - Melos Chat Monorepo Reset

This command initializes Melos and modularizes the Chat feature into a dedicated package.

## 1. Melos Infrastructure
Create `melos.yaml` in the root:
```yaml
name: dwellly
repository: https://github.com/ChanPenhYorn/Room-Rental

packages:
  - dwellly_client
  - dwellly_server
  - dwellly_flutter
  - packages/*

command:
  bootstrap:
    runPubGetInParallel: true
    usePubspecOverrides: true

scripts:
  gen:
    name: "Serverpod Generate"
    run: cd dwellly_server && serverpod generate
  bs:
    name: "Bootstrap"
    run: melos bootstrap
  analyze:
    run: melos exec -- "flutter analyze ."
```

## 2. Initialize Chat Package
Create `packages/dwellly_chat/pubspec.yaml`:
```yaml
name: dwellly_chat
description: Modular Chat Feature for Dwellly
version: 0.0.1
publish_to: none

environment:
  sdk: "^3.8.0"
  flutter: "^3.32.0"

dependencies:
  flutter:
    sdk: flutter
  dwellly_client:
    path: ../../dwellly_client
  flutter_riverpod: ^2.5.1
  google_fonts: ^6.2.1
  # Add other necessary dependencies transferred from dwellly_flutter
```

## 3. Migrate Chat Code
Move the following files from `dwellly_flutter` to `packages/dwellly_chat`:
- `lib/features/social/presentation/screens/chat_detail_screen.dart` -> `lib/src/presentation/screens/chat_detail_screen.dart`
- `lib/features/social/presentation/screens/chat_list_screen.dart` -> `lib/src/presentation/screens/chat_list_screen.dart`

## 4. Update Main App
Add `dwellly_chat` to `dwellly_flutter/pubspec.yaml`:
```yaml
dependencies:
  dwellly_chat:
    path: ../packages/dwellly_chat
```

## 5. Bootstrap
Run `melos bootstrap` to link all packages.
