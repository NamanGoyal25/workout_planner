// import 'package:flutter/material.dart';
// // import 'package:flutter/src/material/divider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
//
// class SplashPage extends StatelessWidget {
//   const SplashPage({super.key});
//
//   navigateToLogin(BuildContext context) async{
//     Future.delayed(Duration(seconds: 3),(){
//       Navigator.pushReplacementNamed(context, "/login");
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     navigateToLogin(context);
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image.asset("assets/logo3.png", width: 300, height: 300,),
//             const SizedBox(height: 12),
//             const Text("Workout Planner", style: TextStyle(color: Colors.white, fontSize: 34,),),
//             const Divider(),
//             const SizedBox(height: 6,),
//             const Text("Set Your Workout Plan ", style: TextStyle(color: Colors.blueGrey, fontSize: 20),)
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

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
      body: Stack(
        children: [
          Opacity(
            opacity: 0.13,
            child: CustomPaint(
              size: Size(double.infinity, double.infinity),
              painter: DottedPainter(),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/Dumbell.png', // Path to your image asset
                  width: 150, // Adjust the width as needed
                  height: 150, // Adjust the height as needed
                ),
                SizedBox(height: 20.0),
                Text(
                  'Workout Planner',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.0),
                Text(
                  'Start your fitness journey',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DottedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double dotSpacing = 25.0;
    final double dotRadius = 1.5;
    final Paint paint = Paint()..color = Colors.white;

    for (double i = 0; i < size.width; i += dotSpacing) {
      for (double j = 0; j < size.height; j += dotSpacing) {
        canvas.drawCircle(Offset(i, j), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}