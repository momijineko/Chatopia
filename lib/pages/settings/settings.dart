import 'package:chatopia/l10n/generated/l10n.dart';
import 'package:chatopia/router/router.dart';
import 'package:chatopia/store/settings/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = S.of(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final currentLocale = settingsProvider.settings.locale;

    // 语言显示名称映射
    String getLanguageName(Locale locale) {
      switch (locale.toLanguageTag()) {
        case 'en':
          return intl.en;
        case 'zh-CN':
          return intl.zh_CN;
        default:
          return intl.en;
      }
    }

    // 修改后的语言显示方法
    String getDisplayLanguage(BuildContext context, Locale? locale) {
      if (locale == null) {
        // 直接获取当前视图（不再需要空检查）
        final view = View.of(context);
        final systemLocale = view.platformDispatcher.locales.first;
        return getLanguageName(systemLocale);
      }
      return getLanguageName(locale);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(intl.settings),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          // 模型提供者分组
          _buildSettingsGroup(
            context,
            title: intl.modelSettings,
            children: [
              ListTile(
                title: Text(
                  intl.modelProvider,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                onTap: () =>
                    Navigator.pushNamed(context, AppRouter.providerPage),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // 语言和主题分组
          _buildSettingsGroup(
            context,
            title: intl.appearanceSettings,
            children: [
              ListTile(
                title: Text(
                  intl.language,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                trailing: DropdownButton<Locale?>(
                  value: currentLocale,
                  items: [
                    DropdownMenuItem(
                      value: const Locale('en'),
                      child: Text(
                        intl.en,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: const Locale('zh', 'CN'),
                      child: Text(
                        intl.zh_CN,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (Locale? newLocale) {
                    settingsProvider.changeLocale(newLocale);
                  },
                  underline: Container(),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
                ),
                subtitle: Text(
                  getDisplayLanguage(context, currentLocale),
                  style: TextStyle(
                    color:
                        Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  intl.theme,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                trailing: DropdownButton<ThemeMode>(
                  value: settingsProvider.settings.themeMode,
                  items: [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text(
                        intl.systemTheme,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text(
                        intl.lightTheme,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text(
                        intl.darkTheme,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (mode) {
                    if (mode != null) {
                      settingsProvider.toggleThemeMode(mode);
                    }
                  },
                  underline: Container(),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
                ),
                subtitle: Text(
                  _getThemeModeName(context, settingsProvider.settings.themeMode),
                  style: TextStyle(
                    color:
                        Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 构建设置分组
  Widget _buildSettingsGroup(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  // 获取主题模式显示名称
  String _getThemeModeName(BuildContext context, ThemeMode mode) {
    final intl = S.of(context);
    switch (mode) {
      case ThemeMode.system:
        return intl.systemTheme;
      case ThemeMode.light:
        return intl.lightTheme;
      case ThemeMode.dark:
        return intl.darkTheme;
    }
  }
}
