import 'package:flutter/material.dart';
import 'package:news_app/utils/app_utils.dart';

import 'category_screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final List<Tab> _tabs;
  late final List<Widget> _tabViews;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: newsCategories.length,
      vsync: this,
      initialIndex: 0,
    );

    _tabs =
        newsCategories
            .map(
              (category) => Tab(
                child: Text(category[0].toUpperCase() + category.substring(1)),
              ),
            )
            .toList();

    _tabViews =
        newsCategories
            .map((category) => CategoryNewsScreen(category: category))
            .toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorWeight: 4,
          indicatorColor: Colors.green,
          indicatorAnimation: TabIndicatorAnimation.elastic,
          isScrollable: true,
          tabs: _tabs,
        ),
      ),
      body: TabBarView(controller: _tabController, children: _tabViews),
    );
  }
}
