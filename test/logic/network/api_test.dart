import 'package:c001apk_flutter/logic/network/api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('home feed uses the primary API host', () {
    expect(Api.getHomeFeed, 'https://api.coolapk.com/v6/main/indexV8');
  });
}
