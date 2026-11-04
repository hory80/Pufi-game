#!/bin/bash
# Start two opt-in test-host sessions. Run app_store_capture.py in another terminal.
set -euo pipefail
cd "$(dirname "$0")/.."
export PUFI_IPHONE_UDID="${PUFI_IPHONE_UDID:-1B2D97D2-6913-496A-8F5E-6B239431D19B}"
export PUFI_IPAD_UDID="${PUFI_IPAD_UDID:-3A8C2971-D302-4CB8-AF25-7E9C7AFE1F0F}"
capture_build_dir="${PUFI_CAPTURE_BUILD_DIR:-/tmp/PufiStoreBuild}"
./sync_web.sh
xcodegen
for capture_udid in "$PUFI_IPHONE_UDID" "$PUFI_IPAD_UDID"; do
    xcrun simctl boot "$capture_udid" 2>/dev/null || true
    xcrun simctl bootstatus "$capture_udid" -b
    xcodebuild -project PufiStars.xcodeproj -scheme PufiStars \
        -destination "platform=iOS Simulator,id=$capture_udid" \
        -derivedDataPath "$capture_build_dir" build-for-testing CODE_SIGNING_ALLOWED=NO
    xcrun simctl install "$capture_udid" "$capture_build_dir/Build/Products/Debug-iphonesimulator/PufiStars.app"
done
python3 - <<'PY'
import os,pathlib,subprocess
for name in ['PUFI_IPHONE_UDID','PUFI_IPAD_UDID']:
    container=subprocess.check_output(['xcrun','simctl','get_app_container',os.environ[name],'com.horace.pufistars','data'],text=True).strip()
    folder=pathlib.Path(container)/'Documents'/'AppStoreCapture'
    folder.mkdir(parents=True,exist_ok=True)
    for path in folder.iterdir():path.unlink()
    (folder/'enabled').touch()
PY
for capture_family in iphone ipad; do
    if [ "$capture_family" = iphone ]; then capture_udid="$PUFI_IPHONE_UDID"; else capture_udid="$PUFI_IPAD_UDID"; fi
    xcodebuild -project PufiStars.xcodeproj -scheme PufiStars \
        -destination "platform=iOS Simulator,id=$capture_udid" \
        -derivedDataPath "$capture_build_dir" -parallel-testing-enabled NO \
        -only-testing:PufiStarsTests/AppStoreCaptureTests/testCaptureSession \
        -test-timeouts-enabled NO -collect-test-diagnostics never \
        test-without-building CODE_SIGNING_ALLOWED=NO > "/tmp/pufi-capture-$capture_family.log" 2>&1 &
done
wait
