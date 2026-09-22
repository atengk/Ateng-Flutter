/// 响应式多端外壳组件，三级自适应桌面一体化侧栏、平板紧凑轨与移动沉浸底栏
///
/// @author Ateng
/// @since 2026-09-23
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
    final screens = [
      const ToolboxScreen(),
      HistoryScreen(
        onNavigateToToolbox: () => _onTabSelected(0),
      ),
      const SettingsScreen(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // >= 720px 即视为桌面宽屏，直接呈现一体化沉浸式侧边栏
        final isDesktop = constraints.maxWidth >= 720;
        final isTablet = constraints.maxWidth >= 520 && !isDesktop;

        if (isDesktop) {
          return Scaffold(
            body: Row(
              children: [
                _DesktopSidebar(
                  selectedIndex: _currentIndex,
                  onSelected: _onTabSelected,
                ),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(child: screens[_currentIndex]),
              ],
            ),
          );
        }

        if (isTablet) {
          return _TabletScaffold(
            selectedIndex: _currentIndex,
            onSelected: _onTabSelected,
            child: screens[_currentIndex],
          );
        }

        // 移动端 (< 520px)
        return _MobileScaffold(
          selectedIndex: _currentIndex,
          onSelected: _onTabSelected,
          child: screens[_currentIndex],
        );
      },
    );
  }
}

/// 桌面端一体化极客侧边栏
class _DesktopSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _DesktopSidebar({
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final sidebarBg =
        isDark ? const Color(0xFF090B0E) : colorScheme.surfaceContainerLow;

    return Container(
      width: 220,
      color: sidebarBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 18, 14, 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(35),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colorScheme.primary.withAlpha(90),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.terminal,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppConstants.appTitle,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'DEVELOPER STUDIO',
                        style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: colorScheme.outlineVariant,
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    AppConstants.appVersion,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Text(
              'WORKSPACES',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurfaceVariant.withAlpha(160),
              ),
            ),
          ),
          const SizedBox(height: 4),
          _SidebarItem(
            icon: Icons.handyman_outlined,
            selectedIcon: Icons.handyman,
            label: '微工具工坊',
            isSelected: selectedIndex == 0,
            onTap: () => onSelected(0),
          ),
          _SidebarItem(
            icon: Icons.history_toggle_off,
            selectedIcon: Icons.history,
            label: '操作看板',
            isSelected: selectedIndex == 1,
            onTap: () => onSelected(1),
          ),
          _SidebarItem(
            icon: Icons.tune_outlined,
            selectedIcon: Icons.tune,
            label: '系统与设置',
            isSelected: selectedIndex == 2,
            onTap: () => onSelected(2),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.outlineVariant,
                  width: 0.8,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Local Engine Active',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withAlpha(22)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary.withAlpha(70)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                size: 16,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color:
                      isSelected ? colorScheme.primary : colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 平板中屏外壳
class _TabletScaffold extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Widget child;

  const _TabletScaffold({
    required this.selectedIndex,
    required this.onSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainerLow,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.terminal, color: colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(AppConstants.appTitle, style: theme.textTheme.titleMedium),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                    width: 0.8,
                  ),
                ),
                child: Text(
                  AppConstants.appVersion,
                  style: theme.textTheme.labelSmall?.copyWith(fontSize: 10),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: colorScheme.surfaceContainerLow,
            selectedIndex: selectedIndex,
            onDestinationSelected: onSelected,
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.handyman_outlined),
                selectedIcon: Icon(Icons.handyman),
                label: Text('微工具工坊'),
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
            ],
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// 移动端小屏外壳
class _MobileScaffold extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Widget child;

  const _MobileScaffold({
    required this.selectedIndex,
    required this.onSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainerLow,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.terminal, color: colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(AppConstants.appTitle, style: theme.textTheme.titleMedium),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                    width: 0.8,
                  ),
                ),
                child: Text(
                  AppConstants.appVersion,
                  style: theme.textTheme.labelSmall?.copyWith(fontSize: 10),
                ),
              ),
            ),
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.handyman_outlined),
            selectedIcon: Icon(Icons.handyman),
            label: '微工具工坊',
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
        ],
      ),
    );
  }
}
