import 'package:isar/isar.dart';

import '../models/bookmark.dart';

class BookmarkService {
  final Isar _isar;

  BookmarkService({required Isar isar}) : _isar = isar;

  // Future<void> addBookmark(Bookmark article) async {
  //   final exists = await isBookmarked(article.url!);
  //   if (!exists) {
  //     await _isar.writeTxn(() => _isar.bookmarks.put(article));
  //   }
  // }

  Future<bool> addBookmark(Bookmark article) async {
    final exists = await isBookmarked(article.url!);
    if (!exists) {
      await _isar.writeTxn(() => _isar.bookmarks.put(article));
      return true; // added successfully
    }
    return false; // already exists
  }

  Future<void> removeBookmarkByUrl(String url) async {
    final article = await _isar.bookmarks.filter().urlEqualTo(url).findFirst();
    if (article != null) {
      await _isar.writeTxn(() => _isar.bookmarks.delete(article.id));
    }
  }

  Future<bool> isBookmarked(String url) async {
    final article = await _isar.bookmarks.filter().urlEqualTo(url).findFirst();
    return article != null;
  }

  Stream<List<Bookmark>> getAllBookmarks() {
    return _isar.bookmarks.where().sortByPublishedAtDesc().watch(
      fireImmediately: true,
    );
  }
}
