import 'package:c001apk_flutter/router/app_pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  test('routes do not reveal the previous page during transitions', () {
    for (final page in AppPages.getPages) {
      expect(page.transition, Transition.noTransition, reason: page.name);
    }
  });
}
