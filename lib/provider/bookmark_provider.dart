import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/database/bookmark_service.dart';
import 'package:news_app/models/bookmark.dart';

import '../main.dart';

class BookmarkProvider {
  final BookmarkService bookmark;

  BookmarkProvider({required this.bookmark});

  Stream<List<Bookmark>> getBookmarkNews() {
    return bookmark.getAllBookmarks();
  }

  Future<bool> addBookmark(Bookmark article) async {
    return await bookmark.addBookmark(article);
  }

  Future<void> removeBookmark(String url) async {
    return bookmark.removeBookmarkByUrl(url);
  }

  Future<bool> isBookmarked(String url) async {
    return bookmark.isBookmarked(url);
  }
}

final bookmarkHelperProvider = Provider((ref) {
  return BookmarkService(isar: isar);
});

final bookmarksProvider = Provider((ref) {
  final bookmark = ref.watch(bookmarkHelperProvider);
  return BookmarkProvider(bookmark: bookmark);
});

final bookmarkNewsStream = StreamProvider((ref) {
  final news = ref.watch(bookmarkHelperProvider).getAllBookmarks();
  return news;
});
