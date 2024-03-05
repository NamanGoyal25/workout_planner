import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showLoader = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  int currentImageIndex = 0;
  List<String> backgroundImagePaths = [
    "assets/gym_logo.jpeg",
    "assets/login_photo.jpg",
    "assets/gymLogo.jpeg",
  ];

  late Timer timer;

  void loginUser() async {
    print("Email: ${emailController.text.trim()}");
    print("Password: ${passwordController.text.trim()}");

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      print("User Signed In Successfully: ${userCredential.user!.uid.toString()}");
      if (userCredential.user!.uid.isNotEmpty) {
        Navigator.pushReplacementNamed(context, "/home");
      }
    } on FirebaseAuthException catch (e) {
      print("Something Went Wrong: ${e.message.toString()}");
      print("Error Code: ${e.code.toString()}");
    }
  }

  @override
  void initState() {
    super.initState();
    // Set up a timer to change the background image every 3 seconds
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      setState(() {
        currentImageIndex = (currentImageIndex + 1) % backgroundImagePaths.length;
      });
    });
  }

  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: showLoader
          ? Center(child: CircularProgressIndicator())
          : Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            backgroundImagePaths[currentImageIndex],
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image.asset("assets/gym_icon.jpg", width: 100, height: 100,),
                const SizedBox(height: 12,),
                const Text("Login", style: TextStyle(color: Colors.white,
                    fontSize: 24),),
                const SizedBox(height: 6,),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular
                    (10.0)),labelText: "Enter Email ID", filled: true),
                ),
                const SizedBox(height: 6,),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: passwordController,
                  decoration: InputDecoration(border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),labelText: ""
                      "Enter Password", filled: true,),
                  obscureText: true,
                ),
                const SizedBox(height: 6,),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pushReplacementNamed(context, "/home");
                      showLoader = true;
                      loginUser();
                    });
                  },
                  child: Text("LOGIN", style: TextStyle(color: Colors.white),),
                ),
                const SizedBox(height: 12,),
                InkWell(
                  child: const Text("New user? Register Here ", style: TextStyle(
                      color: Colors.white, fontSize:17
                  ),),
                  onTap: () {
                    Navigator.pushNamed(context, "/register");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
