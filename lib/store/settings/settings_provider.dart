// lib/store/settings_provider.dart
import 'dart:ui' as ui;

import 'package:chatopia/services/settings.dart';
import 'package:flutter/material.dart';
import 'settings_model.dart';

class SettingsProvider with ChangeNotifier {
  AppSettings _settings = AppSettings();
  final SettingsStorage _storage = SettingsStorage();

  AppSettings get settings => _settings;

  // 新增系统语言获取方法
  static Locale get systemLocale {
    final systemLocales = ui.PlatformDispatcher.instance.locales;
    return systemLocales.isNotEmpty ? systemLocales.first : const Locale('en');
  }

  // 添加缺失的加载方法
  Future<void> loadSettings() async {
    _settings = await _storage.loadSettings();
    notifyListeners();
  }

  // 更新设置的方法
  Future<void> updateSettings(AppSettings newSettings) async {
    _settings = newSettings;
    await _storage.saveSettings(_settings);
    notifyListeners();
  }

  // 修改语言切换方法
  Future<void> changeLocale(Locale? newLocale) async {
    final newSettings = _settings.copyWith(locale: newLocale);
    await updateSettings(newSettings);
    notifyListeners(); // 只需调用一次
  }

  // 主题模式切换快捷方法
  Future<void> toggleThemeMode(ThemeMode mode) async {
    final newSettings = _settings.copyWith(themeMode: mode);
    await updateSettings(newSettings);
  }
}
