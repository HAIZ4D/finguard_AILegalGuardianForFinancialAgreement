import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';
import 'providers/analysis_provider.dart';
import 'screens/home_screen.dart';
import 'screens/upload_screen.dart';
import 'screens/result_screen.dart';
import 'screens/history_screen.dart';
import 'screens/comparison_screen.dart';

final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => AnalysisProvider(),
      child: const FinGuardApp(),
    ),
  );
}

class FinGuardApp extends StatelessWidget {
  const FinGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinGuard',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A12),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8B5CF6),
          secondary: Color(0xFFA78BFA),
          surface: Color(0xFF12121E),
          onSurface: Color(0xFFE2E8F0),
          outline: Color(0xFF2A2A3E),
          primaryContainer: Color(0xFF1E1E2E),
          secondaryContainer: Color(0xFF161625),
          error: Color(0xFFEF4444),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 0,
          color: const Color(0xFF12121E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF2A2A3E)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0A12),
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF12121E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2A2A3E)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2A2A3E)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 2),
          ),
        ),
        chipTheme: const ChipThemeData(
          backgroundColor: Color(0xFF1E1E2E),
          side: BorderSide(color: Color(0xFF2A2A3E)),
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Color(0xFF12121E),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/upload': (context) => const UploadScreen(),
        '/result': (context) => const ResultScreen(),
        '/history': (context) => const HistoryScreen(),
        '/analysis/compare': (context) => const ComparisonScreen(),
      },
    );
  }
}
