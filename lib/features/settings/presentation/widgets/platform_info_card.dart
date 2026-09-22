/// 跨平台运行生态与环境参数展示卡片
///
/// @author Ateng
/// @since 2026-09-22
library;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/platform_utils.dart';

/// 跨平台环境与硬件参数展示卡片
class PlatformInfoCard extends StatelessWidget {
  /// 构造函数
  const PlatformInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final platform = PlatformUtils.currentPlatform;
    final mediaQuery = MediaQuery.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(platform.icon, size: 28, color: colorScheme.primary),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      platform.osName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '应用版本: ${AppConstants.appVersion}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow(
              context,
              '窗口分辨率',
              '${mediaQuery.size.width.toInt()} x ${mediaQuery.size.height.toInt()} dp',
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              '设备像素比 (DPR)',
              mediaQuery.devicePixelRatio.toStringAsFixed(2),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              '运行形态',
              platform.isWeb
                  ? 'Web 浏览器沙箱'
                  : (platform.isDesktop ? '桌面级窗口' : '移动端设备'),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              '开源源码仓库',
              AppConstants.repoUrl,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
