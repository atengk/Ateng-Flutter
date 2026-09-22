/// 响应式多端外壳组件，自适应桌面侧栏与移动底栏
///
/// @author Ateng
/// @since 2026-09-22
library;

import 'package:flutter/material.dart';

import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/toolbox/presentation/screens/toolbox_screen.dart';
import '../constants/app_constants.dart';

/// 响应式主导航外壳
class AppScaffold extends StatefulWidget {
  /// 构造函数
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    const destinations = [
      NavigationDestination(
        icon: Icon(Icons.handyman_outlined),
        selectedIcon: Icon(Icons.handyman),
        label: '工具工坊',
      ),
      NavigationDestination(
        icon: Icon(Icons.history_toggle_off),
        selectedIcon: Icon(Icons.history),
        label: '操作看板',
      ),
      NavigationDestination(
        icon: Icon(Icons.tune_outlined),
        selectedIcon: Icon(Icons.tune),
        label: '系统与设置',
      ),
    ];

    const railDestinations = [
      NavigationRailDestination(
        icon: Icon(Icons.handyman_outlined),
        selectedIcon: Icon(Icons.handyman),
        label: Text('工具工坊'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.history_toggle_off),
        selectedIcon: Icon(Icons.history),
        label: Text('操作看板'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.tune_outlined),
        selectedIcon: Icon(Icons.tune),
        label: Text('系统与设置'),
      ),
    ];

    final screens = [
      const ToolboxScreen(),
      HistoryScreen(
        onNavigateToToolbox: () => _onTabSelected(0),
      ),
      const SettingsScreen(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 720;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: colorScheme.surfaceContainer,
            title: Row(
              children: [
                Icon(Icons.terminal, color: colorScheme.primary),
                const SizedBox(width: 8),
                const Text(AppConstants.appTitle),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      AppConstants.appVersion,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Row(
            children: [
              if (isDesktop)
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: _onTabSelected,
                  labelType: NavigationRailLabelType.all,
                  destinations: railDestinations,
                ),
              if (isDesktop) const VerticalDivider(thickness: 1, width: 1),
              Expanded(
                child: screens[_currentIndex],
              ),
            ],
          ),
          bottomNavigationBar: isDesktop
              ? null
              : NavigationBar(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: _onTabSelected,
                  destinations: destinations,
                ),
        );
      },
    );
  }
}
