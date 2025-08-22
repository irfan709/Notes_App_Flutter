import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/news_response_model.dart';
import 'package:news_app/service/http_service.dart';

class NewsProvider {
  final HttpService service;

  NewsProvider({required this.service});

  Stream<NewsApiResponse> getTopHeadlines({String? category}) {
    return service.getTopHeadlines(category: category);
  }

  Stream<NewsApiResponse> searchNews(String query) {
    return service.searchNews(query);
  }
}

final httpServiceProvider = Provider<HttpService>((ref) => HttpService());

final newsProvider = Provider<NewsProvider>(
  (ref) => NewsProvider(service: ref.read(httpServiceProvider)),
);

final topHeadlinesProvider = StreamProvider.family<NewsApiResponse, String?>((
  ref,
  category,
) {
  final newsService = ref.watch(newsProvider);
  return newsService.getTopHeadlines(category: category);
});

final searchNewsProvider = StreamProvider.family<NewsApiResponse, String>((
  ref,
  query,
) {
  final newsService = ref.watch(newsProvider);
  return newsService.searchNews(query);
});
