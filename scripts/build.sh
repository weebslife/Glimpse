#!/bin/bash
set -e

if [ -z "$DEVELOPER_DIR" ] && [ -d "/Applications/Xcode.app/Contents/Developer" ]; then
    export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
fi

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
