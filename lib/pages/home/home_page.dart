import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pages/home/app/app_list_page.dart';
import '../../pages/home/feed/home_feed_page.dart';
import '../../pages/home/return_top_controller.dart';
import '../../pages/home/topic/home_topic_page.dart';

// ignore: constant_identifier_names
enum TabType { FOLLOW, APP, FEED, HOT, TOPIC, PRODUCT, COOLPIC, NONE }

String homeTabLabel(TabType type) => switch (type) {
      TabType.FOLLOW => '关注',
      TabType.APP => '应用',
      TabType.FEED => '动态',
      TabType.HOT => '热榜',
      TabType.TOPIC => '话题',
      TabType.PRODUCT => '产品',
      TabType.COOLPIC => '酷图',
      TabType.NONE => '',
    };

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  final ReturnTopController _pageScrollController =
      Get.find<ReturnTopController>(tag: 'home');
  // late final _config = Provider.of<AppConfigProvider>(context, listen: false);
  // late bool _showFab = true; //_config.isLogin;

  final _tabList = TabType.values
      .where((type) => type != TabType.NONE)
      .map((type) => Tab(height: 34, text: homeTabLabel(type)))
      .toList();

  final _pages = [
    const HomeFeedPage(tabType: TabType.FOLLOW),
    if (Platform.isAndroid) const AppListPage(),
    const HomeFeedPage(tabType: TabType.FEED),
    const HomeFeedPage(tabType: TabType.HOT),
    const HomeTopicPage(tabType: TabType.TOPIC),
    const HomeTopicPage(tabType: TabType.PRODUCT),
    const HomeFeedPage(tabType: TabType.COOLPIC),
  ];

  void scrollToTop(int index) {
    _pageScrollController.setIndex(Platform.isAndroid
        ? index
        : index == 0
            ? 0
            : index + 1);
  }

  @override
  void initState() {
    super.initState();

    if (!Platform.isAndroid) {
      _tabList.removeAt(1);
    }

    _tabController = TabController(
      vsync: this,
      initialIndex: Platform.isAndroid ? 2 : 1,
      length: _tabList.length,
    );

    _pageScrollController.index.listen((index) {
      if (index == 998) {
        scrollToTop(_tabController.index);
      }
    });
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
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Container(
          height: 40,
          padding: const EdgeInsets.all(3),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TabBar(
            controller: _tabController,
            tabs: _tabList,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(17),
            ),
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor:
                Theme.of(context).colorScheme.onSurfaceVariant,
            labelPadding: const EdgeInsets.symmetric(horizontal: 14),
            splashBorderRadius: BorderRadius.circular(17),
            onTap: (index) {
              if (!_tabController.indexIsChanging) {
                scrollToTop(index);
              }
            },
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed('/search'),
            icon: const Icon(Icons.search),
            tooltip: 'Search',
          )
        ],
      ),
      body: TabBarView(controller: _tabController, children: _pages),
    );
  }
}
