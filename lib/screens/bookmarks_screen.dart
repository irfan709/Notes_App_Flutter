import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/provider/bookmark_provider.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksStream = ref.watch(bookmarkNewsStream);
    return bookmarksStream.when(
      data: (news) {
        if (news.isEmpty) {
          return Center(
            child: Text(
              "No bookmarks yet",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          );
        }
        return ListView.builder(
          itemCount: news.length,
          itemBuilder: (context, index) {
            final article = news[index];
            return ListTile(
              leading: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image:
                        article.urlToImage != null
                            ? NetworkImage(article.urlToImage!)
                            : const AssetImage('assets/images/placeholder.jpg')
                                as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                article.title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                article.description ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: Icon(Icons.bookmark_remove),
                onPressed: () async {
                  await ref
                      .read(bookmarksProvider)
                      .removeBookmark(article.url!);
                },
              ),
              onTap: () {},
            );
          },
        );
      },
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}
