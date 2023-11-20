import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saad_hesab/data/data.dart';
import 'package:saad_hesab/home/home_screen.dart';

const String tranactionBoxName = 'tranactionBoxName';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionDataAdapter());
  await Hive.openBox<TransactionData>(tranactionBoxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saad Hesab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'IranSans',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF004D40),
        ),
        primaryColor: const Color(0xFF004D40),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF004D40),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        duration: 3000,
        splash: Image.asset('assets/images/saadhesablogo.png'),
        nextScreen: const HomeScreen(),
        splashTransition: SplashTransition.fadeTransition,
        //   pageTransitionType: PageTransitionType.scale,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
