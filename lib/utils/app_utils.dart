import 'package:flutter/material.dart';
import 'package:news_app/screens/all_news.dart';

import '../screens/business_news.dart';
import '../screens/entertainment_news.dart';
import '../screens/general_news.dart';
import '../screens/health_news.dart';
import '../screens/science_news.dart';
import '../screens/sports_news.dart';
import '../screens/technology_news.dart';

List<String> newsCategories = [
  'all',
  'science',
  'technology',
  'business',
  'entertainment',
  'sports',
  'health',
  'general',
];

final Map<String, Widget> categoryWidgetMap = {
  'all': AllNews(),
  'science': const ScienceNews(),
  'technology': const TechnologyNews(),
  'business': const BusinessNews(),
  'entertainment': const EntertainmentNews(),
  'sports': const SportsNews(),
  'health': const HealthNews(),
  'general': const GeneralNews(),
};

final baseUrl = 'https://newsapi.org/v2/top-headlines';

final apiKey = 'c062e314dab74fb8813e6c09a5776ea6';

final country = 'us';
