import 'package:flutter/material.dart';
// import 'package:flutter/src/material/divider.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  navigateToLogin(BuildContext context) async{
    Future.delayed(Duration(seconds: 3),(){
      Navigator.pushReplacementNamed(context, "/login");
    });
  }

  @override
  Widget build(BuildContext context) {

    navigateToLogin(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/logo3.png", width: 300, height: 300,),
            const SizedBox(height: 12),
            const Text("Workout Planner", style: TextStyle(color: Colors.white, fontSize: 34,),),
            const Divider(),
            const SizedBox(height: 6,),
            const Text("Set Your Workout Plan ", style: TextStyle(color: Colors.blueGrey, fontSize: 20),)
          ],
        ),
      ),
    );
  }
}
