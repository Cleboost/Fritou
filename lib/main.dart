import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fritou/screens/main_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fritou',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF9800),
          brightness: Brightness.dark,
          primary: const Color(0xFFFFB74D), // Golden fry yellow
          secondary: const Color(0xFFFF7043), // Warm orange
          tertiary: const Color(0xFF8D6E63), // Brownish crisp
          background: const Color(0xFF0F0E0F), // Very dark charcoal
          surface: const Color(0xFF1E1C1F), // Dark card surface
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0E0F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F0E0F),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFB74D),
            letterSpacing: 1.2,
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1C1F),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}
