import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/HomeScreen.dart'; // Import your HomeScreen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Total duration
      vsync: this,
    );

    // Define fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    // Define scale animation to stop at screen's corners
    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.5).animate( // Set a reasonable scale factor here
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0, curve: Curves.easeIn)),
    );

    // Start the animations
    _controller.forward();

    // Navigate to HomeScreen after the animation ends
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow, // Background color
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value, // Apply scale animation
              child: Opacity(
                opacity: _fadeAnimation.value, // Apply fade animation
                child: Image.asset(
                  'lib/images/quadb.png', // Path to your image
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain, // Maintain aspect ratio
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
