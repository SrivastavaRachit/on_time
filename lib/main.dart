import 'package:flutter/material.dart';
import 'package:on_time/splash_screen.dart';

void main() {
  runApp(const OnTime());
}

class OnTime extends StatelessWidget {
  const OnTime({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

