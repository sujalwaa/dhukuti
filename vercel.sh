#!/bin/bash
echo "Downloading Flutter..."
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

echo "Building Flutter Web App..."
flutter pub get
flutter build web --release
