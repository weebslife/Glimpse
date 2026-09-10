#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
cd "$DIR"

if [ ! -d "build/Release/Glimpse.app" ]; then
    ./scripts/build.sh
fi

DMG_DIR="$DIR/build/dmg"
DMG_PATH="$DIR/build/Release/Glimpse.dmg"

rm -rf "$DMG_DIR" "$DMG_PATH"
mkdir -p "$DMG_DIR"

cp -R "$DIR/build/Release/Glimpse.app" "$DMG_DIR/"
ln -s /Applications "$DMG_DIR/Applications"

hdiutil create -volname "Glimpse" -srcfolder "$DMG_DIR" -ov -format UDZO "$DMG_PATH"
rm -rf "$DMG_DIR"

echo "✅ DMG created successfully at: $DMG_PATH"
