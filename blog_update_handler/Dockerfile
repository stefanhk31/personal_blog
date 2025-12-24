# Dockerfile for blog_update_handler scheduled job
# Build from repo root: docker build -f packages/blog_update_handler/Dockerfile .
# Official Dart image: https://hub.docker.com/_/dart
FROM --platform=amd64 dart:stable AS build

WORKDIR /app

# Copy the entire project
COPY . .

# Resolve app dependencies.
RUN ./get_packages.sh

# Create output directory and compile the blog_update_handler as an executable.
RUN mkdir -p build/bin && dart compile exe blog_update_handler/lib/main.dart -o build/bin/blog_update_handler

# Build minimal image from AOT-compiled executable and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/build/bin/blog_update_handler /app/bin/

# Run the handler (executes once and exits).
CMD ["/app/bin/blog_update_handler"]
