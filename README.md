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

## Building an unsigned iOS IPA

The iOS app targets iOS 15 or later. A macOS host with Flutter 3.44.7 and
Xcode 26 is required.

```sh
flutter pub get
flutter analyze
flutter test
flutter build ios --release --no-codesign
./scripts/package_unsigned_ipa.sh
```

The resulting file is written to
`build/ios/ipa/c001apk-flutter-unsigned.ipa`. It is an unsigned development
artifact, not an App Store package, and must be signed before installation on
a physical device. The same build is available from the GitHub Actions run as
the `ios-unsigned-ipa` artifact.
