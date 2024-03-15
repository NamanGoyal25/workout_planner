import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text('Profile data')
        ],
      ),
    );
  }
}