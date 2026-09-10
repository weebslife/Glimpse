#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
cd "$DIR"

if [ ! -d "build/Release/Glimpse.app" ]; then
    ./scripts/build.sh
fi

echo "🚀 Launching Glimpse in macOS Menu Bar..."
open "$DIR/build/Release/Glimpse.app"
echo "✨ Glimpse is running! Look for the camera icon in your macOS menu bar."
