import 'package:flutter/material.dart';

import '../utils/app_utils.dart';

class CategoryNewsScreen extends StatelessWidget {
  final String category;

  const CategoryNewsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return categoryWidgetMap[category] ??
        Center(child: Text('Unknown category: $category'));
  }
}
