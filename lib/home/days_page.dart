// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class DaysPage extends StatefulWidget {
//   const DaysPage({Key? key}) : super(key: key);
//
//   @override
//   State<DaysPage> createState() => _DaysPageState();
// }
//
// class _DaysPageState extends State<DaysPage> {
//   String? selectedCategory;
//   String? selectedExercise;
//   String? repetitions;
//   String? sets;
//   List<String> categories = [];
//   List<String> exercises = [];
//   late StateSetter localState;
//   List<ExerciseData> exerciseDataList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCategories();
//   }
//
//   Future<void> fetchCategories() async {
//     try {
//       QuerySnapshot querySnapshot =
//       await FirebaseFirestore.instance.collection('categories').get();
//       List<String> fetchedCategories = [];
//
//       querySnapshot.docs.forEach((doc) {
//         String name = doc['name'] as String;
//         String categoryId = doc.id;
//         fetchedCategories.add('$categoryId: $name');
//       });
//
//       setState(() {
//         categories = fetchedCategories;
//       });
//     } catch (e) {
//       print('Error fetching categories: $e');
//     }
//   }
//
//   Future<void> fetchExercises(String? selectedCategory) async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('categories')
//           .doc(selectedCategory)
//           .collection('exercises')
//           .get();
//
//       localState(() {
//         exercises = querySnapshot.docs
//             .map((doc) => doc['exerciseName'] as String)
//             .toList();
//       });
//
//       print("Exercises: $exercises");
//     } catch (e) {
//       print('Error fetching exercises: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select Category and Exercise'),
//       ),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 100, // Adjust the height as needed
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: 7, // Assuming 7 days in a week
//               itemBuilder: (BuildContext context, int index) {
//                 return Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 8.0),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       showModalBottomSheet(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return SingleChildScrollView(
//                             child: StatefulBuilder(
//                               builder: (BuildContext context, StateSetter localState) {
//                                 this.localState = localState;
//                                 return Container(
//                                   padding: EdgeInsets.all(16),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       SizedBox(height: 20),
//                                       Row(
//                                         children: [
//                                           SizedBox(width: 10),
//                                           DropdownButton<String>(
//                                             value: selectedCategory,
//                                             hint: Text('Select Category'),
//                                             onChanged: (String? newValue) {
//                                               if (newValue != null) {
//                                                 localState(() {
//                                                   selectedCategory = newValue.split(":")[0];
//                                                   selectedExercise = null;
//                                                   print('${selectedCategory} $selectedExercise');
//                                                   fetchExercises(selectedCategory);
//                                                 });
//                                               }
//                                             },
//                                             items: categories.map((String category) {
//                                               return DropdownMenuItem<String>(
//                                                 value: category.split(":")[0],
//                                                 child: Text(category.split(":")[1]),
//                                               );
//                                             }).toList(),
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(height: 20),
//                                       Row(
//                                         children: [
//                                           SizedBox(width: 10),
//                                           DropdownButton<String>(
//                                             value: selectedExercise,
//                                             hint: Text('Select Exercise'),
//                                             onChanged: (String? newValue) {
//                                               if (newValue != null) {
//                                                 localState(() {
//                                                   selectedExercise = newValue;
//                                                 });
//                                               }
//                                             },
//                                             items: exercises.map((String exercise) {
//                                               return DropdownMenuItem<String>(
//                                                 value: exercise,
//                                                 child: Text(exercise),
//                                               );
//                                             }).toList(),
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(height: 20),
//                                       Row(
//                                         children: [
//                                           SizedBox(width: 10),
//                                           Expanded(
//                                             child: TextField(
//                                               decoration: InputDecoration(
//                                                 labelText: 'Repetitions',
//                                                 border: OutlineInputBorder(),
//                                               ),
//                                               keyboardType: TextInputType.number,
//                                               onChanged: (value) {
//                                                 setState(() {
//                                                   repetitions = value;
//                                                 });
//                                               },
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(height: 10),
//                                       Row(
//                                         children: [
//                                           SizedBox(width: 10),
//                                           Expanded(
//                                             child: TextField(
//                                               decoration: InputDecoration(
//                                                 labelText: 'Sets',
//                                                 border: OutlineInputBorder(),
//                                               ),
//                                               onChanged: (value) {
//                                                 setState(() {
//                                                   sets = value;
//                                                 });
//                                               },
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(height: 20),
//                                       ElevatedButton(
//                                         onPressed: () {
//                                           // Save button action
//                                           // You can perform the save operation here
//                                           if (selectedCategory != null &&
//                                               selectedExercise != null &&
//                                               repetitions != null &&
//                                               sets != null) {
//                                             exerciseDataList.add(ExerciseData(
//                                               category: selectedCategory!,
//                                               exercise: selectedExercise!,
//                                               repetitions: repetitions!,
//                                               sets: sets!,
//                                             ));
//                                           }
//                                         },
//                                         child: Text('Save'),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                           );
//                         },
//                       );
//                     },
//                     child: Text('Day ${index + 1}'),
//                   ),
//                 );
//               },
//             ),
//           ),
//           SizedBox(height: 20),
//           Expanded(
//             child: DataTable(
//               columns: [
//                 DataColumn(label: Text('S.No')),
//                 DataColumn(label: Text('Name')),
//                 DataColumn(label: Text('Sets')),
//                 DataColumn(label: Text('Reps')),
//                 DataColumn(label: Text('Action')),
//               ],
//               rows: List.generate(
//                 exerciseDataList.length,
//                     (index) => DataRow(
//                   cells: [
//                     DataCell(Text((index + 1).toString())),
//                     DataCell(Text(exerciseDataList[index].exercise)),
//                     DataCell(Text(exerciseDataList[index].sets)),
//                     DataCell(Text(exerciseDataList[index].repetitions)),
//                     DataCell(
//                       ElevatedButton(
//                         onPressed: () {
//                           // Delete button action
//                           // You can perform the delete operation here
//                           setState(() {
//                             exerciseDataList.removeAt(index);
//                           });
//                         },
//                         child: Text('Delete'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ExerciseData {
//   final String category;
//   final String exercise;
//   final String repetitions;
//   final String sets;
//
//   ExerciseData({
//     required this.category,
//     required this.exercise,
//     required this.repetitions,
//     required this.sets,
//   });
// }


//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class DaysPage extends StatefulWidget {
//   const DaysPage({Key? key}) : super(key: key);
//
//   @override
//   State<DaysPage> createState() => _DaysPageState();
// }
//
// class _DaysPageState extends State<DaysPage> {
//   List<DayData> daysData = [
//     DayData(name: 'Monday'),
//     DayData(name: 'Tuesday'),
//     DayData(name: 'Wednesday'),
//     DayData(name: 'Thursday'),
//     DayData(name: 'Friday'),
//     DayData(name: 'Saturday'),
//     DayData(name: 'Sunday'),
//   ];
//
//   String? selectedCategory;
//   String? selectedExercise;
//   String? repetitions;
//   String? sets;
//   List<String> categories = [];
//   List<String> exercises = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCategories();
//   }
//
//   Future<void> fetchCategories() async {
//     try {
//       QuerySnapshot querySnapshot =
//       await FirebaseFirestore.instance.collection('categories').get();
//       List<String> fetchedCategories = [];
//
//       querySnapshot.docs.forEach((doc) {
//         String name = doc['name'] as String;
//         String categoryId = doc.id;
//         fetchedCategories.add('$categoryId: $name');
//       });
//
//       setState(() {
//         categories = fetchedCategories;
//       });
//     } catch (e) {
//       print('Error fetching categories: $e');
//     }
//   }
//
//   Future<void> fetchExercises(String? selectedCategory) async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('categories')
//           .doc(selectedCategory)
//           .collection('exercises')
//           .get();
//
//       setState(() {
//         exercises = querySnapshot.docs
//             .map((doc) => doc['exerciseName'] as String)
//             .toList();
//       });
//
//       print("Exercises: $exercises");
//     } catch (e) {
//       print('Error fetching exercises: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select Category and Exercise'),
//       ),
//       body: ListView.builder(
//         itemCount: daysData.length,
//         itemBuilder: (BuildContext context, int index) {
//           return Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Text(
//                   daysData[index].name,
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     showModalBottomSheet(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return StatefulBuilder(
//                           builder: (BuildContext context, StateSetter localState) {
//                             return SingleChildScrollView(
//                               child: Container(
//                                 padding: EdgeInsets.all(16),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     SizedBox(height: 20),
//                                     Row(
//                                       children: [
//                                         SizedBox(width: 10),
//                                         DropdownButton<String>(
//                                           value: selectedCategory,
//                                           hint: Text('Select Category'),
//                                           onChanged: (String? newValue) {
//                                             if (newValue != null) {
//                                               setState(() {
//                                                 selectedCategory = newValue;
//                                                 selectedExercise = null;
//                                                 fetchExercises(selectedCategory);
//                                               });
//                                             }
//                                           },
//                                           items: categories.map((String category) {
//                                             return DropdownMenuItem<String>(
//                                               value: category.split(":")[0],
//                                               child: Text(category.split(":")[1]),
//                                             );
//                                           }).toList(),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: 20),
//                                     Row(
//                                       children: [
//                                         SizedBox(width: 10),
//                                         DropdownButton<String>(
//                                           value: selectedExercise,
//                                           hint: Text('Select Exercise'),
//                                           onChanged: (String? newValue) {
//                                             if (newValue != null) {
//                                               setState(() {
//                                                 selectedExercise = newValue;
//                                               });
//                                             }
//                                           },
//                                           items: exercises.map((String exercise) {
//                                             return DropdownMenuItem<String>(
//                                               value: exercise,
//                                               child: Text(exercise),
//                                             );
//                                           }).toList(),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: 20),
//                                     TextField(
//                                       decoration: InputDecoration(
//                                         labelText: 'Repetitions',
//                                         border: OutlineInputBorder(),
//                                       ),
//                                       keyboardType: TextInputType.number,
//                                       onChanged: (value) {
//                                         setState(() {
//                                           repetitions = value;
//                                         });
//                                       },
//                                     ),
//                                     SizedBox(height: 20),
//                                     TextField(
//                                       decoration: InputDecoration(
//                                         labelText: 'Sets',
//                                         border: OutlineInputBorder(),
//                                       ),
//                                       keyboardType: TextInputType.number,
//                                       onChanged: (value) {
//                                         setState(() {
//                                           sets = value;
//                                         });
//                                       },
//                                     ),
//                                     SizedBox(height: 20),
//                                     ElevatedButton(
//                                       onPressed: () {
//                                         daysData[index].exerciseName = selectedExercise;
//                                         daysData[index].repetitions = repetitions;
//                                         daysData[index].sets = sets;
//                                         setState(() {});
//                                         Navigator.pop(context);
//                                       },
//                                       child: Text('Save'),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     );
//                   },
//                   child: Text('Add Exercise'),
//                 ),
//                 SizedBox(height: 10),
//                 DataTable(
//                   columns: [
//                     DataColumn(label: Text('S.No')),
//                     DataColumn(label: Text('Exercise Name')),
//                     DataColumn(label: Text('Repetitions')),
//                     DataColumn(label: Text('Sets')),
//                   ],
//                   rows: [
//                     DataRow(
//                       cells: [
//                         DataCell(Text('1')),
//                         DataCell(Text(daysData[index].exerciseName ?? '')),
//                         DataCell(Text(daysData[index].repetitions ?? '')),
//                         DataCell(Text(daysData[index].sets ?? '')),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class DayData {
//   final String name;
//   String? exerciseName;
//   String? repetitions;
//   String? sets;
//
//   DayData({
//     required this.name,
//     this.exerciseName,
//     this.repetitions,
//     this.sets,
//   });
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DaysPage extends StatefulWidget {
  const DaysPage({Key? key}) : super(key: key);

  @override
  State<DaysPage> createState() => _DaysPageState();
}

class _DaysPageState extends State<DaysPage> {
  List<DayData> daysData = [
    DayData(name: 'Monday'),
    DayData(name: 'Tuesday'),
    DayData(name: 'Wednesday'),
    DayData(name: 'Thursday'),
    DayData(name: 'Friday'),
    DayData(name: 'Saturday'),
    DayData(name: 'Sunday'),
  ];

  String? selectedCategory;
  String? selectedExercise;
  String? repetitions;
  String? sets;
  List<String> categories = [];
  List<String> exercises = [];
  late StateSetter localState;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('categories').get();
      List<String> fetchedCategories = [];

      querySnapshot.docs.forEach((doc) {
        String name = doc['name'] as String;
        String categoryId = doc.id;
        fetchedCategories.add('$categoryId: $name');
      });

      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> fetchExercises(String? selectedCategory) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .doc(selectedCategory)
          .collection('exercises')
          .get();

      localState(() {
        exercises = querySnapshot.docs
            .map((doc) => doc['exerciseName'] as String)
            .toList();
      });

      print("Exercises: $exercises");
    } catch (e) {
      print('Error fetching exercises: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Category and Exercise'),
      ),
      body: ListView.builder(
        itemCount: daysData.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  daysData[index].name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder: (BuildContext context, StateSetter localState) {
                            this.localState = localState;
                            return SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        SizedBox(width: 10),
                                        DropdownButton<String>(
                                          value: selectedCategory,
                                          hint: Text('Select Category'),
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              localState(() {
                                                selectedCategory = newValue;
                                                selectedExercise = null;
                                                fetchExercises(selectedCategory);
                                              });
                                              print(selectedCategory);

                                            }
                                          },

                                          items: categories.map((String category) {
                                            return DropdownMenuItem<String>(
                                              value: category.split(":")[0],
                                              child: Text(category.split(":")[1]),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        SizedBox(width: 10),
                                        DropdownButton<String>(
                                          value: selectedExercise,
                                          hint: Text('Select Exercise'),
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              localState(() {
                                                selectedExercise = newValue;
                                              });
                                            }
                                          },
                                          items: exercises.map((String exercise) {
                                            return DropdownMenuItem<String>(
                                              value: exercise,
                                              child: Text(exercise),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    TextField(
                                      decoration: InputDecoration(
                                        labelText: 'Repetitions',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {
                                          repetitions = value;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    TextField(
                                      decoration: InputDecoration(
                                        labelText: 'Sets',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {
                                          sets = value;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        daysData[index].exerciseName = selectedExercise;
                                        daysData[index].repetitions = repetitions;
                                        daysData[index].sets = sets;
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                      child: Text('Save'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Text('Add Exercise'),
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 60,
                    columns: [
                      DataColumn(label: Text('S.No')),
                      DataColumn(label: Text('Exercise')),
                      DataColumn(label: Text('Reps')),
                      DataColumn(label: Text('Sets')),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Text('1')),
                          DataCell(Text(daysData[index].exerciseName ?? '')),
                          DataCell(Text(daysData[index].repetitions ?? '')),
                          DataCell(Text(daysData[index].sets ?? '')),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DayData {
  final String name;
  String? exerciseName;
  String? repetitions;
  String? sets;

  DayData({
    required this.name,
    this.exerciseName,
    this.repetitions,
    this.sets,
  });
}
