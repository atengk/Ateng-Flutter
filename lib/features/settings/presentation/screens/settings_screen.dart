/// 系统环境与主题设置主屏幕
///
/// @author Ateng
/// @since 2026-09-22
library;

import 'package:flutter/material.dart';

import '../../../../core/widgets/section_header.dart';
import '../widgets/platform_info_card.dart';
import '../widgets/theme_selector.dart';

/// 设置主屏幕
class SettingsScreen extends StatelessWidget {
  /// 构造函数
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: '外观与系统环境 (Settings & Environment)',
              subtitle: 'Material 3 动态调色盘与当前运行时设备参数感知',
              icon: Icons.palette_outlined,
            ),
            ThemeSelector(),
            SizedBox(height: 16),
            PlatformInfoCard(),
          ],
        ),
      ),
    );
  }
}
