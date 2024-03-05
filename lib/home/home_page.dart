import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_planner/home/analysis_page.dart';
import 'package:workout_planner/home/create_plan.dart';
import 'package:workout_planner/home/execute_plan.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePageContent(), // Placeholder for Home Page content
    CreatePlanPage(),
    ExecutePlanPage(),
    AnalysisPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.deepPurple,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: 'Execute Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Graph Page',
          ),
        ],
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/logo4.png", width: 200, height: 200,),
            const SizedBox(height: 12),
            const Text("Workout Planner", style: TextStyle(color: Colors.white, fontSize: 34,),),
            const Divider(),
            const SizedBox(height: 6,),
            const Text("Set Your Workout Plan ", style: TextStyle(color: Colors.deepPurple, fontSize: 20),),
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







