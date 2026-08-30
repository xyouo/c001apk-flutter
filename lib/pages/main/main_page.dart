import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../pages/home/return_top_controller.dart';
import '../../pages/home/home_page.dart';
import '../../pages/main/main_controller.dart';
import '../../pages/message/message_page.dart';
import '../../pages/settings/settings_page.dart';
import '../../utils/storage_util.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ReturnTopController _pageScrollController =
      Get.put(ReturnTopController(), tag: 'home');
  int _selectedIndex = 0;
  late final MainController _mainController = Get.put(MainController());
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _mainController.checkLoginInfo();
  }

  @override
  void dispose() async {
    _pageController.dispose();
    await GStorage.close();
    Get.delete<ReturnTopController>(tag: 'home');
    Get.delete<MainController>();
    super.dispose();
  }

  void onBackPressed() async {
    if (_selectedIndex != 0) {
      onDestinationSelected(0);
    } else {
      if (Platform.isAndroid) {
        AndroidIntent intent = const AndroidIntent(
          action: 'android.intent.action.MAIN',
          flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
          category: 'android.intent.category.HOME',
        );
        await intent.launch();
      } else {
        SystemNavigator.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const pages = [
      HomePage(),
      MessagePage(),
      SettingsPage(),
    ];

    const barDestinations = <NavigationDestination>[
      NavigationDestination(
        selectedIcon: Icon(Icons.home),
        icon: Icon(Icons.home_outlined),
        label: '首页',
      ),
      NavigationDestination(
        selectedIcon: Icon(Icons.message),
        icon: Icon(Icons.message_outlined),
        label: '消息',
      ),
      NavigationDestination(
        selectedIcon: Icon(Icons.settings),
        icon: Icon(Icons.settings_outlined),
        label: '设置',
      ),
    ];

    const railDestinations = <NavigationRailDestination>[
      NavigationRailDestination(
        selectedIcon: Icon(Icons.home),
        icon: Icon(Icons.home_outlined),
        label: Text('首页'),
      ),
      NavigationRailDestination(
        selectedIcon: Icon(Icons.message),
        icon: Icon(Icons.message_outlined),
        label: Text('消息'),
      ),
      NavigationRailDestination(
        selectedIcon: Icon(Icons.settings),
        icon: Icon(Icons.settings_outlined),
        label: Text('设置'),
      ),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, obj) async {
        onBackPressed();
      },
      child: LayoutBuilder(
        builder: (_, constriants) {
          bool isPortait = constriants.maxHeight > constriants.maxWidth;

          return Scaffold(
            body: Row(children: [
              if (!isPortait)
                NavigationRail(
                  destinations: railDestinations,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: onDestinationSelected,
                ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    if (index != _selectedIndex) {
                      setState(() => _selectedIndex = index);
                    }
                  },
                  children: pages,
                ),
              ),
            ]),
            bottomNavigationBar: isPortait
                ? SafeArea(
                    top: false,
                    minimum: const EdgeInsets.fromLTRB(32, 0, 32, 8),
                    child: Align(
                      heightFactor: 1,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 320),
                        child: Material(
                          elevation: 6,
                          surfaceTintColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(26),
                          clipBehavior: Clip.antiAlias,
                          child: NavigationBar(
                            height: 58,
                            destinations: barDestinations,
                            selectedIndex: _selectedIndex,
                            onDestinationSelected: onDestinationSelected,
                            labelBehavior:
                                NavigationDestinationLabelBehavior.alwaysShow,
                          ),
                        ),
                      ),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }

  void onDestinationSelected(int index) {
    if (index == 0 && _selectedIndex == 0) {
      _pageScrollController.setIndex(998);
      return;
    }
    if (index != _selectedIndex) {
      setState(() => _selectedIndex = index);
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    }
  }
}
