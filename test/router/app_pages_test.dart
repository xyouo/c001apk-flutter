import 'package:c001apk_flutter/router/app_pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  test('routes use the native lightweight transition', () {
    for (final page in AppPages.getPages) {
      expect(page.transition, Transition.native, reason: page.name);
      expect(page.customTransition, isNull, reason: page.name);
    }
  });

  test('removed parameter editor is not routable', () {
    expect(
      AppPages.getPages.map((page) => page.name),
      isNot(contains('/params')),
    );
  });
}
