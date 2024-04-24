// import 'dart:async';
// import 'dart:ui';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
//
// class ExecutePlanPage extends StatefulWidget {
//   const ExecutePlanPage({Key? key});
//
//   @override
//   State<ExecutePlanPage> createState() => _ExecutePlanPageState();
// }
//
// class _ExecutePlanPageState extends State<ExecutePlanPage> {
//   late int numberOfWeeksInMonth;
//   late String userId;
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
//         title: const Text('Execute Plan Page'),
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
//               allExercisesDone = false;
//               break;
//             }
//           }
//
//           if (allExercisesDone && !_isGoalAchieved) {
//             _isGoalAchieved = true;
//             _showCongratulationsDialog(context);
//
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
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.edit),
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => EditButton(
//                                     exerciseData: exercise,
//                                     userId: widget.userId,
//                                     weekNumber: widget.weekNumber,
//                                     currentMonthYear: currentMonthYear,
//                                     day: widget.day,
//                                     exerciseRef: document.reference,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(
//                               exercise['done'] == 'yes'
//                                   ? Icons.check_circle
//                                   : Icons.check_circle_outline,
//                               color: exercise['done'] == 'yes'
//                                   ? Colors.green
//                                   : null,
//                             ),
//                             onPressed: () async {
//                               // Get a reference to the documents within the executed subcollection
//                               QuerySnapshot<Map<String, dynamic>>
//                               querySnapshot = await FirebaseFirestore
//                                   .instance
//                                   .collection('users')
//                                   .doc(widget.userId)
//                                   .collection(
//                                   'Week${widget.weekNumber},$currentMonthYear')
//                                   .doc(widget.day)
//                                   .collection('executed')
//                                   .get();
//
//                               // Loop through each document in the subcollection
//                               for (QueryDocumentSnapshot<
//                                   Map<String, dynamic>> documentSnapshot
//                               in querySnapshot.docs) {
//                                 // Get the document reference
//                                 DocumentReference<Map<String, dynamic>> docRef =
//                                     documentSnapshot.reference;
//
//                                 // Fetch the current array of exercises
//                                 DocumentSnapshot<Map<String, dynamic>>
//                                 snapshot = await docRef.get();
//                                 List<dynamic> exercises =
//                                 snapshot.data()!['exercises'];
//
//                                 // Find the index of the exercise to be updated
//                                 int index = exercises.indexWhere((exercis) =>
//                                 exercis['exerciseName'] ==
//                                     exercise['exerciseName']);
//
//                                 // If the exercise is found, replace it with the updated exercise
//                                 if (index != -1) {
//                                   exercises[index]!['done'] == 'yes'
//                                       ? exercises[index]!['done'] = 'no'
//                                       : exercises[index]!['done'] = 'yes';
//
//                                   await docRef.set({'exercises': exercises},
//                                       SetOptions(merge: true));
//                                   print(
//                                       'Exercise data updated successfully for document ${docRef.id}');
//
//                                   // Update the exercises array in Firestore
//                                 }
//                               }
//                             },
//                           )
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
// void _showCongratulationsDialog(BuildContext context) {
//   Fluttertoast.showToast(
//     msg: "Congratulations! You have achieved your goal for the day",
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.CENTER,
//     timeInSecForIosWeb: 1,
//     backgroundColor: Colors.green,
//     textColor: Colors.white,
//     fontSize: 16.0,
//   );
// }
//
// class EditButton extends StatefulWidget {
//   final String userId;
//   final int weekNumber;
//   final String currentMonthYear;
//   final String day;
//   final Map<String, dynamic> exerciseData;
//   final DocumentReference<Object?> exerciseRef;
//
//   const EditButton({
//     Key? key,
//     required this.exerciseData,
//     required this.userId,
//     required this.weekNumber,
//     required this.currentMonthYear,
//     required this.day,
//     required this.exerciseRef,
//   }) : super(key: key);
//
//   @override
//   State<EditButton> createState() => _EditButtonState();
// }
//
// class _EditButtonState extends State<EditButton> {
//   late TextEditingController repsController;
//   late TextEditingController setsController;
//   late TextEditingController weightController;
//   late bool isDone;
//
//   @override
//   void initState() {
//     super.initState();
//     repsController = TextEditingController(
//       text: widget.exerciseData['repetitions'] != null
//           ? widget.exerciseData['repetitions'].toString()
//           : '',
//     );
//     setsController =
//         TextEditingController(text: widget.exerciseData['sets'].toString());
//     weightController =
//         TextEditingController(text: widget.exerciseData['weight'].toString());
//     isDone = widget.exerciseData['done'] == 'yes';
//   }
//
//   @override
//   void dispose() {
//     repsController.dispose();
//     setsController.dispose();
//     weightController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _updateExerciseData() async {
//     // Extract the exercise data from the widget
//     Map<String, dynamic> updatedExercise = {
//       'exerciseName': widget.exerciseData['exerciseName'],
//       'repetitions': repsController.text,
//       'sets': setsController.text,
//       'weight': weightController.text,
//       'done': isDone ? 'yes' : 'no',
//       // 'timestamp' : DateTime.now(),
//     };
//
//     // // Add timestamp if exercise is marked as done
//     if (isDone ) {
//       updatedExercise['timestamp'] = DateTime.now();
//     }
//     print('Is exercise done? $isDone');
//
//     // Get a reference to the documents within the executed subcollection
//     QuerySnapshot<Map<String, dynamic>> querySnapshot =
//     await widget.exerciseRef.parent.parent!.collection('executed').get();
//
//     // Loop through each document in the subcollection
//     for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
//     in querySnapshot.docs) {
//       // Get the document reference
//       DocumentReference<Map<String, dynamic>> docRef =
//           documentSnapshot.reference;
//
//       // Fetch the current array of exercises
//       DocumentSnapshot<Map<String, dynamic>> snapshot = await docRef.get();
//       List<dynamic> exercises = snapshot.data()!['exercises'];
//
//       // Find the index of the exercise to be updated
//       int index = exercises.indexWhere((exercise) =>
//       exercise['exerciseName'] == updatedExercise['exerciseName']);
//
//       // If the exercise is found, replace it with the updated exercise
//       if (index != -1) {
//         exercises[index] = updatedExercise;
//
//         // Update the exercises array in Firestore
//         await docRef.set({'exercises': exercises}, SetOptions(merge: true));
//         print('Exercise data updated successfully for document ${docRef.id}');
//
//         // Check if all exercises are marked as done
//         if (exercises.every((exercise) => exercise['done'] == 'yes')) {
//           _showCongratsDialog();
//         }
//       }
//     }
//
//     // Show snackbar message
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Exercise data updated successfully!'),
//       ),
//     );
//   }
//
//   Future<void> _showCongratsDialog() async {
//     // Blur the background
//     final double blur = 10.0;
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
//           child: AlertDialog(
//             title: const Text('Congratulations!'),
//             content: const Text('You have achieved your goal for the day.'),
//           ),
//         );
//       },
//     );
//     // Remove the blur effect after the dialog is dismissed
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Exercise'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: repsController,
//               decoration: const InputDecoration(labelText: 'Reps'),
//               keyboardType: TextInputType.number,
//             ),
//             TextFormField(
//               controller: setsController,
//               decoration: const InputDecoration(labelText: 'Sets'),
//               keyboardType: TextInputType.number,
//             ),
//             TextFormField(
//               controller: weightController,
//               decoration: const InputDecoration(labelText: 'Weight (in kg)'),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () async {
//                 await _updateExerciseData();
//                 Navigator.pop(context);
//
//               },
//               child: const Text("UPDATE"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(const MaterialApp(
//     home: ExecutePlanPage(),
//   ));
// }

import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ExecutePlanPage extends StatefulWidget {
  const ExecutePlanPage({Key? key});

  @override
  State<ExecutePlanPage> createState() => _ExecutePlanPageState();
}

class _ExecutePlanPageState extends State<ExecutePlanPage> {
  late int numberOfWeeksInMonth;
  late String userId;

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
        title: const Text('Execute Plan Page'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),
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

  const WeekPlanPage({
    required this.userId,
    required this.weekNumber,
  });

  @override
  Widget build(BuildContext context) {
    String currentMonthYear = DateFormat('MMMyyyy').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: Text('Week $weekNumber Plan'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('Week$weekNumber,$currentMonthYear')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text('No data available for Week $weekNumber'));
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

  const DayPlanPage({
    required this.userId,
    required this.weekNumber,
    required this.day,
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
            .collection('Week${widget.weekNumber},$currentMonthYear')
            .doc(widget.day)
            .collection('executed')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text('No data available for Day ${widget.day}'));
          }
          bool allExercisesDone = true;

          for (var document in snapshot.data!.docs) {
            var exercise = document.data() as Map<String, dynamic>;
            if (exercise['done'] != 'yes' && exercise['done'] != true) {
              allExercisesDone = false;
              break;
            }
          }

          if (allExercisesDone && !_isGoalAchieved) {
            _isGoalAchieved = true;
            _showCongratulationsDialog(context);

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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditButton(
                                    exerciseData: exercise,
                                    userId: widget.userId,
                                    weekNumber: widget.weekNumber,
                                    currentMonthYear: currentMonthYear,
                                    day: widget.day,
                                    exerciseRef: document.reference,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              exercise['done'] == 'yes'
                                  ? Icons.check_circle
                                  : Icons.check_circle_outline,
                              color: exercise['done'] == 'yes'
                                  ? Colors.green
                                  : null,
                            ),
                            onPressed: () async {
                              // Get a reference to the documents within the executed subcollection
                              QuerySnapshot<Map<String, dynamic>>
                                  querySnapshot = await FirebaseFirestore
                                      .instance
                                      .collection('users')
                                      .doc(widget.userId)
                                      .collection(
                                          'Week${widget.weekNumber},$currentMonthYear')
                                      .doc(widget.day)
                                      .collection('executed')
                                      .get();

                              // Loop through each document in the subcollection
                              for (QueryDocumentSnapshot<
                                      Map<String, dynamic>> documentSnapshot
                                  in querySnapshot.docs) {
                                // Get the document reference
                                DocumentReference<Map<String, dynamic>> docRef =
                                    documentSnapshot.reference;

                                // Fetch the current array of exercises
                                DocumentSnapshot<Map<String, dynamic>>
                                    snapshot = await docRef.get();
                                List<dynamic> exercises =
                                    snapshot.data()!['exercises'];

                                // Find the index of the exercise to be updated
                                int index = exercises.indexWhere((exercis) =>
                                    exercis['exerciseName'] ==
                                    exercise['exerciseName']);

                                // If the exercise is found, replace it with the updated exercise
                                if (index != -1) {
                                  exercises[index]!['done'] == 'yes'
                                      ? exercises[index]!['done'] = 'no'
                                      : exercises[index]!['done'] = 'yes';

                                  await docRef.set({'exercises': exercises},
                                      SetOptions(merge: true));
                                  bool allDone = exercises.every(
                                      (exercise) => exercise['done'] == 'yes');
                                  if (allDone) {
                                    // Show congratulations message if all exercises are done
                                    _showCongratulationsDialog(context);
                                  }
                                  print(
                                      'Exercise data updated successfully for document ${docRef.id}');

                                  // Update the exercises array in Firestore
                                }
                              }
                            },
                          )
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

void _showCongratulationsDialog(BuildContext context) {
  Fluttertoast.showToast(
    msg: "Congratulations! You have achieved your goal for the day",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

class EditButton extends StatefulWidget {
  final String userId;
  final int weekNumber;
  final String currentMonthYear;
  final String day;
  final Map<String, dynamic> exerciseData;
  final DocumentReference<Object?> exerciseRef;

  const EditButton({
    Key? key,
    required this.exerciseData,
    required this.userId,
    required this.weekNumber,
    required this.currentMonthYear,
    required this.day,
    required this.exerciseRef,
  }) : super(key: key);

  @override
  State<EditButton> createState() => _EditButtonState();
}

class _EditButtonState extends State<EditButton> {
  late TextEditingController repsController;
  late TextEditingController setsController;
  late TextEditingController weightController;
  late bool isDone;

  @override
  void initState() {
    super.initState();
    repsController = TextEditingController(
      text: widget.exerciseData['repetitions'] != null
          ? widget.exerciseData['repetitions'].toString()
          : '',
    );
    setsController =
        TextEditingController(text: widget.exerciseData['sets'].toString());
    weightController =
        TextEditingController(text: widget.exerciseData['weight'].toString());
    isDone = widget.exerciseData['done'] == 'yes';
  }

  @override
  void dispose() {
    repsController.dispose();
    setsController.dispose();
    weightController.dispose();
    super.dispose();
  }

  Future<void> _updateExerciseData() async {
    // Extract the exercise data from the widget
    Map<String, dynamic> updatedExercise = {
      'exerciseName': widget.exerciseData['exerciseName'],
      'repetitions': repsController.text,
      'sets': setsController.text,
      'weight': weightController.text,
      'done': isDone ? 'yes' : 'no',
      // 'timestamp' : DateTime.now(),
    };

    // // Add timestamp if exercise is marked as done
    if (isDone) {
      updatedExercise['timestamp'] = DateTime.now();
    }
    print('Is exercise done? $isDone');

    // Get a reference to the documents within the executed subcollection
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await widget.exerciseRef.parent.parent!.collection('executed').get();

    // Loop through each document in the subcollection
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
        in querySnapshot.docs) {
      // Get the document reference
      DocumentReference<Map<String, dynamic>> docRef =
          documentSnapshot.reference;

      // Fetch the current array of exercises
      DocumentSnapshot<Map<String, dynamic>> snapshot = await docRef.get();
      List<dynamic> exercises = snapshot.data()!['exercises'];

      // Find the index of the exercise to be updated
      int index = exercises.indexWhere((exercise) =>
          exercise['exerciseName'] == updatedExercise['exerciseName']);

      // If the exercise is found, replace it with the updated exercise
      if (index != -1) {
        exercises[index] = updatedExercise;

        // Update the exercises array in Firestore
        await docRef.set({'exercises': exercises}, SetOptions(merge: true));
        print('Exercise data updated successfully for document ${docRef.id}');

        // Check if all exercises are marked as done

        bool allDone = exercises.every((exercise) => exercise['done'] == 'yes');
        if (allDone) {
          // Show congratulations message if all exercises are done
          _showCongratulationsDialog(context);

          // if (exercises.every((exercise) => exercise['done'] == 'yes')) {
          //   _showCongratulationsDialog(context);
        }
      }
    }

    // Show snackbar message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exercise data updated successfully!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Exercise'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: repsController,
              decoration: const InputDecoration(labelText: 'Reps'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: setsController,
              decoration: const InputDecoration(labelText: 'Sets'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: weightController,
              decoration: const InputDecoration(labelText: 'Weight (in kg)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _updateExerciseData();
                Navigator.pop(context);
              },
              child: const Text("UPDATE"),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ExecutePlanPage(),
  ));
}
