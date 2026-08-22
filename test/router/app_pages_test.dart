import 'package:c001apk_flutter/router/app_pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  test('feed detail does not slide horizontally into view', () {
    final feedPage = AppPages.getPages.singleWhere(
      (page) => page.name == '/feed/:id',
    );

    expect(feedPage.transition, Transition.fadeIn);
  });
}
