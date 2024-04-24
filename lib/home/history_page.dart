// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class HistoryPage extends StatefulWidget {
//   const HistoryPage({Key? key}) : super(key: key);
//
//   @override
//   State<HistoryPage> createState() => _HistoryPageState();
// }
//
// class _HistoryPageState extends State<HistoryPage> {
//   late String? currentDay;
//   late String? currentMonthYear;
//   late int numberOfDaysInMonth;
//   late int numberOfWeeksInMonth;
//   late int currentWeekNumber;
//   String userId = FirebaseAuth.instance.currentUser!.uid;
//   String selectedMonth = ''; // Variable to store the selected month
//
//
//   @override
//   void initState() {
//     super.initState();
//     userId = FirebaseAuth.instance.currentUser!.uid;
//     numberOfWeeksInMonth = (DateTime.now().day / 7).ceil();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('History Page'),
//         actions: [
//           Container(
//               width: 80,
//               decoration: BoxDecoration(
//                   color: Colors.black,
//                   border: Border.all(color: Colors.black),
//                   borderRadius: BorderRadius.circular(20)),
//               child: GestureDetector(
//                 child: Icon(
//                   Icons.arrow_drop_down,
//                   size: 30,
//                   color: Colors.white,
//                 ),
//                 onTap: ()async  {
//                  var monthList = await FirebaseFirestore.instance.collection
//                    ('users')
//                       .doc(userId)
//                       .get();
//
//
//
//                 },
//               ))
//         ],
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(userId)
//             .snapshots(),
//         builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
//           if (userSnapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
//             return const Center(child: Text('No data available'));
//           }
//           return ListView.builder(
//             itemCount: numberOfWeeksInMonth,
//             itemBuilder: (context, index) {
//               return Card(
//                 child: ListTile(
//                   title: Text('Week ${index + 1}'),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => WeekPlanPage(
//                           userId: userId,
//                           weekNumber: index + 1,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// class WeekPlanPage extends StatelessWidget {
//   final String userId;
//   final int weekNumber;
//
//   const WeekPlanPage({
//     required this.userId,
//     required this.weekNumber,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     String currentMonthYear = DateFormat('MMMyyyy').format(DateTime.now());
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Week $weekNumber Plan'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(userId)
//             .collection('Week$weekNumber,$currentMonthYear')
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(
//                 child: Text('No data available for Week $weekNumber'));
//           }
//
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               var document = snapshot.data!.docs[index];
//
//               return Card(
//                 child: ListTile(
//                   title: Text(document.id),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => DayPlanPage(
//                           userId: userId,
//                           weekNumber: weekNumber,
//                           day: document.id,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// class DayPlanPage extends StatefulWidget {
//   final String userId;
//   final int weekNumber;
//   final String day;
//
//   const DayPlanPage({
//     required this.userId,
//     required this.weekNumber,
//     required this.day,
//   });
//
//   @override
//   State<DayPlanPage> createState() => _DayPlanPageState();
// }
//
// class _DayPlanPageState extends State<DayPlanPage> {
//   bool _isGoalAchieved = false;
//
//   @override
//   Widget build(BuildContext context) {
//     String currentMonthYear = DateFormat('MMMyyyy').format(DateTime.now());
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Day ${widget.day} Plan'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(widget.userId)
//             .collection('Week${widget.weekNumber},$currentMonthYear')
//             .doc(widget.day)
//             .collection('executed')
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(
//                 child: Text('No data available for Day ${widget.day}'));
//           }
//           bool allExercisesDone = true;
//
//           for (var document in snapshot.data!.docs) {
//             var exercise = document.data() as Map<String, dynamic>;
//             if (exercise['done'] != 'yes' && exercise['done'] != true) {
//               print("Naman");
//               // print(exercise['done']);
//               print("hi");
//               allExercisesDone = false;
//               break;
//             }
//           }
//
//           if (allExercisesDone && !_isGoalAchieved) {
//             _isGoalAchieved = true;
//             // _showCongratulationsDialog(context);
//             print("Goyal");
//             print("All exercises done: $allExercisesDone");
//             print("Goal achieved: $_isGoalAchieved");
//           }
//
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               var document = snapshot.data!.docs[index];
//               var exercise = document.data() as Map<String, dynamic>;
//               // Fetch the exercises array
//               List<dynamic> exercises = exercise['exercises'];
//
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: exercises.map((exercise) {
//                   return Card(
//                     color:
//                         exercise["done"] == 'yes' ? Colors.green : Colors.grey,
//                     child: ListTile(
//                       title: Text('Exercise: ${exercise['exerciseName']}'),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Goal',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               decoration: TextDecoration.underline,
//                             ),
//                           ),
//                           Text('Reps: ${exercise['repetitions']}'),
//                           Text('Sets: ${exercise['sets']}'),
//                           Text('Weight: ${exercise['weight']} kg'),
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(const MaterialApp(
//     home: HistoryPage(),
//   ));
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late String? currentDay;
  late String? currentMonthYear;
  late int numberOfDaysInMonth;
  late int numberOfWeeksInMonth;
  late int currentWeekNumber;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  String selectedMonth = ''; // Variable to store the selected month
  String selectedYear = ''; // Variable to store the selected year

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    numberOfWeeksInMonth = (DateTime.now().day / 7).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Page'),
        actions: [
          Container(
            width: 150,
            decoration: BoxDecoration(
              // border : Border.all(color: Colors.red)
            ),
            // color: Colors.white,
            // padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: Row(

              children: [

                DropdownButton<String>(
                  value: selectedMonth.isEmpty ? null : selectedMonth,
                  hint: Text('Month'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMonth = newValue!;
                    });
                  },
                  items: [
                    'Jan',
                    'Feb',
                    'Mar',
                    'Apr',
                    'May',
                    'Jun',
                    'Jul',
                    'Aug',
                    'Sep',
                    'Oct',
                    'Nov',
                    'Dec'
                  ].map<DropdownMenuItem<String>>(
                        (String month) => DropdownMenuItem<String>(
                      value: month,
                      child: Text(month),
                    ),
                  ).toList(),
                ),

                SizedBox(width: 8.0),

                DropdownButton<String>(
                  value: selectedYear.isEmpty ? null : selectedYear,
                  hint: Text('Year'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedYear = newValue!;
                    });
                  },
                  items: List.generate(10, (index) {
                    int year = DateTime.now().year - index;
                    return DropdownMenuItem<String>(
                      value: year.toString(),
                      child: Text(year.toString()),
                    );
                  }),
                ),

              ],
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
            return const Center(child: Text('No data available'));
          }
          return ListView.builder(
            itemCount: numberOfWeeksInMonth,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text('Week ${index + 1}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeekPlanPage(
                          userId: userId,
                          weekNumber: index + 1,
                          selectedYear: selectedYear,
                          selectedMonth: selectedMonth,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class WeekPlanPage extends StatelessWidget {
  final String userId;
  final int weekNumber;
  final String selectedYear;
  final String selectedMonth;

  const WeekPlanPage({
    required this.userId,
    required this.weekNumber,
    required this.selectedYear,
    required this.selectedMonth,
  });

  @override
  Widget build(BuildContext context) {
    String currentMonthYear = DateFormat('MMMyyyy').format(DateTime.now());
    String weekMonthYear = 'Week$weekNumber,$selectedMonth$selectedYear'; // Format the week, month, and year

    return Scaffold(
      appBar: AppBar(
        title: Text('Week $weekNumber Plan'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(userId).collection(weekMonthYear).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available for Week $weekNumber'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var document = snapshot.data!.docs[index];

              return Card(
                child: ListTile(
                  title: Text(document.id),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DayPlanPage(
                          userId: userId,
                          weekNumber: weekNumber,
                          day: document.id,
                          selectedYear: selectedYear,
                          selectedMonth: selectedMonth,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DayPlanPage extends StatefulWidget {
  final String userId;
  final int weekNumber;
  final String day;
  final String selectedYear;
  final String selectedMonth;

  const DayPlanPage({
    required this.userId,
    required this.weekNumber,
    required this.day,
    required this.selectedYear,
    required this.selectedMonth,
  });

  @override
  State<DayPlanPage> createState() => _DayPlanPageState();
}

class _DayPlanPageState extends State<DayPlanPage> {
  bool _isGoalAchieved = false;

  @override
  Widget build(BuildContext context) {
    String currentMonthYear = DateFormat('MMMyyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Day ${widget.day} Plan'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .collection('Week${widget.weekNumber},${widget.selectedMonth}${widget.selectedYear}')
            .doc(widget.day)
            .collection('executed')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available for Day ${widget.day}'));
          }
          bool allExercisesDone = true;

          for (var document in snapshot.data!.docs) {
            var exercise = document.data() as Map<String, dynamic>;
            if (exercise['done'] != 'yes' && exercise['done'] != true) {
              print("Naman");
              // print(exercise['done']);
              print("hi");
              allExercisesDone = false;
              break;
            }
          }

          if (allExercisesDone && !_isGoalAchieved) {
            _isGoalAchieved = true;
            // _showCongratulationsDialog(context);
            print("Goyal");
            print("All exercises done: $allExercisesDone");
            print("Goal achieved: $_isGoalAchieved");
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var document = snapshot.data!.docs[index];
              var exercise = document.data() as Map<String, dynamic>;
              // Fetch the exercises array
              List<dynamic> exercises = exercise['exercises'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: exercises.map((exercise) {
                  return Card(
                    color: exercise["done"] == 'yes' ? Colors.green : Colors.grey,
                    child: ListTile(
                      title: Text('Exercise: ${exercise['exerciseName']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Goal',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          Text('Reps: ${exercise['repetitions']}'),
                          Text('Sets: ${exercise['sets']}'),
                          Text('Weight: ${exercise['weight']} kg'),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: HistoryPage(),
  ));
}
