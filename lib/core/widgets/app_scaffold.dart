/// 响应式多端外壳组件，三级自适应桌面一体化极简浮岛侧栏、点阵微纹理画布、平板紧凑轨与移动沉浸底栏
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'package:flutter/material.dart';

import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/toolbox/presentation/screens/toolbox_screen.dart';
import '../constants/app_constants.dart';
import 'dot_grid_background.dart';

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
        // >= 900px 视为桌面宽屏，呈现极简浮岛侧栏与 1440px 居中工作台
        final isDesktop = constraints.maxWidth >= 900;
        final isTablet = constraints.maxWidth >= 600 && !isDesktop;

        if (isDesktop) {
          return Scaffold(
            body: Row(
              children: [
                _DesktopSidebar(
                  selectedIndex: _currentIndex,
                  onSelected: _onTabSelected,
                ),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(
                  child: DotGridBackground(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1440),
                        child: LayoutBuilder(
                          builder: (context, screenConstraints) {
                            if (screenConstraints.maxHeight < 560) {
                              return SingleChildScrollView(
                                child: SizedBox(
                                  height: 560,
                                  child: screens[_currentIndex],
                                ),
                              );
                            }
                            return screens[_currentIndex];
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (isTablet) {
          return DotGridBackground(
            child: _TabletScaffold(
              selectedIndex: _currentIndex,
              onSelected: _onTabSelected,
              child: screens[_currentIndex],
            ),
          );
        }

        // 移动端 (< 600px)
        return DotGridBackground(
          child: _MobileScaffold(
            selectedIndex: _currentIndex,
            onSelected: _onTabSelected,
            child: screens[_currentIndex],
          ),
        );
      },
    );
  }
}

/// 桌面端极简浮岛侧栏 (Linear Island Sidebar)
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
        isDark ? const Color(0xFF111827) : colorScheme.surfaceContainerLow;

    return Container(
      width: 224,
      color: sidebarBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 18, 14, 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.bolt,
                    size: 17,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppConstants.appTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5,
                      letterSpacing: 0,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: colorScheme.outlineVariant,
                      width: 0.8,
                    ),
                  ),
                  child: const Text(
                    AppConstants.appVersion,
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontFamilyFallback: [
                        'Consolas',
                        'Menlo',
                        'monospace',
                      ],
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: Text(
                      'NAVIGATION',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurfaceVariant.withAlpha(160),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _SidebarItem(
                    icon: Icons.code,
                    selectedIcon: Icons.code,
                    label: '微工具工坊',
                    isSelected: selectedIndex == 0,
                    onTap: () => onSelected(0),
                  ),
                  _SidebarItem(
                    icon: Icons.analytics_outlined,
                    selectedIcon: Icons.analytics,
                    label: '操作看板',
                    badge: '128',
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
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.surface,
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
                      '本地引擎已就绪',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurfaceVariant,
                        letterSpacing: 0,
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

/// 浮岛菜单项组件 (带 Hover 微光、计数徽标与激活实体圆点)
class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String? badge;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.badge,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bgColor = widget.isSelected
        ? colorScheme.primary.withAlpha(25)
        : (_isHovered
            ? colorScheme.surfaceContainerHigh.withAlpha(120)
            : Colors.transparent);

    final borderColor = widget.isSelected
        ? colorScheme.primary.withAlpha(60)
        : Colors.transparent;

    final contentColor = widget.isSelected
        ? colorScheme.primary
        : (_isHovered ? colorScheme.onSurface : colorScheme.onSurfaceVariant);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Row(
              children: [
                Icon(
                  widget.isSelected ? widget.selectedIcon : widget.icon,
                  size: 17,
                  color: contentColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight:
                          widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 13.5,
                      color: contentColor,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                if (widget.badge != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1.5,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isSelected
                          ? colorScheme.primary.withAlpha(25)
                          : colorScheme.surfaceContainerHighest.withAlpha(120),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.badge!,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontFamily: 'JetBrains Mono',
                        fontFamilyFallback: const [
                          'Consolas',
                          'Menlo',
                          'monospace',
                        ],
                        fontWeight: FontWeight.w600,
                        color: widget.isSelected
                            ? colorScheme.primary
                            : colorScheme.outline,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                if (widget.isSelected)
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 平板中屏外壳 (64dp 紧凑图标浮岛轨)
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
    final isDark = theme.brightness == Brightness.dark;

    final railBg =
        isDark ? const Color(0xFF111827) : colorScheme.surfaceContainerLow;

    final destinations = [
      (Icons.code, '微工具工坊'),
      (Icons.analytics_outlined, '操作看板'),
      (Icons.tune_outlined, '系统与设置'),
    ];

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 64,
            color: railBg,
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.bolt,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 8),
                for (int i = 0; i < destinations.length; i++)
                  _CompactRailButton(
                    icon: destinations[i].$1,
                    tooltip: destinations[i].$2,
                    isSelected: selectedIndex == i,
                    onTap: () => onSelected(i),
                  ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _CompactRailButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isSelected;
  final VoidCallback onTap;

  const _CompactRailButton({
    required this.icon,
    required this.tooltip,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary.withAlpha(25)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary.withAlpha(60)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

/// 移动端沉浸小屏外壳 (< 600px，隐藏侧栏转为底部沉浸浮动 Dock)
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
    final isDark = theme.brightness == Brightness.dark;

    final dockBg = isDark
        ? const Color(0xFF1E293B).withAlpha(240)
        : const Color(0xFFFFFFFF).withAlpha(240);

    final items = [
      (Icons.code, '微工具工坊'),
      (Icons.analytics_outlined, '操作看板'),
      (Icons.tune_outlined, '设置'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.bolt, size: 18, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              AppConstants.appTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: dockBg,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: colorScheme.outlineVariant,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? const Color(0x66000000)
                      : const Color(0x140F172A),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < items.length; i++)
                  _MobileDockButton(
                    icon: items[i].$1,
                    label: items[i].$2,
                    isSelected: selectedIndex == i,
                    onTap: () => onSelected(i),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileDockButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MobileDockButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withAlpha(25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? colorScheme.primary : colorScheme.outline,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
