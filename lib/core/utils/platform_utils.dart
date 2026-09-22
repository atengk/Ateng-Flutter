/// 跨平台运行时与环境侦测工具
///
/// @author Ateng
/// @since 2026-09-22
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 跨平台运行环境模型
class PlatformInfo {
  /// 操作系统与生态名称
  final String osName;

  /// 生态图标
  final IconData icon;

  /// 是否为桌面平台
  final bool isDesktop;

  /// 是否为 Web 环境
  final bool isWeb;

  /// 构造函数
  const PlatformInfo({
    required this.osName,
    required this.icon,
    required this.isDesktop,
    required this.isWeb,
  });
}

/// 平台环境辅助工具
class PlatformUtils {
  const PlatformUtils._();

  /// 获取当前运行环境信息
  static PlatformInfo get currentPlatform {
    if (kIsWeb) {
      return const PlatformInfo(
        osName: 'Web 浏览器环境',
        icon: Icons.language,
        isDesktop: false,
        isWeb: true,
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
        return const PlatformInfo(
          osName: 'Windows 桌面端',
          icon: Icons.computer,
          isDesktop: true,
          isWeb: false,
        );
      case TargetPlatform.macOS:
        return const PlatformInfo(
          osName: 'macOS 桌面端',
          icon: Icons.laptop_mac,
          isDesktop: true,
          isWeb: false,
        );
      case TargetPlatform.linux:
        return const PlatformInfo(
          osName: 'Linux 桌面端',
          icon: Icons.terminal,
          isDesktop: true,
          isWeb: false,
        );
      case TargetPlatform.android:
        return const PlatformInfo(
          osName: 'Android 移动端',
          icon: Icons.android,
          isDesktop: false,
          isWeb: false,
        );
      case TargetPlatform.iOS:
        return const PlatformInfo(
          osName: 'iOS 移动端',
          icon: Icons.phone_iphone,
          isDesktop: false,
          isWeb: false,
        );
      case TargetPlatform.fuchsia:
        return const PlatformInfo(
          osName: 'Fuchsia 系统',
          icon: Icons.device_unknown,
          isDesktop: false,
          isWeb: false,
        );
      default:
        return const PlatformInfo(
          osName: 'HarmonyOS NEXT 鸿蒙系统',
          icon: Icons.devices_other,
          isDesktop: false,
          isWeb: false,
        );
    }
  }
}
