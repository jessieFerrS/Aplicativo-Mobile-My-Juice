import 'package:appmyjuice/models/juice.dart';
import 'package:flutter/material.dart';

class MyTabBar extends StatelessWidget {
  final TabController tabController;

  const MyTabBar({
    super.key,
    required this.tabController,
  });

  List<Tab> _buildCategoryTabs() {
    return JuiceCategory.values.map((category) {
      return Tab(
        text: category.toString().split('.').last,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      labelColor: Theme.of(context).colorScheme.tertiary,
      unselectedLabelColor: Theme.of(context).colorScheme.tertiary,
      indicatorColor: Theme.of(context).colorScheme.background,
      tabs: _buildCategoryTabs(),
    );
  }
}