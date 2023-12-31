import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saad_hesab/consts/color.dart';
import 'package:saad_hesab/data/data.dart';
import 'package:saad_hesab/home/home_screen.dart';

const String tranactionBoxName = 'transaction';
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
          backgroundColor: primaryColor,
        ),
        primaryColor: primaryColor,
        colorScheme: const ColorScheme.light(),
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
      backgroundColor: primaryColor,
      body: AnimatedSplashScreen(
        duration: 1500,
        splash: Image.asset('assets/images/saadhesablogo.png'),
        nextScreen: const HomeScreen(),
        splashTransition: SplashTransition.fadeTransition,
        //   pageTransitionType: PageTransitionType.scale,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
