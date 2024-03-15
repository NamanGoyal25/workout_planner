import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool showLoader = false;

  TextEditingController ageController = new TextEditingController();
  TextEditingController phonenumberController = new TextEditingController();
  //TextEditingController genderController = new TextEditingController();
  TextEditingController confirmpasswordController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  int? selectedAge;
  String? selectedGender;

  List<int> ages = List.generate(100, (index) => index + 1);




  void registerUser() async {
    print("Name:${nameController.text.trim()}");
    print("Age: $selectedAge");
    print("Gender: $selectedGender");
    print("Phone Number:${phonenumberController.text.trim()}");
    print("Email:${emailController.text.trim()}");
    print("Password:" + passwordController.text.trim());
    print("Confirm Password:" + confirmpasswordController.text.trim());

    if (passwordController.text.trim() != confirmpasswordController.text.trim()) {
      print("Passwords do not match.");
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: emailController.text.trim(),
        password: passwordController.text.trim(),);
      print("User Created Successfully:" + userCredential.user!.uid.toString
        ());

      //Save the user details in the Cloud Firestore Database
      FirebaseFirestore.instance.collection("users").doc(userCredential.user!
          .uid).set(
          {
            "name": nameController.text.trim(),
            "age": selectedAge,
            "gender": selectedGender,
            "phone number": phonenumberController.text.trim(),
            "email": emailController.text.trim(),
            "createdOn": DateTime.now(),
          }
      ).then((value) => Navigator.pushReplacementNamed(context, "/home"));

      // if (userCredential.user!.uid.isNotEmpty){
      //   Navigator.pushReplacementNamed(context, "/home");
      // }

    }
    on FirebaseAuthException catch (e) {
      print("Something Went Wrong:" + e.message.toString());
      print("Error Code:" + e.code.toString());
    }
  }

  // State variable to track whether passwords match
  bool passwordsMatch = false;
  String? _confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: showLoader? Center(child: CircularProgressIndicator(),):
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height:30),

              Text("Sign Up", style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Colors.white,
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
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.deepPurple, // Cursor color
                  decoration: InputDecoration(
                    hintText: "Full Name", // Hint text
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.75)), // Opacity for hint text
                    border: InputBorder.none, // Remove border
                    enabledBorder: InputBorder.none, // Remove border when enabled
                    focusedBorder: InputBorder.none, // Remove border when focused
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: ageController,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.deepPurple, // Cursor color
                  decoration: InputDecoration(
                    hintText: "Age", // Hint text
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.75)), // Opacity for hint text
                    border: InputBorder.none, // Remove border
                    enabledBorder: InputBorder.none, // Remove border when enabled
                    focusedBorder: InputBorder.none, // Remove border when focused
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: phonenumberController,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.deepPurple, // Cursor color
                  decoration: InputDecoration(
                    hintText: "Phone Number", // Hint text
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.75)), // Opacity for hint text
                    border: InputBorder.none, // Remove border
                    enabledBorder: InputBorder.none, // Remove border when enabled
                    focusedBorder: InputBorder.none, // Remove border when focused
                  ),
                ),
              ),

              const SizedBox(height: 10),

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
                    hintText: "Email ID", // Hint text
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.75)), // Opacity for hint text
                    border: InputBorder.none, // Remove border
                    enabledBorder: InputBorder.none, // Remove border when enabled
                    focusedBorder: InputBorder.none, // Remove border when focused
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: passwordController,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.deepPurple, // Cursor color
                  decoration: InputDecoration(
                    hintText: "Password", // Hint text
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.75)), // Opacity for hint text
                    border: InputBorder.none, // Remove border
                    enabledBorder: InputBorder.none, // Remove border when enabled
                    focusedBorder: InputBorder.none, // Remove border when focused
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      passwordsMatch = value == confirmpasswordController.text;
                    });
                  },
                ),
              ),

              const SizedBox(height: 10),

              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: confirmpasswordController,
                  onChanged: (value) {
                    setState(() {
                      if(value == ''){
                        _confirmPassword=null;
                      }else {
                        _confirmPassword = value;
                      }
                    });
                  },
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.deepPurple, // Cursor color
                  decoration: InputDecoration(
                    hintText: "Confirm Password", // Hint text
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.75)), // Opacity for hint text
                    border: InputBorder.none, // Remove border
                    enabledBorder: InputBorder.none, // Remove border when enabled
                    focusedBorder: InputBorder.none, // Remove border when focused
                    suffixIcon: _confirmPassword != null && _confirmPassword == passwordController.text
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : _confirmPassword != null && _confirmPassword != passwordController.text
                        ? Icon(Icons.cancel, color: Colors.red)
                        : null, // Display green tick or red cross based on password match
                  ),
                  obscureText: true,
                ),
              ),

              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    color: Colors.transparent
                ),
                child:Row(
                  children: [
                    Text('Gender : ',style: TextStyle(color: Colors.white),),
                    Radio<String>( value: "Male",
                      groupValue: selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    const Text("Male",
                      style: TextStyle(color: Colors.white),
                    ),
                    Radio<String>(
                      value: "Female",
                      groupValue: selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    const Text("Female",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

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
                    setState(() {
                      showLoader = true;
                    });
                    registerUser();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Set transparent color
                    elevation: 0, // Remove shadow
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text("Register",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Existing User ? ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  InkWell(
                    child: Text("Login Here",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/login");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}