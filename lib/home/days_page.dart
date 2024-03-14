import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DaysPage extends StatefulWidget {
  final int? selectedWeek;

  const DaysPage({Key? key,this.selectedWeek}) : super(key: key);

  @override
  State<DaysPage> createState() => _DaysPageState();
}

class _DaysPageState extends State<DaysPage> {
  List<int> indexCounterList = List.generate(7, (index) => 0);

  List<List<DayData>> exercisesByDay = [
    [], [], [], [], [], [], [] // Initialize with empty lists for each day
  ];

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
  late int selectedWeek;


  @override
  void initState() {
    super.initState();
    selectedWeek = widget.selectedWeek ?? 1; // Set default week to 1 if not provided
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
        exercises = querySnapshot.docs.map((doc) => doc['exerciseName'] as String).toList();
      });

      print("Exercises: $exercises");
    } catch (e) {
      print('Error fetching exercises: $e');
    }
  }

  Future<void> addExerciseToFirestore(String day, String exerciseName, String repetitions, String sets, int selectedWeek) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DateTime now = DateTime.now();
      String monthYear = "${_getMonthName(now.month)}${now.year}";
      String subCollectionName = 'Week$selectedWeek,$monthYear';

      // Create a reference to the subcollection
      CollectionReference userCollection = FirebaseFirestore.instance.collection('users').doc(userId).collection(subCollectionName);

      // Split selectedCategory to extract the name
      String categoryName = selectedCategory!.split(':')[1].trim();

      // Add exercise data to the document in the subcollection
      await userCollection.doc(day).set({
        'day': day,
        'exercises': FieldValue.arrayUnion([
          {
            'exerciseCategory': categoryName,
            'exerciseName': exerciseName,
            'repetitions': repetitions,
            'sets': sets,
          }
        ])
      }, SetOptions(merge: true)); // Merge with existing data if the document exists
      print(day);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exercise saved successfully')),
      );
    } catch (e) {
      print('Error saving exercise: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save exercise')),
      );
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
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
          // Initialize indexCounter for each day
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  daysData[index].name,
                  semanticsLabel: 'Selected Week: $selectedWeek',
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
                                        setState(() {
                                          if (selectedExercise != null) {
                                            DayData newExercise = DayData(
                                              name: daysData[index].name,
                                              exerciseName: selectedExercise,
                                              repetitions: repetitions,
                                              sets: sets,
                                            );
                                            exercisesByDay[index].add(newExercise);
                                            // Use indexCounterList for S.No.
                                            indexCounterList[index]++;

                                            // Add exercise to Firestore
                                            addExerciseToFirestore(
                                              daysData[index].name,
                                              selectedExercise!,
                                              repetitions!,
                                              sets!,
                                              selectedWeek!,
                                            );
                                          }
                                        });
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
                      DataColumn(label: Text('Action')),
                    ],
                    rows: [
                      for (var i = 0; i < exercisesByDay[index].length; i++)
                        DataRow(
                          cells: [
                            DataCell(Text(indexCounterList[index].toString())),
                            DataCell(Text(exercisesByDay[index][i].exerciseName!)),
                            DataCell(Text(exercisesByDay[index][i].repetitions ?? '')),
                            DataCell(Text(exercisesByDay[index][i].sets ?? '')),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    exercisesByDay[index].removeAt(i);
                                    for (int j = i; j < exercisesByDay[index]
                                        .length; j++);
                                  });
                                },
                              ),
                            ),
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
