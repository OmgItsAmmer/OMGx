# Use the official Dart image as the base
FROM dart:stable AS build

# Set the working directory
WORKDIR /app

# Copy the pubspec files
COPY pubspec.* ./

# Install Flutter dependencies and download the Flutter SDK
# RUN apt-get update && apt-get install -y curl git unzip xz-utils && \
#     curl -fsSL https://storage.googleapis.com/download.flutter.dev/flutter_linux_stable.tar.xz | tar xJf - -C /app && \
#     export PATH="$PATH:/app/flutter/bin" && \
#     flutter config --no-analytics && \
    # flutter pub get

# Build the project
RUN flutter build apk --release
