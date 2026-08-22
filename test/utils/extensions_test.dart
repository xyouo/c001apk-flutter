import 'package:c001apk_flutter/utils/extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('unique keeps items without an identity key', () {
    final values = ['first-null', 'second-null', 'duplicate', 'duplicate'];

    final result = values.unique(
      (value) => value.endsWith('null') ? null : value,
      false,
    );

    expect(result, ['first-null', 'second-null', 'duplicate']);
    expect(values, hasLength(4));
  });
}
