# ─────────────────────────────────────────────────────────────────────────────
# Build stage
# NOTE: rootDir in render.yaml is "." so the Docker build context is the repo
#       root. We must copy the workspace root pubspec.yaml, dwellly_server/,
#       AND dwellly_client/ because dwellly_server uses "resolution: workspace".
# ─────────────────────────────────────────────────────────────────────────────
FROM dart:3.8.0 AS build

WORKDIR /app

# 1. Copy the workspace root pubspec first (needed for workspace resolution).
COPY pubspec.yaml .

# 2. Strip dwellly_flutter from the workspace list.
#    The root pubspec.yaml lists dwellly_flutter as a workspace member, but it
#    has Flutter SDK dependencies that can't be resolved with plain `dart pub get`.
#    We only need dwellly_server + dwellly_client for the server binary.
RUN sed -i '/dwellly_flutter/d' pubspec.yaml

# 3. Copy the server and client packages only.
COPY dwellly_server/ dwellly_server/
COPY dwellly_client/ dwellly_client/

# 4. Resolve workspace dependencies (server + client only, no Flutter).
RUN dart pub get

# 5. Compile the server executable.
WORKDIR /app/dwellly_server
RUN dart compile exe bin/main.dart -o bin/server

# ─────────────────────────────────────────────────────────────────────────────
# Final / runtime stage — keep it tiny with Alpine
# ─────────────────────────────────────────────────────────────────────────────
FROM alpine:latest

# Environment variables (can be overridden at runtime via Render)
ENV runmode=production
ENV serverid=default
ENV logging=normal
ENV role=monolith

# Copy Dart runtime libraries
COPY --from=build /runtime/ /

# Copy compiled server executable
COPY --from=build /app/dwellly_server/bin/server server

# Copy configuration files and resources
COPY --from=build /app/dwellly_server/config/ config/
COPY --from=build /app/dwellly_server/web/ web/
COPY --from=build /app/dwellly_server/migrations/ migrations/

# This file is required to enable the endpoint log filter in Insights.
COPY --from=build /app/dwellly_server/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml

# Expose Serverpod ports
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

# Define the entrypoint command
ENTRYPOINT ["./server", "--mode=$runmode", "--server-id=$serverid", "--logging=$logging", "--role=$role"]

