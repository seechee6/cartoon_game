import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MinionsApp());
}

class MinionsApp extends StatelessWidget {
  const MinionsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minions Fun Facts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFE205)),
        fontFamily: 'Poppins',
      ),
      home: const SplashScreen(),
    );
  }
}
