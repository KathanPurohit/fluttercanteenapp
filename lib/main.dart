import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canteen Management',
      theme: _buildTheme(context),
      home: const HomePage(),
    );
  }

  ThemeData _buildTheme(BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: Theme.of(context).textTheme.apply(
        fontFamily: 'Roboto',
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ).copyWith(
        bodyLarge: const TextStyle(fontWeight: FontWeight.bold),
        bodyMedium: const TextStyle(fontWeight: FontWeight.bold),
        labelLarge: const TextStyle(fontWeight: FontWeight.bold),
        titleLarge: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackgroundImage(),
          _buildDarkOverlay(),
          AuthPage(),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Image.asset(
      'assets/background.jpg',
      fit: BoxFit.cover,
    );
  }

  Widget _buildDarkOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
    );
  }
}