# An example of using a custom Dockerfile with Dart Frog
# Official Dart image: https://hub.docker.com/_/dart
# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.17)
FROM --platform=amd64 dart:stable AS build 

WORKDIR /app

# Resolve app dependencies.
RUN dart pub global activate very_good_cli
RUN dart pub global run very_good_cli:very_good packages get -r

# Copy app source code and AOT compile it.
COPY . .

# Generate a production build.
RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

# Ensure packages are still up-to-date if anything has changed.
RUN dart pub get --offline
RUN dart compile exe build/bin/server.dart -o build/bin/server

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/build/bin/server /app/bin/
COPY --from=build /app/build/public /public/
COPY --from=build /app/build/templates /templates/

# Start the server.
CMD ["/app/bin/server"]