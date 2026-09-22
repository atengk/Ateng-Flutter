/// 主题明暗模式与种子色切换器组件，采用 StudioCard 设计
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          Text('外观色彩模式', style: theme.textTheme.titleSmall),
          const SizedBox(height: 10),
          SegmentedButton<ThemeMode>(
            style: SegmentedButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
            segments: const [
              ButtonSegment<ThemeMode>(
                value: ThemeMode.system,
                label: Text('跟随系统'),
                icon: Icon(Icons.brightness_auto, size: 15),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.light,
                label: Text('明亮模式'),
                icon: Icon(Icons.light_mode, size: 15),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.dark,
                label: Text('暗黑模式'),
                icon: Icon(Icons.dark_mode, size: 15),
              ),
            ],
            selected: {themeState.mode},
            onSelectionChanged: (set) {
              if (set.isNotEmpty) {
                themeNotifier.setThemeMode(set.first);
              }
            },
          ),
          const SizedBox(height: 18),
          Text('极客工作台强调色', style: theme.textTheme.titleSmall),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(
              AppTheme.seedColors.length,
              (index) {
                final seed = AppTheme.seedColors[index];
                final isSelected = themeState.seedColorIndex == index;
                return ChoiceChip(
                  avatar: CircleAvatar(
                    backgroundColor: seed.color,
                    radius: 7,
                  ),
                  label: Text(seed.label, style: const TextStyle(fontSize: 12)),
                  selected: isSelected,
                  selectedColor: colorScheme.primaryContainer,
                  onSelected: (_) => themeNotifier.setSeedColorIndex(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
