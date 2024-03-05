import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_planner/home/analysis_page.dart';
import 'package:workout_planner/home/home_page.dart';


class ExecutePlanPage extends StatefulWidget {
  @override
  State<ExecutePlanPage> createState() => _ExecutePlanPageState();
}

class _ExecutePlanPageState extends State<ExecutePlanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Execute Plan Page'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AnalysisPage()));
              },
              child: Text('Go to Graph Page'),
            ),
          ],
        ),
      ),
    );
  }
}
