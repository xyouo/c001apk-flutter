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

    test('falls back to the plain feed layout for an empty article list', () {
      expect(parseFeedArticleBody('[]'), isNull);
    });

    test('falls back when no supported article entries remain', () {
      expect(
        parseFeedArticleBody('[{"type":"unsupported","message":"ignored"}]'),
        isNull,
      );
    });

    test('falls back when a supported field has the wrong type', () {
      expect(
        parseFeedArticleBody('[{"type":"text","message":42}]'),
        isNull,
      );
    });
  });

  group('parseStructuredFeedBody', () {
    const body = '[{"type":"text","message":"article body"}]';

    test('ordinary feeds always use their plain message and image fields', () {
      expect(
        parseStructuredFeedBody(feedType: 'feed', rawBody: body),
        isNull,
      );
    });

    test('known structured feed types use the article payload', () {
      expect(
        parseStructuredFeedBody(feedType: 'feedArticle', rawBody: body),
        hasLength(1),
      );
      expect(
        parseStructuredFeedBody(feedType: 'trade', rawBody: body),
        hasLength(1),
      );
    });
  });
}
