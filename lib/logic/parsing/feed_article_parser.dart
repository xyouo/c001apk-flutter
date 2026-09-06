import 'dart:convert';

import '../model/feed_article/feed_article.dart';

/// Selects the structured renderer for the feed detail body.
///
/// Ordinary dynamic feeds (`feedType == "feed"`) keep their visible body in
/// the `message` and `picArr` fields and always use the plain layout. Every
/// other feed kind (article, article/trade, photo, topic long-form, etc.)
/// carries its renderable body in `message_raw_output`, so we attempt the
/// structured parse for them whenever the payload is non-empty/non-"null".
/// `parseFeedArticleBody` already returns null for malformed/empty payloads,
/// so for those we fall back to the regular body safely.
List<FeedArticle>? parseStructuredFeedBody({
  required String? feedType,
  required String? rawBody,
}) {
  // Plain dynamic: body lives in `message`/`picArr`, never in
  // `message_raw_output`. Keep the regular card.
  if (feedType == 'feed') {
    return null;
  }
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
