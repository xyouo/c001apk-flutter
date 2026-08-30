import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('settings refreshes after loading the real package version', () {
    final source =
        File('lib/pages/settings/settings_page.dart').readAsStringSync();

    expect(source, isNot(contains("String _version = '1.0.0(1)'")));
    expect(source, contains('setState(() {'));
    expect(source, contains('_versionReady = _getVersionInfo();'));
  });
}
