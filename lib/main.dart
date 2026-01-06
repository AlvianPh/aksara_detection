import 'package:flutter/material.dart';
import 'utils/theme.dart';

import 'views/splash/splash_page.dart';
import 'views/auth/login_page.dart';
import 'views/auth/register_page.dart';
import 'views/home/home_page.dart';
import 'views/home/home_empty.dart';
import 'views/home/home_with_history.dart';
import 'views/home/history_detail_page.dart';
import 'views/scan/scan_menu.dart';
import 'views/scan/scan_result.dart';
import 'views/settings/settings_page.dart';

// GLOBAL NAVIGATION KEY
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Jawir',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Start dari Splash
      initialRoute: '/',

      // ROUTES TANPA ARGUMENTS
      routes: {
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),

        // halaman utama bottomNav
        '/home': (_) => const HomePage(),

        // hanya sebagai view langsung tanpa bottomNav (opsional)
        '/home_empty': (_) => HomeEmpty(),
        '/home_history': (_) => const HomeWithHistory(),

        '/scan_menu': (_) => ScanMenuPage(),
        '/settings': (_) => SettingsPage(),
      },

      // ROUTES DENGAN ARGUMENTS
      onGenerateRoute: (settings) => _generateRoute(settings),
    );
  }
}

Route _generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/history_detail':
      final args = settings.arguments;
      final int id = args is int ? args : int.parse(args.toString());
      return MaterialPageRoute(
        builder: (_) => HistoryDetailPage(id: id),
      );

    case '/scan_result':
      return MaterialPageRoute(
        builder: (_) => ScanResultPage(),
        settings: settings,
      );
  }

  // fallback
  return MaterialPageRoute(builder: (_) => const SplashPage());
}
