import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/mbti_provider.dart';
import 'screens/home_screen.dart';
import 'screens/survey_screen.dart';
import 'screens/result_screen.dart';
import 'screens/matching_screen.dart';
import 'screens/character_program_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // SharedPreferences 초기화
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => MBTIProvider(prefs),
      child: CharacterMeetApp(),
    ),
  );
}

class CharacterMeetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CharacterMeet',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'NotoSansKR',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/survey',
      builder: (context, state) => SurveyScreen(),
    ),
    GoRoute(
      path: '/result',
      builder: (context, state) => ResultScreen(),
    ),
    GoRoute(
      path: '/character-program',
      builder: (context, state) => CharacterProgramScreen(),
    ),
    GoRoute(
      path: '/matching',
      builder: (context, state) => MatchingScreen(),
    ),
  ],
);
