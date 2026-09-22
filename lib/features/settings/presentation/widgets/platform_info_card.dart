/// 跨平台运行生态与环境参数展示卡片，采用 StudioCard 设计
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/platform_utils.dart';
import '../../../../core/widgets/studio_card.dart';

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

    return StudioCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    Icon(platform.icon, size: 22, color: colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    platform.osName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '应用版本: ${AppConstants.appVersion}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 20),
          _InfoRow(
            label: '窗口分辨率',
            value:
                '${mediaQuery.size.width.toInt()} x ${mediaQuery.size.height.toInt()} dp',
          ),
          const SizedBox(height: 8),
          _InfoRow(
            label: '设备像素比 (DPR)',
            value: mediaQuery.devicePixelRatio.toStringAsFixed(2),
          ),
          const SizedBox(height: 8),
          _InfoRow(
            label: '运行形态',
            value: platform.isWeb
                ? 'Web 浏览器沙箱'
                : (platform.isDesktop ? '桌面级窗口' : '移动端设备'),
          ),
          const SizedBox(height: 8),
          const _InfoRow(
            label: '开源源码仓库',
            value: AppConstants.repoUrl,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 12,
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
