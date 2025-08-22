import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/provider/news_provider.dart';

import 'article_details.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                await showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(ref: ref),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search),
                    SizedBox(width: 8),
                    Text("Search news..."),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  final WidgetRef ref;

  CustomSearchDelegate({required this.ref});

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(
      onPressed: () {
        query = '';
        showSuggestions(context);
      },
      icon: Icon(Icons.clear),
    ),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    onPressed: () => close(context, ''),
    icon: Icon(Icons.arrow_back),
  );

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      final searchNewsStream = ref.watch(searchNewsProvider(query));
      return searchNewsStream.when(
        data: (news) {
          if (news.articles.isEmpty) {
            return Center(child: Text("No articles found"));
          }
          return ListView.builder(
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
          );
        },
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => Center(child: CircularProgressIndicator()),
      );
    } else {
      return Center(child: Text("Enter something to search..."));
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      final searchNewsStream = ref.watch(searchNewsProvider(query));
      return searchNewsStream.when(
        data: (news) {
          if (news.articles.isEmpty) {
            return Center(child: Text("No articles found"));
          }
          return ListView.builder(
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
                  query = article.title;
                  showResults(context);
                },
              );
            },
          );
        },
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => Center(child: CircularProgressIndicator()),
      );
    } else {
      return Center(child: Text("Enter something to search..."));
    }
  }
}
