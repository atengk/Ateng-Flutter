/// 主题明暗模式三选一卡片与种子色切换器组件，采用高奢极客设计
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/studio_card.dart';

/// 主题选择器组件
class ThemeSelector extends ConsumerWidget {
  /// 构造函数
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return StudioCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '外观色彩模式 (Color Appearance)',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '当前：${_modeLabel(themeState.mode)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.outline,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 540;
              final cards = [
                _ThemeModeCard(
                  title: '明亮极客 (Light)',
                  subtitle: '纯白高光基底，专为高专注白天编程打造',
                  icon: Icons.light_mode_outlined,
                  isSelected: themeState.mode == ThemeMode.light,
                  badge: '推荐',
                  onTap: () => themeNotifier.setThemeMode(ThemeMode.light),
                ),
                _ThemeModeCard(
                  title: '深邃暗黑 (Dark)',
                  subtitle: '极光暗夜灰阶，呵护夜间调试视觉体验',
                  icon: Icons.dark_mode_outlined,
                  isSelected: themeState.mode == ThemeMode.dark,
                  onTap: () => themeNotifier.setThemeMode(ThemeMode.dark),
                ),
                _ThemeModeCard(
                  title: '跟随系统 (System)',
                  subtitle: '自动感知 OS 外观，平滑无感过渡',
                  icon: Icons.brightness_auto_outlined,
                  isSelected: themeState.mode == ThemeMode.system,
                  onTap: () => themeNotifier.setThemeMode(ThemeMode.system),
                ),
              ];

              if (isWide) {
                return Row(
                  children: cards
                      .map(
                        (c) => Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: c,
                          ),
                        ),
                      )
                      .toList(),
                );
              }

              return Column(
                children: cards
                    .map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: c,
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Text(
            '极客工作台强调色 (Accent Palette)',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(
              AppTheme.seedColors.length,
              (index) {
                final seed = AppTheme.seedColors[index];
                final isSelected = themeState.seedColorIndex == index;
                return _SeedColorChip(
                  label: seed.label,
                  color: seed.color,
                  isSelected: isSelected,
                  onTap: () => themeNotifier.setSeedColorIndex(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static String _modeLabel(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => '明亮极客',
      ThemeMode.dark => '深邃暗黑',
      ThemeMode.system => '跟随系统',
    };
  }
}

class _ThemeModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final String? badge;
  final VoidCallback onTap;

  const _ThemeModeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final selectedBg =
        isDark ? const Color(0xFF16243A) : const Color(0xFFF0F9FF);
    final unselectedBg =
        isDark ? const Color(0xFF141923) : const Color(0xFFFFFFFF);

    final borderColor =
        isSelected ? AppColors.electricAzure : colorScheme.outlineVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isSelected ? selectedBg : unselectedBg,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.electricAzure.withAlpha(25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: isSelected
                        ? AppColors.electricAzure
                        : colorScheme.onSurfaceVariant,
                  ),
                  if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.electricAzure.withAlpha(25),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.electricAzure,
                        ),
                      ),
                    )
                  else if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppColors.electricAzure,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                  color: isSelected
                      ? (isDark ? Colors.white : const Color(0xFF0F172A))
                      : colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.outline,
                  fontSize: 10.5,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SeedColorChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _SeedColorChip({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withAlpha(25)
                : colorScheme.surfaceContainerHigh.withAlpha(80),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? color : colorScheme.outlineVariant,
              width: isSelected ? 1.4 : 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? color : colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
