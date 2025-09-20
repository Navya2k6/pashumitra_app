// FILE: lib/main.dart

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pashumitra_app/generated/app_localizations.dart'; // Ensure package name is correct

import 'language_selection_screen.dart';
import 'onboarding_screen.dart';
import 'menu_page.dart';
import 'locale_provider.dart';

void main() async {
  // This part is simpler now, we just need to determine the initial locale
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final String? languageCode = prefs.getString('languageCode');

  runApp(MyApp(
    initialLocale: languageCode != null ? Locale(languageCode) : const Locale('en'),
  ));
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;

  const MyApp({
    super.key,
    required this.initialLocale,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocaleProvider(initialLocale),
      child: Consumer<LocaleProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Pashumitra',
            locale: provider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            // The app's home is NOW ALWAYS the SplashScreen
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

// Your SplashScreen now contains all the navigation logic
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward(); // start fade-in

    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    // Wait for the splash screen animation
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // The logic to decide the next screen is now HERE
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString('languageCode');
    final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    Widget destinationPage;

    if (languageCode == null) {
      destinationPage = const LanguageSelectionScreen();
    } else if (!hasSeenOnboarding) {
      destinationPage = const OnboardingScreen();
    } else {
      destinationPage = const MainScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destinationPage),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF87CEEB), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: Image.asset(
                'assets/images/pashimitra_logo.png',
                width: 220,
              ),
            ),
          ),
        ),
      ),
    );
  }
}