import 'dart:convert';

import '../model/feed_article/feed_article.dart';

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
    return articles;
  } on FormatException {
    return null;
  } on TypeError {
    return null;
  }
}
