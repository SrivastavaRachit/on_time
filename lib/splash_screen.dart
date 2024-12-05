import 'package:flutter/material.dart';
import 'package:on_time/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2C0077), Color(0xFF8A2BE2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              top: -250,
              left: 60,
              right: 60,
              child: Image.asset(
                'assets/todo_logo.png',
                fit: BoxFit.contain,
              ),
            ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildTextContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 120),
      child: Column(
        children: [
          _buildText(
            'Stay Organized. Achieve More',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          _buildText(
            'Plan Your Day, Your Way',
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildText(
    String text, {
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    TextAlign textAlign = TextAlign.start,
  }) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
