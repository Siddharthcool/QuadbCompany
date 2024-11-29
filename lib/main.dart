import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/SplashScreen.dart';
import 'package:fluttertest/Screens/HomeScreen.dart'; // Make sure you import HomeScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies App',
      theme: ThemeData.dark(),
      home: SplashScreen(), // Start with SplashScreen
      routes: {
        '/home': (context) => HomeScreen(), // Define HomeScreen route
      },
    );
  }
}
