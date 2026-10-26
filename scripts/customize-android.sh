#!/usr/bin/env bash
# Runs in CI after `npx cap add android`: applies Particulars icons and version numbers.
set -euo pipefail
echo "Android project files:"; ls android android/app || true
RES=android/app/src/main/res
mkdir -p "$RES"
cp -R resources/android/. "$RES/"
GRADLE=""
for f in android/app/build.gradle android/app/build.gradle.kts; do [ -f "$f" ] && GRADLE="$f"; done
CODE="${VERSION_CODE:-1}"
NAME="${VERSION_NAME:-1.0.$CODE}"
if [ -n "$GRADLE" ]; then
  sed -i -E "s/versionCode( *=)? *[0-9]+/versionCode\1 $CODE/" "$GRADLE"
  sed -i -E "s/versionName( *=)? *\"[^\"]*\"/versionName\1 \"$NAME\"/" "$GRADLE"
  grep -nE "versionCode|versionName" "$GRADLE" || true
else
  echo "::warning::No app build.gradle found; version numbers left as default"
fi
echo "Particulars android: versionCode=$CODE versionName=$NAME"
