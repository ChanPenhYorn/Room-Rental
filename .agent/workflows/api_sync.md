---
description: Sync Serverpod API (Generate & Restart)
---

This workflow ensures that the Serverpod client code is regenerated and the server is restarted whenever changes are made to the backend protocols or endpoints.

1. Navigate to the server directory.
2. Run `serverpod generate` to update the protocol and client code.
// turbo
3. Run `dart bin/main.dart --apply-migrations` to apply any database changes and restart the server.
4. If there were protocol changes, navigate to the flutter project and ensure dependencies are up to date.
// turbo
5. Run `flutter pub get` in the flutter project.