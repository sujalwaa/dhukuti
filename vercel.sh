#!/bin/bash
set -e
echo "Downloading Flutter..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:`pwd`/flutter/bin"

echo "Configuring Flutter..."
flutter config --no-analytics
flutter config --enable-web

echo "Building Flutter Web App..."
flutter pub get
flutter build web --release
