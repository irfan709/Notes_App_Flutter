import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/bookmark.dart';
import 'package:news_app/models/news_response_model.dart';
import 'package:news_app/provider/bookmark_provider.dart';

class ArticleDetails extends ConsumerStatefulWidget {
  final Article article;

  const ArticleDetails({super.key, required this.article});

  @override
  ConsumerState<ArticleDetails> createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends ConsumerState<ArticleDetails> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    final existing = ref
        .read(bookmarksProvider)
        .isBookmarked(widget.article.url);
    existing.then((value) {
      if (mounted) {
        setState(() {
          isBookmarked = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                isBookmarked = !isBookmarked;
              });

              final bookmark =
                  Bookmark()
                    ..sourceName = article.source.name
                    ..author = article.author
                    ..title = article.title
                    ..description = article.description
                    ..url = article.url
                    ..urlToImage = article.urlToImage
                    ..publishedAt = article.publishedAt
                    ..content = article.content;

              if (isBookmarked) {
                final added = await ref
                    .read(bookmarksProvider)
                    .addBookmark(bookmark);

                if (!added && context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Already bookmarked')));
                }
              } else {
                await ref.read(bookmarksProvider).removeBookmark(article.url);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Removed from bookmarks')),
                  );
                }
              }
            },
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_add_outlined,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  article.urlToImage!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
            else
              Image.asset(
                'assets/images/placeholder.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 12),
            Text(
              article.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat.yMMMMd().format(article.publishedAt),
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 24),
            Text(
              article.content ?? 'No content available.',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
