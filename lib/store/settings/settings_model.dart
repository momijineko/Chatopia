// lib/store/settings_model.dart
import 'package:flutter/material.dart';

class AppSettings {
  final Locale? locale;
  final ThemeMode themeMode;
  // 添加其他设置字段

  const AppSettings({
    this.locale = const Locale('en'), // 默认值
    this.themeMode = ThemeMode.system,
  });

  // 默认值工厂构造
  factory AppSettings.fallback() {
    return const AppSettings(
      locale: null,
      themeMode: ThemeMode.system,
    );
  }

  // 复制更新方法
  AppSettings copyWith({
    Locale? locale,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  // 添加fromJson/toJson方法（根据存储需要）
}
