// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'router/router.dart';
import 'l10n/generated/l10n.dart';
import 'store/settings/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider), // 使用预加载的实例
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, _) {
        final settings = settingsProvider.settings;
        // 添加系统语言处理逻辑

        return MaterialApp(
          title: 'AI App',
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: settingsProvider.settings.locale,
          theme: ThemeData(
            textTheme: GoogleFonts.notoSansTextTheme(), // 亮色主题字体
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            textTheme: GoogleFonts.notoSansTextTheme(), // 暗色主题字体
            brightness: Brightness.dark,
          ),
          themeMode: settings.themeMode, // 使用 ThemeMode 枚举
          initialRoute: AppRouter.chatPage,
          onGenerateRoute: AppRouter.generateRoute,
        );
      },
    );
  }
}
