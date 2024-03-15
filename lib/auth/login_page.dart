import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showLoader = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void loginUser() async {
    if (emailController.text.trim().isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter valid email and password.', style: TextStyle(color: Colors.white),textAlign: TextAlign.center),
        backgroundColor: Colors.red.shade600,
        duration: Duration(seconds: 2),
      ));
      return;
    }

    setState(() {
      showLoader = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      print("User Signed In Successfully:" +
          userCredential.user!.uid.toString());

      if (userCredential.user!.uid.isNotEmpty) {
        Navigator.pushReplacementNamed(context, "/nav");
      }
    } on FirebaseAuthException catch (e) {
      print("Something Went Wrong: " + e.message.toString());
      print("Error code: " + e.code.toString());

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid credentials. Please try again.', style: TextStyle(color: Colors.white),textAlign: TextAlign.center),
        backgroundColor: Colors.red.shade600,

      ));
    } finally {
      setState(() {
        showLoader = false;
      });
    }
  }


  bool _isPasswordVisible= true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text('to your own fitness companion',
                    style: GoogleFonts.montserrat(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic
                    ),
                  ),
                  SizedBox(height: 30),

                  Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.deepPurple, // Cursor color
                      decoration: InputDecoration(
                        hintText: "Enter Email ID", // Hint text
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.75)), // Opacity for hint text
                        border: InputBorder.none, // Remove border
                        enabledBorder: InputBorder.none, // Remove border when enabled
                        focusedBorder: InputBorder.none, // Remove border when focused
                      ),
                    ),
                  ),


                  SizedBox(height: 20),

                  Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child:TextFormField(
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.deepPurple, // Cursor color
                      decoration: InputDecoration(
                        hintText: "Enter Password", // Hint text
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.75)),
                        suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            icon:Icon(_isPasswordVisible? Icons.visibility_off_outlined: Icons.visibility_outlined)
                        ), // Opacity for hint text
                        border: InputBorder.none, // Remove border
                        enabledBorder: InputBorder.none, // Remove border when enabled
                        focusedBorder: InputBorder.none, // Remove border when focused
                      ),
                      obscureText: _isPasswordVisible,
                    ),
                  ),

                  SizedBox(height: 20),

                  Container(
                    padding: EdgeInsets.all(1.0),
                    width: MediaQuery.of(context).size.width * 0.9, // Adjust width with MediaQuery
                    // Set a fixed height or adjust with MediaQuery
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple,
                          Colors.deepPurple,
                          Colors.purple,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),

                    child: ElevatedButton(
                      onPressed: () {
                        loginUser();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, // Set transparent color
                        elevation: 0, // Remove shadow
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: showLoader ?
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.08, // Adjust width fraction as needed
                        height: MediaQuery.of(context).size.width * 0.08, // Adjust height fraction as needed
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2, // Adjust strokeWidth as needed
                        ),
                      )
                          : Text("Login",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),


                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("New User ? ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      InkWell(
                        child: Text(
                          "Register Here",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, "/register");
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}