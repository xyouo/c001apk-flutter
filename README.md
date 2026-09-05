# c001apk-flutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Credits:
- [pilipala](https://github.com/guozhigq/pilipala)

## Building an iOS IPA

The iOS app targets iOS 15 or later. A macOS host with Flutter 3.44.7 and
Xcode 26 is required.

```sh
flutter pub get
flutter analyze
flutter test
flutter build ios --release --no-codesign --config-only
(cd ios && pod install)
xcodebuild archive \
  -workspace ios/Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -sdk iphoneos \
  -destination 'generic/platform=iOS' \
  -archivePath build/ios/archive/Runner.xcarchive \
  CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY=
./scripts/package_ipa.sh
```

The resulting file is written to
`build/ios/ipa/c001apk-flutter.ipa`. It is a development
artifact, not an App Store package, and must be signed before installation on
a physical device. On every push to `main`, the build is uploaded to GitHub
Actions as the `ios-ipa` artifact and attached to a `ci-<commit-sha>` Release.
