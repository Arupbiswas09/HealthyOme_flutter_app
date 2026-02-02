#!/usr/bin/env bash
# Run Healthy-O-Me Flutter app on iOS Simulator.
# If you get "CodeSign failed": open ios/Runner.xcworkspace in Xcode, select Runner target
# → Signing & Capabilities → check "Automatically manage signing" and choose your Team.

set -e
cd "$(dirname "$0")"

# Start iOS Simulator if no device present
if ! xcrun simctl list devices booted | grep -q .; then
  echo "Launching iOS Simulator..."
  open -a Simulator
  echo "Waiting for simulator to boot (up to 30s)..."
  sleep 15
fi

# Run app (use first available iOS simulator if multiple)
echo "Starting Flutter app on iOS Simulator..."
exec flutter run -d "iPhone"
