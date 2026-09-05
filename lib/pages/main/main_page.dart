import 'dart:async';
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
  void dispose() {
    _pageController.dispose();
    unawaited(GStorage.close());
    Get.delete<ReturnTopController>(tag: 'home');
    Get.delete<MainController>();
    super.dispose();
  }

  Future<void> onBackPressed() async {
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

    const barDestinations = <_CompactDestination>[
      _CompactDestination(
        selectedIcon: Icons.home,
        icon: Icons.home_outlined,
        label: '首页',
      ),
      _CompactDestination(
        selectedIcon: Icons.message,
        icon: Icons.message_outlined,
        label: '消息',
      ),
      _CompactDestination(
        selectedIcon: Icons.settings,
        icon: Icons.settings_outlined,
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
                  physics: const NeverScrollableScrollPhysics(),
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
                    minimum: const EdgeInsets.fromLTRB(36, 0, 36, 8),
                    child: Align(
                      heightFactor: 1,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 312),
                        child: Material(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainer,
                          elevation: 4,
                          surfaceTintColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(28),
                          clipBehavior: Clip.antiAlias,
                          child: _CompactNavigationBar(
                            destinations: barDestinations,
                            selectedIndex: _selectedIndex,
                            onDestinationSelected: onDestinationSelected,
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }
}

class _CompactDestination {
  const _CompactDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

class _CompactNavigationBar extends StatelessWidget {
  const _CompactNavigationBar({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final List<_CompactDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 56,
      child: Row(
        children: List.generate(destinations.length, (index) {
          final destination = destinations[index];
          final selected = index == selectedIndex;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: selected
                      ? colorScheme.secondaryContainer
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Semantics(
                  button: true,
                  selected: selected,
                  label: destination.label,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () => onDestinationSelected(index),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          selected
                              ? destination.selectedIcon
                              : destination.icon,
                          size: 21,
                          color: selected
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          destination.label,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: selected
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
