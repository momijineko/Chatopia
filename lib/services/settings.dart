// lib/services/settings_service.dart
import 'package:chatopia/store/settings/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsStorage {
  static const _keyLocale = 'locale';
  static const _keyThemeMode = 'themeMode';

  // 添加缺失的 _parseLocale 方法
  Locale? _parseLocale(String? code) {
    if (code == null || code.isEmpty) return null;
    final parts = code.split('_');
    if (parts.length == 1) return Locale(parts[0]);
    if (parts.length == 2) return Locale(parts[0], parts[1]);
    return null;
  }

  Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return AppSettings(
      locale: _parseLocale(prefs.getString(_keyLocale)), // 这里需要 _parseLocale
      themeMode: _parseThemeMode(prefs.getInt(_keyThemeMode)),
    );
  }

  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (settings.locale != null) {
      await prefs.setString(_keyLocale, _localeToString(settings.locale!));
    } else {
      await prefs.remove(_keyLocale);
    }
    
    await prefs.setInt(_keyThemeMode, settings.themeMode.index);
  }

  // 新增的 locale 序列化方法
  String _localeToString(Locale locale) {
    return locale.countryCode?.isNotEmpty == true 
        ? "${locale.languageCode}_${locale.countryCode}"
        : locale.languageCode;
  }

  ThemeMode _parseThemeMode(int? index) {
    return index != null && index < ThemeMode.values.length 
        ? ThemeMode.values[index]
        : ThemeMode.system;
  }
}
