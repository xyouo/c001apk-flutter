import 'package:c001apk_flutter/router/app_pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  test('feed detail does not reveal the previous page during transitions', () {
    final feedPage = AppPages.getPages.singleWhere(
      (page) => page.name == '/feed/:id',
    );

    expect(feedPage.transition, Transition.noTransition);
  });
}
