import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_app/screens/home_screen.dart';
import 'package:school_app/screens/login_screen.dart';
import 'package:school_app/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final userDataString = prefs.getString('user');
  Map<String, dynamic>? userData;

  if (userDataString != null) {
    userData = jsonDecode(userDataString);
  }

  runApp(MyApp(userData: userData));
}

class MyApp extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const MyApp({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: userData != null ? HomeScreen(userData: userData!) : LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
