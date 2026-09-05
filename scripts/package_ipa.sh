#!/bin/bash
set -euo pipefail

readonly ARCHIVE_APP_DIR="build/ios/archive/Runner.xcarchive/Products/Applications"
readonly DEVICE_APP_DIR="build/ios/iphoneos"
readonly OUTPUT_DIR="build/ios/ipa"
readonly OUTPUT_IPA="${OUTPUT_DIR}/c001apk-flutter.ipa"

if [[ -d "${ARCHIVE_APP_DIR}" ]]; then
  readonly APP_DIR="${ARCHIVE_APP_DIR}"
else
  readonly APP_DIR="${DEVICE_APP_DIR}"
fi

apps=()
while IFS= read -r candidate; do
  apps+=("${candidate}")
done < <(find "${APP_DIR}" -maxdepth 1 -type d -name '*.app' -print)
if [[ ${#apps[@]} -ne 1 ]]; then
  echo "Expected exactly one .app in ${APP_DIR}, found ${#apps[@]}." >&2
  exit 1
fi

readonly app="${apps[0]}"
if [[ ! -f "${app}/Info.plist" ]]; then
  echo "Built app is missing Info.plist: ${app}" >&2
  exit 1
fi
if [[ -e "${app}/embedded.mobileprovision" ]]; then
  echo "Built app unexpectedly contains a provisioning profile." >&2
  exit 1
fi
if codesign --verify --deep --strict "${app}" >/dev/null 2>&1; then
  echo "Built app is signed; cannot package it as a plain IPA." >&2
  exit 1
fi

rm -rf "${OUTPUT_DIR}/Payload"
mkdir -p "${OUTPUT_DIR}/Payload"
ditto "${app}" "${OUTPUT_DIR}/Payload/$(basename "${app}")"
rm -f "${OUTPUT_IPA}"
(
  cd "${OUTPUT_DIR}"
  /usr/bin/zip -qry "$(basename "${OUTPUT_IPA}")" Payload
)

unzip -tq "${OUTPUT_IPA}"
readonly ipa_entries="$(unzip -Z1 "${OUTPUT_IPA}")"
if ! grep -Eq '^Payload/[^/]+\.app/Info\.plist$' <<< "${ipa_entries}"; then
  echo "IPA is missing Payload/<app>.app/Info.plist." >&2
  exit 1
fi
if grep -Eq '(^|/)embedded\.mobileprovision$' <<< "${ipa_entries}"; then
  echo "IPA unexpectedly contains a provisioning profile." >&2
  exit 1
fi

echo "Created IPA: ${OUTPUT_IPA}"
