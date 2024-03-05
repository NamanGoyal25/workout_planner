import 'package:flutter/material.dart';
import 'package:workout_planner/auth/login_page.dart';
import 'package:workout_planner/auth/register_page.dart';
import 'package:workout_planner/auth/splash_file.dart';
import 'package:workout_planner/home/analysis_page.dart';
import 'package:workout_planner/home/create_plan.dart';
import 'package:workout_planner/home/days_page.dart';
import 'package:workout_planner/home/execute_plan.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workout_planner/home/home_page.dart';
import 'home/home_page.dart';



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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
     debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/splash': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const  HomePage(),
        '/create': (context) => CreatePlanPage(),
        '/execute': (context) => ExecutePlanPage(),
        '/analysis': (context) => AnalysisPage(),
        '/homeContent': (context) => HomePageContent(),
        '/days': (context) => const DaysPage(),


      },
    );
  }
}
