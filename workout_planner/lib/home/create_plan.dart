import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_planner/home/execute_plan.dart';
import 'package:workout_planner/home/home_page.dart';

class CreatePlanPage extends StatefulWidget {
  @override
  _CreatePlanPageState createState() => _CreatePlanPageState();
}
class _CreatePlanPageState extends State<CreatePlanPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Create Plan Page'),
        backgroundColor: Colors.black,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: CardWidget(
                title: "Week 1",
                backgroundColour: Colors.pinkAccent,
                weekNumber: 1,
              ),
          ),
          Expanded(
              child: CardWidget(
                title: "Week 2",
                backgroundColour: Colors.orangeAccent,
                weekNumber: 2,
              )
          ),
          Expanded(
              child: CardWidget(
                title: "Week 3",
                backgroundColour: Colors.lightGreenAccent,
                weekNumber: 3,
              )
          ),
          Expanded(
              child: CardWidget(
                title: "Week 4",
                backgroundColour: Colors.purpleAccent,
                weekNumber: 4,
              )
          ),
        ],
      ),
    );
  }

  String getFormattedDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return formattedDate;
  }
}

class CardWidget extends StatelessWidget {
  final String title;
  final Color backgroundColour;
  final int weekNumber;

  const CardWidget({
    required this.title,
    required this.weekNumber,
    required this.backgroundColour
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the start date of the current week
    final startDate = getStartDateOfWeek(weekNumber);

    // Get the week range with month names
    final weekRange = getWeekRangeWithMonthNames(startDate);
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      color: backgroundColour,
      child: InkWell(
        onTap: (){
          Navigator.pushNamed(context, "/days");
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 8,),
              Text(title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),),
              const SizedBox(height: 10),
              Text(
                ' ${weekRange.day} ${DateFormat('MMM').format(weekRange)}-${weekRange.add(Duration(days: 6)).day} ${DateFormat('MMM').format(weekRange.add(Duration(days: 6)))}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Function to get the start date of the week based on week number
  DateTime getStartDateOfWeek(int weekNumber) {
    // Calculate the start date of the current week
    DateTime startDate = DateTime.now().subtract(
      Duration(days: (DateTime.monday - 1) + (weekNumber - 1) * 7),
    );

    // If the start date is not Monday, adjust it to the previous Monday
    if (startDate.weekday != DateTime.monday) {
      startDate = startDate.subtract(Duration(days: (startDate.weekday - DateTime.monday) % 7));
    }

    return startDate;
  }

  // Function to get the week range with month names
  DateTime getWeekRangeWithMonthNames(DateTime startDate) {
    // Calculate the ending date of the current week
    DateTime endDate = startDate.add(Duration(days: 6));
    DateTime lastDayOfMonth = DateTime(startDate.year, startDate.month + 1, 0);


    if (endDate.isAfter(lastDayOfMonth)) {
      endDate = lastDayOfMonth;
    }

    // Return the end date of the current week
    return endDate;
  }
}
