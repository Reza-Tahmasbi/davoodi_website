import 'package:davoodi/pages/home_page.dart';
import 'package:davoodi/theme/text_theme.dart';
import 'package:davoodi/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => _PageWrapper(child: HomePage()),
    ),
  ],
);

class _PageWrapper extends StatelessWidget {
  final Widget child;

  const _PageWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return Scaffold(
      appBar: NavigationBarWidget(),
      endDrawer: isMobile ? NavigationDrawerWidget() : null,
      body: child,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: const Locale("fa"),
      supportedLocales: const [Locale("fa"), Locale("en")],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'تزریق پلاستیک داوودی',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2C5282),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        // Apply custom Persian font to all text
        fontFamily: AppTextTheme.defaultFont,
        textTheme: AppTextTheme.lightTextTheme,
        // Apply font to other text styles
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: AppTextTheme.defaultFont,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        buttonTheme: const ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      routerConfig: _router,
    );
  }
}
