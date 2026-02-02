#!/usr/bin/env bash
# Run Healthy-O-Me Flutter app on Android emulator with a stable session.
# "Lost connection to device" usually happens when the run process is killed
# (e.g. IDE timeout). Run this script in your terminal and keep it open.

set -e
cd "$(dirname "$0")"

# Ensure ADB is running (skip if you get permission errors)
echo "Checking ADB..."
adb start-server 2>/dev/null || true

# Start emulator if no Android device is present
if ! adb devices | grep -qE 'emulator-[0-9]+\s+device'; then
  echo "No Android emulator running. Launching Pixel_9_Pro..."
  flutter emulators --launch Pixel_9_Pro
  echo "Waiting for emulator to boot (up to 60s)..."
  for i in $(seq 1 30); do
    if adb devices | grep -qE 'emulator-[0-9]+\s+device'; then
      echo "Emulator ready."
      break
    fi
    sleep 2
  done
fi

# Wait for device to be fully ready (boot complete)
adb wait-for-device
adb shell "while [[ -z \$(getprop sys.boot_completed) ]]; do sleep 2; done" 2>/dev/null || true
sleep 3

# Use Google DNS in emulator so dev.healthyome.com (Django backend) resolves
echo "Setting emulator DNS for dev.healthyome.com..."
adb shell "setprop net.dns1 8.8.8.8; setprop net.dns2 8.8.4.4" 2>/dev/null || true

# Run app — uses https://dev.healthyome.com/api/shop (same API as web app)
# Optional override: API_BASE_URL=http://10.0.2.2:8000/api/shop ./run_android.sh
EXTRA_ARGS=()
[[ -n "$API_BASE_URL" ]] && EXTRA_ARGS+=(--dart-define=API_BASE_URL="$API_BASE_URL")
echo "Starting Flutter app (keep this terminal open for hot reload)..."
exec flutter run -d emulator-5554 "${EXTRA_ARGS[@]}"
