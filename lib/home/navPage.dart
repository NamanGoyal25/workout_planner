import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_planner/home/create_plan.dart';
import 'package:workout_planner/home/execute_plan.dart';
import 'package:workout_planner/home/history_page.dart';
import 'package:workout_planner/home/home_page.dart';
import 'package:workout_planner/home/profile.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavPage extends StatefulWidget {
  const NavPage({Key? key}) : super(key: key);

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int index = 0;
  late User? currentUser;
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    screens = [
      HomePage(),
      HistoryPage(),
      CreatePlanPage(),
      ExecutePlanPage(),
      Profile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: GNav(
        rippleColor: Colors.black,
        hoverColor: Colors.black,
        haptic: true,
        tabBorderRadius: 15,
        tabActiveBorder: Border.all(color: Colors.transparent, width: 1),
        tabBorder: Border.all(color: Colors.transparent, width: 1),
        tabShadow: [
          BoxShadow(color: Colors.transparent.withOpacity(0.1), blurRadius: 8)
        ],
        curve: Curves.fastOutSlowIn,
        duration:Duration(milliseconds: 200),
        gap: 8,
        color: Colors.grey[800],
        activeColor: Colors.deepPurple[300],
        iconSize: 24,
        tabBackgroundColor: Colors.deepPurple.withOpacity(0.2),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.history,
            text: 'History',
          ),
          GButton(
            icon: Icons.add,
            text: 'Create',
          ),
          GButton(
            icon: Icons.play_arrow_outlined,
            text: 'Execute',
          )
        ],
        selectedIndex: index,
        onTabChange: (int newIndex) {
          setState(() {
            index = newIndex;
          });
        },
      ),
    );
  }
}
