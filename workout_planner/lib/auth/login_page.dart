import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool showLoader = false;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  void loginUser() async{
    print("Email:"+emailController.text.trim());
    print("Password:"+passwordController.text.trim());

    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
      print("User Signed In Successfully:"+userCredential.user!.uid.toString());

      if(userCredential.user!.uid.isNotEmpty){
        Navigator.pushReplacementNamed(context, "/home");
      }

    } on FirebaseAuthException catch(e) {
      print("Something Went Wrong: "+e.message.toString());
      print("Error code: "+e.code.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: showLoader ? Center(child: CircularProgressIndicator(),) :
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/logo4.png", width: 200, height: 200,),
            const SizedBox(height: 12,),
            const Text("Login", style: TextStyle(color: Colors.deepPurple, fontSize: 24,),),
            const SizedBox(height: 6,),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                labelText: "Enter Email ID",
              ),
            ),
            const SizedBox(height: 6,),
            TextFormField(
              keyboardType: TextInputType.text,
              style: const TextStyle(
                color: Colors.white,
              ),
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Enter Password",
              ),
            ),
            const SizedBox(height: 6,),
            OutlinedButton(onPressed: (){

              setState(() {
                Navigator.pushReplacementNamed(context, "/home");
                showLoader = true;
              });

              loginUser();

            }, child: const Text("Login")),
            const SizedBox(height: 12,),
            InkWell(
              child: const Text("New User? Register Here",  style: TextStyle(color: Colors.deepPurple, fontSize: 14,),),
              onTap: (){
                Navigator.pushNamed(context, "/register");
                },
            )

          ],
        ),
      ),
    );
  }
}
