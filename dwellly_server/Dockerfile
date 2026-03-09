# Build stage
FROM dart:3.8.0 AS build
WORKDIR /app

# Copy the top-level workspace pubspec
COPY pubspec.yaml .

# Copy the server, client, and any other needed local packages
# (We don't need dwellly_flutter for the server binary)
COPY dwellly_server/ dwellly_server/
COPY dwellly_client/ dwellly_client/

WORKDIR /app/dwellly_server

# Install dependencies and compile the server executable
RUN dart pub get
RUN dart compile exe bin/main.dart -o bin/server
# Final stage
FROM alpine:latest

# Environment variables
ENV runmode=production
ENV serverid=default
ENV logging=normal
ENV role=monolith

# Copy runtime dependencies
COPY --from=build /runtime/ /

# Copy compiled server executable
COPY --from=build /app/bin/server server

# Copy configuration files and resources
COPY --from=build /app/config/ config/
COPY --from=build /app/web/ web/
COPY --from=build /app/migrations/ migrations/

# This file is required to enable the endpoint log filter in Insights.
COPY --from=build /app/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml

# Custom entrypoint for dynamic configuration on Render
COPY --from=build /app/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose ports
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

# Define the entrypoint command
ENTRYPOINT ["/entrypoint.sh"]
