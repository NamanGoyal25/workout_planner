import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool showLoader = false;

  // TextEditingController ageController = new TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: showLoader? Center(child: CircularProgressIndicator(),):
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image.asset("assets/logo4.png",width: 50,height: 50,),
              const SizedBox(height: 6,),
              const Text("Register", style: TextStyle(color: Colors.deepPurple, fontSize: 24),),
              const SizedBox(height: 4,),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: nameController ,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                    labelText: "Enter Full Name",
                    filled: false
                ),
              ),
              const SizedBox(height: 4,),
              // Dropdown for selecting age
              Container(
              child:SingleChildScrollView(
              child : InputDecorator(
                decoration: const InputDecoration(
                    filled: false,
                    labelText: "Select Your Age"),
                child: DropdownButtonFormField<int>(
                  value: selectedAge,
                  dropdownColor: Colors.black,
                  items: ages.map((int age) {
                    return DropdownMenuItem<int>(
                      value: age,
                      child: Text(age.toString(),
                        style: TextStyle(color: Colors.white),),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    setState(() {
                      selectedAge = value;
                    });
                  },
                ),
              ),
              ),
              ),
              const SizedBox(height: 4,),
              InputDecorator(
                  decoration: const InputDecoration(
                      filled: false,
                      labelText: "Select Your Gender")
              ),
              // Gender selection
              Row(
                children: [
                  Radio<String>(
                    value: "Male",
                    groupValue: selectedGender,
                    onChanged: (String? value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                  ),
                  const Text(
                      "Male",
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
                  const Text(
                    "Female",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              //TextFormField(
              //   keyboardType: TextInputType.text,
              //  // controller: genderController ,
              //   style: const TextStyle(
              //     color: Colors.white,
              //   ),
              //   decoration: const InputDecoration(
              //     filled: false,
              //   ),
              // ),
              const SizedBox(height: 4,),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: phonenumberController ,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                    labelText: "Enter Phone Number",
                  filled: false,
                ),
              ),
              const SizedBox(height: 4,),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController ,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  filled: false,
                    labelText: "Enter Email ID",
                ),
              ),
              const SizedBox(height: 4,),
              TextFormField(
                keyboardType: TextInputType.text,
                 controller: passwordController,
                 style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  filled: false,
                    labelText: "Enter Password",
                ),
                obscureText: true,
              ),
              const SizedBox(height: 4,),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: confirmpasswordController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  filled: false,
                    labelText: "Confirm Password ",
                ),
                obscureText: true,
              ),
              const SizedBox(height: 4,),
              OutlinedButton(onPressed: (){
                setState(() {
                  showLoader = true;
                  registerUser();
                });
              }, child: const Text("REGISTER")),
              const SizedBox(height: 12,),
              InkWell(
                child: const Text("Existing user? Login Here",  style: TextStyle(color: Colors.deepPurple, fontSize: 14,),),
                onTap: (){
                  Navigator.pushNamed(context, "/login");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
