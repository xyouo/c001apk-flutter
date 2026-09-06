import 'dart:convert';

import '../model/feed_article/feed_article.dart';

/// Selects the structured renderer for the feed detail body.
///
/// The structured body lives in `message_raw_output` and is returned by the
/// feed detail endpoint for many feed kinds (article, topic, digital, app,
/// etc.), not just a narrow set of `feedType` values. We therefore attempt the
/// structured parse for any non-empty/non-"null" payload and fall back to the
/// regular body only when parsing yields nothing. `parseFeedArticleBody`
/// already returns null for malformed/empty payloads, so an unconditional call
/// is both safe and strictly more complete than gating on a feed-type
/// whitelist.
List<FeedArticle>? parseStructuredFeedBody({
  required String? feedType,
  required String? rawBody,
}) {
  if (rawBody == null ||
      rawBody.trim().isEmpty ||
      rawBody.trim() == 'null') {
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
