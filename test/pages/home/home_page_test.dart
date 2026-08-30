import 'dart:io';

import 'package:c001apk_flutter/pages/home/home_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('home tabs use Chinese labels', () {
    expect(homeTabLabel(TabType.FOLLOW), '关注');
    expect(homeTabLabel(TabType.APP), '应用');
    expect(homeTabLabel(TabType.FEED), '动态');
    expect(homeTabLabel(TabType.HOT), '热榜');
    expect(homeTabLabel(TabType.TOPIC), '话题');
    expect(homeTabLabel(TabType.PRODUCT), '产品');
    expect(homeTabLabel(TabType.COOLPIC), '酷图');
  });

  test('publishing and reply composition stay removed', () {
    expect(File('lib/pages/feed/reply/reply_page.dart').existsSync(), isFalse);
    expect(File('lib/pages/feed/reply/reply_dialog.dart').existsSync(), isFalse);

    final dartFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    for (final file in dartFiles) {
      final source = file.readAsStringSync();
      expect(source, isNot(contains('Create Feed')), reason: file.path);
      expect(source, isNot(contains("tooltip: 'Reply'")), reason: file.path);
      expect(source, isNot(contains('onReply:')), reason: file.path);
    }
  });
}
