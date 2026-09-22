/// 编解码与哈希计算工具函数
///
/// @author Ateng
/// @since 2026-09-22
library;

import 'dart:convert';
import 'package:crypto/crypto.dart';

/// 加解密与哈希工具类
class CryptoUtils {
  const CryptoUtils._();

  /// 计算 UTF-8 字符串的 MD5 哈希
  static String md5Hash(String input) {
    if (input.isEmpty) return '';
    final bytes = utf8.encode(input);
    return md5.convert(bytes).toString();
  }

  /// 计算 UTF-8 字符串的 SHA-256 哈希
  static String sha256Hash(String input) {
    if (input.isEmpty) return '';
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }

  /// Base64 编码
  static String base64EncodeText(String input) {
    if (input.isEmpty) return '';
    final bytes = utf8.encode(input);
    return base64.encode(bytes);
  }

  /// Base64 解码，失败返回错误提示
  static String base64DecodeText(String input) {
    if (input.isEmpty) return '';
    try {
      final bytes = base64.decode(input.trim());
      return utf8.decode(bytes);
    } catch (e) {
      return '解码失败：输入非有效的 Base64 格式字符串';
    }
  }

  /// URL 编码
  static String urlEncodeText(String input) {
    if (input.isEmpty) return '';
    return Uri.encodeComponent(input);
  }

  /// URL 解码
  static String urlDecodeText(String input) {
    if (input.isEmpty) return '';
    try {
      return Uri.decodeComponent(input);
    } catch (e) {
      return '解码失败：输入非有效的 URL 编码字符串';
    }
  }
}
