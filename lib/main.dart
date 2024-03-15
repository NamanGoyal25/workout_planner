import 'package:flutter/material.dart';
import 'package:workout_planner/auth/login_page.dart';
import 'package:workout_planner/auth/register_page.dart';
import 'package:workout_planner/auth/splash_file.dart';
import 'package:workout_planner/home/analysis_page.dart';
import 'package:workout_planner/home/create_plan.dart';
import 'package:workout_planner/home/days_page.dart';
import 'package:workout_planner/home/execute_plan.dart';
import 'package:workout_planner/home/history.dart';
import 'package:workout_planner/home/navPage.dart';
import 'package:workout_planner/home/profile.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workout_planner/home/home_page.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Planner',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark().copyWith(
          background: Colors.black,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => HomePage(),
        '/create': (context) => CreatePlanPage(),
        '/execute': (context) => ExecutePlanPage(),
        '/analysis': (context) => AnalysisPage(),
        '/days': (context) => const DaysPage(),
        '/nav': (context) => const NavPage(),
        '/history': (context) => const History(),
        '/profile': (context) => const Profile(),


      },
    );
  }
}