/// 应用全局常量定义与初始种子数据
///
/// @author Ateng
/// @since 2026-09-22
library;

/// 应用全局常量集合类
class AppConstants {
  const AppConstants._();

  /// 应用显示名称
  static const String appTitle = 'DevToolbox Studio';

  /// 应用简短版本号
  static const String appVersion = 'v1.0.0';

  /// GitHub 源码仓库地址
  static const String repoUrl = 'https://github.com/atengk/Ateng-Flutter';

  /// 本地持久化历史记录键名
  static const String prefsHistoryKey = 'devtoolbox_history_records';

  /// 本地持久化主题模式键名
  static const String prefsThemeModeKey = 'devtoolbox_theme_mode';

  /// 本地持久化种子色索引键名
  static const String prefsSeedColorKey = 'devtoolbox_seed_color';

  /// 示例 JSON 数据
  static const String sampleJson = '''
{
  "name": "DevToolbox",
  "version": "1.0.0",
  "author": "Ateng",
  "features": [
    "JSON 格式化与压缩",
    "Unix 时间戳转换",
    "Base64 与哈希加密"
  ],
  "multiplatform": {
    "desktop": ["Windows", "macOS", "Linux"],
    "mobile": ["Android", "iOS"],
    "web": true
  }
}''';
}
