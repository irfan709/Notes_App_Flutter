import 'dart:convert';

import 'package:news_app/models/news_response_model.dart';
import 'package:http/http.dart' as http;

import '../utils/app_utils.dart';

class HttpService {
  Stream<NewsApiResponse> getTopHeadlines({String? category}) async* {
    String url = '$baseUrl?country=$country&apiKey=$apiKey';

    if (category != null && category.isNotEmpty) {
      url += '&category=$category';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      yield NewsApiResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to load top headlines: ${response.statusCode}');
    }
  }

  Stream<NewsApiResponse> searchNews(String query) async* {
    final String url =
        'https://newsapi.org/v2/everything?q=$query&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      yield NewsApiResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to search news: ${response.statusCode}');
    }
  }
}
