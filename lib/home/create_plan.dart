import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'days_page.dart';

class CreatePlanPage extends StatefulWidget {
  @override
  _CreatePlanPageState createState() => _CreatePlanPageState();
}

class _CreatePlanPageState extends State<CreatePlanPage> {
  int? selectedWeek;

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CardWidget(
              title: "Week 1",
              backgroundColour: Color(0xffFFAF58),
              weekNumber: 1,
              onTap: () {
                setState(() {
                  selectedWeek = 1;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DaysPage(selectedWeek: selectedWeek)),
                );
              },
            ),
          ),
          Expanded(
            child: CardWidget(
              title: "Week 2",
              backgroundColour: Color(0xffFFAF58),
              weekNumber: 2,
              onTap: () {
                setState(() {
                  selectedWeek = 2;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DaysPage(selectedWeek: selectedWeek)),
                );
              },
            ),
          ),
          Expanded(
            child: CardWidget(
              title: "Week 3",
              backgroundColour: Color(0xffFFAF58),
              weekNumber: 3,
              onTap: () {
                setState(() {
                  selectedWeek = 3;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DaysPage(selectedWeek: selectedWeek)),
                );
              },
            ),
          ),
          Expanded(
            child: CardWidget(
              title: "Week 4",
              backgroundColour: Color(0xffFFAF58),
              weekNumber: 4,
              onTap: () {
                setState(() {
                  selectedWeek = 4;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DaysPage(selectedWeek: selectedWeek)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String title;
  final Color backgroundColour;
  final int weekNumber;
  final VoidCallback onTap;

  const CardWidget({
    required this.title,
    required this.weekNumber,
    required this.backgroundColour,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final startDate = getStartDateOfWeek(weekNumber);
    final weekRange = getWeekRangeWithMonthNames(startDate);
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0xffFFAF58),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(0),
        color: backgroundColour,
        child: InkWell(
          onTap: onTap,
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
      ),
    );
  }

  DateTime getStartDateOfWeek(int weekNumber) {
    DateTime startDate = DateTime.now().subtract(
      Duration(days: (DateTime.monday - 1) + (weekNumber - 1) * 7),
    );
    if (startDate.weekday != DateTime.monday) {
      startDate = startDate.subtract(Duration(days: (startDate.weekday - DateTime.monday) % 7));
    }
    return startDate;
  }

  DateTime getWeekRangeWithMonthNames(DateTime startDate) {
    DateTime endDate = startDate.add(Duration(days: 6));
    DateTime lastDayOfMonth = DateTime(startDate.year, startDate.month + 1, 0);
    if (endDate.isAfter(lastDayOfMonth)) {
      endDate = lastDayOfMonth;
    }
    return endDate;
  }
}
