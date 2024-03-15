import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_planner/home/create_plan.dart';
import 'package:workout_planner/home/execute_plan.dart';
import 'package:workout_planner/home/history.dart';
import 'package:workout_planner/home/home_page.dart';
import 'package:workout_planner/home/profile.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

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
      History(),
      CreatePlanPage(),
      ExecutePlanPage(),
      Profile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[index],
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0xff303030),
                offset: Offset(2.0, 1.0),
                blurRadius: 3.0,
                spreadRadius: 3.0,
              ), //BoxShadow
            ],
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: Colors.deepPurple.shade400,
              surfaceTintColor: Color(0xff202020),
              labelTextStyle: MaterialStateProperty.all(
                TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
            ),
            child: NavigationBar(
              height: 60,
              backgroundColor: Colors.black,
              selectedIndex: index,
              onDestinationSelected: (index) =>
                  setState(() => this.index = index),
              destinations: [

                NavigationDestination(
                    icon: Icon(
                      Icons.home_outlined,
                      color: Colors.grey,
                    ),
                    selectedIcon: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    label: 'Home'),

                NavigationDestination(
                    icon: Icon(
                      Icons.history_outlined,
                      color: Colors.grey,
                    ),
                    selectedIcon: Icon(
                      Icons.history,
                      color: Colors.white,
                    ),
                    label: "History"),

                NavigationDestination(
                    icon: Icon(
                      Icons.add_outlined,
                      color: Colors.grey,
                    ),
                    selectedIcon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: 'Create Plan'),

                NavigationDestination(
                  icon: Icon(
                    Icons.play_arrow_outlined,
                    color: Colors.grey,
                  ),
                  selectedIcon: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                  label: 'Execute Plan',
                ),

                NavigationDestination(
                    icon: Icon(
                      Icons.person_2_outlined,
                      color: Colors.grey,
                    ),
                    selectedIcon: Icon(
                      Icons.person_2,
                      color: Colors.white,
                    ),
                    label: "Profile"),

              ],
            ),
          ),
        )
    );
  }
}