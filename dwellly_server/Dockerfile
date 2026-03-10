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

# 2. Strip Flutter-SDK-dependent entries from the workspace pubspec.
#    - dwellly_flutter: has flutter SDK packages, can't use plain dart pub get
#    - flutter_secure_storage in dependency_overrides: also needs Flutter SDK
RUN sed -i '/dwellly_flutter/d; /flutter_secure_storage/d' pubspec.yaml

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

# passwords.yaml is copied from the build stage (config/ directory above).
# It already contains correct production credentials committed to the repo.
# We do NOT overwrite it here — env-var substitution at RUN time doesn't work
# on Render because secret env vars are only available at container runtime.

# Ensure passwords.yaml exists with production credentials
RUN test -f config/passwords.yaml || echo "production:
  database: 'yZqLZmlrtncgcNJ3aaOf7YMGHtMwwNQL'
  serviceSecret: 'jCeW9V_zImKlTv1Sg76A6TpqGeCB0Ejo'
  emailSecretHashPepper: 'WnPg1ks_EiQsnNddES_yrG0-Rksll0ho'
  jwtHmacSha512PrivateKey: 'qP0XF6IaEhaFP8idQn-ehK98SHLEZd2c'
  jwtRefreshTokenHashPepper: 'zcXFvmuRqQrOWRucLASf5R_mV_DV4m6k'" > config/passwords.yaml

# This file is required to enable the endpoint log filter in Insights.
COPY --from=build /app/dwellly_server/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml

# Expose Serverpod ports
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

# Define the entrypoint command (shell form for env var expansion)
ENTRYPOINT ["sh", "-c", "./server --mode=$runmode --server-id=$serverid --logging=$logging --role=$role"]

