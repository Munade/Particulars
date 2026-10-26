#!/usr/bin/env bash
# Runs in CI after `npx cap add android`: applies Particulars icons and version numbers.
set -euo pipefail
RES=android/app/src/main/res
cp -R resources/android/. "$RES/"
GRADLE=android/app/build.gradle
CODE="${VERSION_CODE:-1}"
NAME="${VERSION_NAME:-1.0.$CODE}"
sed -i -E "s/versionCode [0-9]+/versionCode $CODE/" "$GRADLE"
sed -i -E "s/versionName \"[^\"]*\"/versionName \"$NAME\"/" "$GRADLE"
echo "Particulars android: versionCode=$CODE versionName=$NAME"
grep -E "versionCode|versionName|targetSdk" "$GRADLE" android/variables.gradle || true
