import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/joke_controller.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final JokeController jokeController = Get.put(JokeController());

  @override
  void initState() {
    super.initState();
    fetchDataAndNavigate();
  }

  Future<void> fetchDataAndNavigate() async {
    // Fetch initial data here
    try {
      await jokeController.loadJokes();
    } catch (e) {
      // Handle any errors that occur during data fetching
      print('Error fetching data: $e');
    }

    // Delay for 2 seconds and then navigate to the home screen
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'), // Use your background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/quote.png',
                width: 70,
                height: 51,
              ), // Use your logo image
              const SizedBox(height: 20),
              Image.asset(
                'assets/dadjokes.png',
                width: 209,
                height: 60,
              ), // Use your dadjokes.png image
            ],
          ),
        ),
      ),
    );
  }
}
