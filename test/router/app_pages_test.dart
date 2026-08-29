import 'package:c001apk_flutter/router/app_pages.dart';
import 'package:c001apk_flutter/router/opaque_content_transition.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  test('routes use an opaque custom transition', () {
    for (final page in AppPages.getPages) {
      expect(page.transition, Transition.custom, reason: page.name);
      expect(
        page.customTransition,
        isA<OpaqueContentTransition>(),
        reason: page.name,
      );
    }
  });
}
