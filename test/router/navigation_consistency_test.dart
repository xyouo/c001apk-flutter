import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('page navigation does not reintroduce custom dialog transitions', () {
    final dartFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    for (final file in dartFiles) {
      final source = file.readAsStringSync();
      expect(source, isNot(contains('GetDialogRoute(')), reason: file.path);
    }
  });
}
