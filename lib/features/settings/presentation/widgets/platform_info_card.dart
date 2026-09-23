/// 跨平台运行生态与环境参数展示卡片，采用极客工作室高奢陶瓷卡片设计
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/platform_utils.dart';
import '../../../../core/widgets/studio_card.dart';

/// 跨平台环境与硬件参数展示卡片
class PlatformInfoCard extends StatelessWidget {
  /// 构造函数
  const PlatformInfoCard({super.key});

  void _copyRepo(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: AppConstants.repoUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已复制开源仓库地址'),
        duration: Duration(seconds: 1),
      ),
    );
  }

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
                  color: AppColors.electricAzure.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.electricAzure.withAlpha(60),
                    width: 0.8,
                  ),
                ),
                child: const Icon(
                  Icons.devices_outlined,
                  size: 20,
                  color: AppColors.electricAzure,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${platform.osName} 运行时生态',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '版本规范：v${AppConstants.appVersion} • 响应式自适应布局',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.outline,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),
          _ParamRow(
            label: '当前主视窗分辨率',
            value:
                '${mediaQuery.size.width.toInt()} x ${mediaQuery.size.height.toInt()} dp',
          ),
          const SizedBox(height: 10),
          _ParamRow(
            label: '设备物理像素比 (DPR)',
            value: mediaQuery.devicePixelRatio.toStringAsFixed(2),
          ),
          const SizedBox(height: 10),
          _ParamRow(
            label: '客户端分发形态',
            value: platform.isWeb
                ? 'Web 浏览器沙箱 (PWA 就绪)'
                : (platform.isDesktop ? '桌面极简独立视窗' : '移动端全屏触控'),
          ),
          const SizedBox(height: 10),
          _ParamRow(
            label: '减弱动态效果 (Reduce Motion)',
            value: mediaQuery.disableAnimations
                ? '已启用 (无障碍降级)'
                : '未启用 (流畅 60fps 微动效)',
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '开源代码仓库',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              InkWell(
                onTap: () => _copyRepo(context),
                borderRadius: BorderRadius.circular(4),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppConstants.repoUrl,
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontFamilyFallback: [
                            'Consolas',
                            'Menlo',
                            'monospace',
                          ],
                          fontSize: 11.5,
                          color: AppColors.electricAzure,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.copy,
                        size: 12,
                        color: AppColors.electricAzure,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ParamRow extends StatelessWidget {
  final String label;
  final String value;

  const _ParamRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontFamilyFallback: const ['Consolas', 'Menlo', 'monospace'],
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
