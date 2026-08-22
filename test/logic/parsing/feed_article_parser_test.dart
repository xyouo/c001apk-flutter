import 'dart:convert';

import 'package:c001apk_flutter/logic/parsing/feed_article_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseFeedArticleBody', () {
    test('falls back for absent and invalid payloads', () {
      expect(parseFeedArticleBody(null), isNull);
      expect(parseFeedArticleBody(''), isNull);
      expect(parseFeedArticleBody('   '), isNull);
      expect(parseFeedArticleBody('null'), isNull);
      expect(parseFeedArticleBody('{bad json'), isNull);
      expect(parseFeedArticleBody('{"type":"text"}'), isNull);
      expect(parseFeedArticleBody('["not a map"]'), isNull);
    });

    test('parses supported entries and ignores unsupported entry types', () {
      final result = parseFeedArticleBody(jsonEncode([
        {'type': 'text', 'message': 'hello'},
        {'type': 'unsupported', 'message': 'ignored'},
        {'type': 'image', 'url': 'https://example.test/image.png'},
        {'type': 'shareUrl', 'title': 'link'},
      ]));

      expect(result, isNotNull);
      expect(result!.map((item) => item.type), ['text', 'image', 'shareUrl']);
      expect(result.first.message, 'hello');
    });

    test('accepts a valid empty list', () {
      expect(parseFeedArticleBody('[]'), isEmpty);
    });

    test('falls back when a supported field has the wrong type', () {
      expect(
        parseFeedArticleBody('[{"type":"text","message":42}]'),
        isNull,
      );
    });
  });
}
