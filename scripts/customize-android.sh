#!/usr/bin/env bash
# Runs in CI after `npx cap add android`: applies Particulars icons and version numbers.
set -uo pipefail
echo "::warning::android/app contains: $(ls android/app 2>&1 | tr '\n' ' ')"
RES=android/app/src/main/res
mkdir -p "$RES"
if ! cp -R resources/android/. "$RES/"; then echo "::error::Copying icons failed"; exit 1; fi
GRADLE=""
if [ -f android/app/build.gradle ]; then GRADLE=android/app/build.gradle; fi
if [ -f android/app/build.gradle.kts ]; then GRADLE=android/app/build.gradle.kts; fi
CODE="${VERSION_CODE:-1}"
NAME="${VERSION_NAME:-1.0.$CODE}"
if [ -n "$GRADLE" ]; then
  sed -i -E "s/versionCode( *=)? *[0-9]+/versionCode\1 $CODE/" "$GRADLE"
  sed -i -E "s/versionName( *=)? *\"[^\"]*\"/versionName\1 \"$NAME\"/" "$GRADLE"
  echo "::warning::Version lines now: $(grep -E 'versionCode|versionName' "$GRADLE" | tr -s ' ' | tr '\n' ';')"
else
  echo "::warning::No app build.gradle found; version numbers left as default"
fi
exit 0
