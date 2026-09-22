/// 主题明暗模式与种子色切换器组件
///
/// @author Ateng
/// @since 2026-09-22
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_provider.dart';

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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('明暗外观模式', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.system,
                  label: Text('跟随系统'),
                  icon: Icon(Icons.brightness_auto, size: 16),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.light,
                  label: Text('明亮模式'),
                  icon: Icon(Icons.light_mode, size: 16),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.dark,
                  label: Text('暗黑模式'),
                  icon: Icon(Icons.dark_mode, size: 16),
                ),
              ],
              selected: {themeState.mode},
              onSelectionChanged: (set) {
                if (set.isNotEmpty) {
                  themeNotifier.setThemeMode(set.first);
                }
              },
            ),
            const SizedBox(height: 20),
            Text('Material 3 种子强调色', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(
                AppTheme.seedColors.length,
                (index) {
                  final seed = AppTheme.seedColors[index];
                  final isSelected = themeState.seedColorIndex == index;
                  return ChoiceChip(
                    avatar: CircleAvatar(
                      backgroundColor: seed.color,
                      radius: 8,
                    ),
                    label: Text(seed.label),
                    selected: isSelected,
                    selectedColor: colorScheme.primaryContainer,
                    onSelected: (_) => themeNotifier.setSeedColorIndex(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
