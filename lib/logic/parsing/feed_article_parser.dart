import 'dart:convert';

import '../model/feed_article/feed_article.dart';

const _structuredFeedTypes = {'feedArticle', 'trade'};

/// Selects the structured renderer only for feed types that actually use it.
/// Ordinary feeds may still return `message_raw_output`, including `[]`, but
/// their visible body lives in the `message` and `picArr` fields.
List<FeedArticle>? parseStructuredFeedBody({
  required String? feedType,
  required String? rawBody,
}) {
  if (!_structuredFeedTypes.contains(feedType)) {
    return null;
  }
  return parseFeedArticleBody(rawBody);
}

/// Parses the structured body returned by the feed detail endpoint.
///
/// A null result means the payload cannot be rendered as a structured article
/// and the caller should fall back to the regular feed body.
List<FeedArticle>? parseFeedArticleBody(String? rawBody) {
  if (rawBody == null || rawBody.trim().isEmpty || rawBody.trim() == 'null') {
    return null;
  }

  try {
    final dynamic decoded = jsonDecode(rawBody);
    if (decoded is! List) {
      return null;
    }

    final articles = <FeedArticle>[];
    for (final dynamic item in decoded) {
      if (item is! Map) {
        return null;
      }

      final json = <String, dynamic>{};
      for (final MapEntry<dynamic, dynamic> entry in item.entries) {
        if (entry.key is! String) {
          return null;
        }
        json[entry.key as String] = entry.value;
      }

      final article = FeedArticle.fromJson(json);
      if (const {'text', 'image', 'shareUrl'}.contains(article.type)) {
        articles.add(article);
      }
    }
    return articles.isEmpty ? null : articles;
  } on FormatException {
    return null;
  } on TypeError {
    return null;
  }
}
