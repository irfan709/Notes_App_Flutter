import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/news_provider.dart';
import 'article_details.dart';

class SportsNews extends ConsumerWidget {
  const SportsNews({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsStream = ref.watch(topHeadlinesProvider("sports"));
    return newsStream.when(
      data:
          (news) => ListView.builder(
            itemCount: news.articles.length,
            itemBuilder: (context, index) {
              final article = news.articles[index];
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
                              : const AssetImage(
                                    'assets/images/placeholder.jpg',
                                  )
                                  as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  article.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  article.description ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleDetails(article: article),
                    ),
                  );
                },
              );
            },
          ),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}
