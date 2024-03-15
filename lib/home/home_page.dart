import 'package:flutter/material.dart';
import 'package:workout_planner/home/create_plan.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> _signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    // Navigate to login page or any other page after signout
    Navigator.pushReplacementNamed(context, '/login');
  } catch (e) {
    print("Error signing out: $e");
  }
}

Future<void> _showSignOutConfirmationDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Sign Out'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Are you sure you want to sign out?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Sign Out'),
            onPressed: () {
              _signOut(context); // Call signout function with context
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout_sharp),
            color: Colors.white,
            onPressed: () {
              _showSignOutConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Workout Planner", style: TextStyle(color: Colors.white, fontSize: 34)),
            const SizedBox(height: 6,),
            const Text("Set Your Workout Plan ", style: TextStyle(color: Colors.deepPurple, fontSize: 20)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreatePlanPage()));
              },
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}