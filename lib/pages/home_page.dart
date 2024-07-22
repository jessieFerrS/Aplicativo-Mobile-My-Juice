import 'package:appmyjuice/components/my_juice_tile.dart';
import 'package:appmyjuice/models/juice.dart';
import 'package:appmyjuice/models/juice_house.dart';
import 'package:flutter/material.dart';
import 'package:appmyjuice/components/my_tab_bar.dart';
import 'package:appmyjuice/components/my_current_location.dart';
import 'package:appmyjuice/components/my_description_box.dart';
import 'package:appmyjuice/components/my_drawer.dart';
import 'package:appmyjuice/components/my_sliver_app_bar.dart';
import 'package:provider/provider.dart';
import 'juice_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  // tab controller
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: JuiceCategory.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Juice> _filterMenuByCategory(JuiceCategory category, List<Juice> fullMenu) {
    return fullMenu.where((juice) => juice.category == category).toList();
  }

  List<Widget> getJuiceThisCategory(List<Juice> fullMenu) {
    return JuiceCategory.values.map((category) {

      List<Juice> categoryMenu = _filterMenuByCategory(category, fullMenu);

      return ListView.builder(
        itemCount: categoryMenu.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemBuilder:(context, index) {
          final juice = categoryMenu[index];

          return JuiceTile(
            juice: juice,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JuicePage(juice: juice),
                )
            ),
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      drawer: const MyDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          MySliverAppBar(
            title: MyTabBar(tabController: _tabController),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyCurrentLocation(),
                      const MyDescriptionBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        body: Consumer<JuiceHouse>(
          builder: (context, juiceHouse, child) {
            if (juiceHouse.menu == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                        strokeWidth: 10,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Carregando',
                      style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }
            else {
              return TabBarView(
                controller: _tabController,
                children: getJuiceThisCategory(juiceHouse.menu!),
              );
            }
          },
        ),
      ),
    );
  }
}

