#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
cd "$DIR"

echo "🔨 Building Glimpse for macOS..."

xcodebuild \
  -project Glimpse.xcodeproj \
  -target Glimpse \
  -configuration Release \
  CODE_SIGN_IDENTITY="-" \
  build

echo "✅ Build complete! App is ready at:"
echo "   $DIR/build/Release/Glimpse.app"
