import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class DaysPage extends StatefulWidget {
  final int? selectedWeek;

  const DaysPage({Key? key, this.selectedWeek}) : super(key: key);

  @override
  State<DaysPage> createState() => _DaysPageState();
}

class _DaysPageState extends State<DaysPage> {
  final _weekNameController = TextEditingController();

  List<int> indexCounterList = List.generate(7, (index) => 0);
  String _weekName = '';

  List<List<DayData>> exercisesByDay = [[], [], [], [], [], [], []];

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
  String? weight;

  List<String> categories = [];
  List<String> exercises = [];
  late StateSetter localState;
  late int selectedWeek;

  @override
  void initState() {
    super.initState();
    selectedWeek = widget.selectedWeek ?? 1;
    fetchCategories();
    daysData.forEach((day) {
      fetchExercisesForDay(day.name);
    });
  }

  @override
  void dispose() {
    _weekNameController.dispose();
    super.dispose();
  }

  void _saveWeekNameToDatabase() {
    print('Week name saved: $_weekName');
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
      print(fetchedCategories);
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

  Future<bool> checkExerciseExists(String day, String exerciseName) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DateTime now = DateTime.now();
      String monthYear = "${_getMonthName(now.month)}${now.year}";
      String subCollectionName = 'Week$selectedWeek,$monthYear';

      CollectionReference userCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection(subCollectionName);

      DocumentSnapshot dayDocument = await userCollection.doc(day).get();

      if (dayDocument.exists) {
        List<dynamic> exercisesData = dayDocument['exercises'];

        // Check if any exercise in the day document has the same name
        return exercisesData
            .any((exercise) => exercise['exerciseName'] == exerciseName);
      }
    } catch (e) {
      print('Error checking exercise existence: $e');
    }

    // Return false if there was an error or the exercise does not exist
    return false;
  }

  Future<void> addExerciseToFirestore(
    String day,
    String exerciseName,
    String? repetitions,
    String? sets,
    String? weight,
    int selectedWeek,
    String weekName,
    int index,
  ) async {
    try {
      // Check if the exercise already exists in the database
      bool exerciseExists = await checkExerciseExists(day, exerciseName);

      if (exerciseExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exercise already exists')),

        );
        return;
      } else {
        String userId = FirebaseAuth.instance.currentUser!.uid;
        DateTime now = DateTime.now();
        String monthYear = "${_getMonthName(now.month)}${now.year}";
        String subCollectionName = 'Week$selectedWeek,$monthYear';
        print("check");

        int? parsedRepetitions =
            repetitions != null ? int.tryParse(repetitions) : null;
        int? parsedSets = sets != null ? int.tryParse(sets) : null;
        int? parsedWeight = weight != null ? int.tryParse(weight) : null;

        CollectionReference userCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection(subCollectionName);

        DocumentReference dayDocumentRef =
            userCollection.doc(day); // Define dayDocumentRef here
        print("selectedCategory:$selectedCategory");
        if (selectedCategory == 'yRBuIewVxfNASgu9gjPU') {
          QuerySnapshot categorySnapshot = await FirebaseFirestore.instance
              .collection('categories')
              .where("name", isEqualTo: "Others")
              .get();

          Map<String, dynamic> exerciseMap = {
            'exerciseName': exerciseName,
            'repetitions': parsedRepetitions,
            'sets': parsedSets,
            'weight': parsedWeight,
          };

          await userCollection.doc(day).set({
            'weekName': weekName,
            'day': day,
            'exercises': FieldValue.arrayUnion([exerciseMap])
          }, SetOptions(merge: true));

          await dayDocumentRef
              .collection('executed')
              .doc('vOsm85bUJHKUm3Xe0dYV')
              .set({
            'exercises': FieldValue.arrayUnion([
              {
                ...exerciseMap, // Spread the existing exercise map
                'done': 'no', // Add the 'done' field
              }
            ]),
          }, SetOptions(merge: true));

          if (categorySnapshot.docs.isNotEmpty) {
            DocumentSnapshot categoryDocument = categorySnapshot.docs.first;
            CollectionReference exercisesCollection = FirebaseFirestore.instance
                .collection('categories')
                .doc(categoryDocument.id)
                .collection('exercises');
            await exercisesCollection.add({
              'exerciseName': exerciseName,
              'categoryId': selectedCategory,
            });
            print("hello");
          } else {
            print('Other category not found in Firestore');
            return;
          }
        } else {
          // Define the exercise map without the 'done' field
          Map<String, dynamic> exerciseMap = {
            'exerciseName': exerciseName,
            'repetitions': parsedRepetitions,
            'sets': parsedSets,
            'weight': parsedWeight,
          };

          // Add the exercise map to the 'exercises' array in the day document
          await userCollection.doc(day).set({
            'weekName': weekName,
            'day': day,
            'exercises': FieldValue.arrayUnion([exerciseMap])
          }, SetOptions(merge: true));

          // Add the exercise map to the 'exercises' array in the executed subcollection
          await dayDocumentRef
              .collection('executed')
              .doc('vOsm85bUJHKUm3Xe0dYV')
              .set({
            'exercises': FieldValue.arrayUnion([
              {
                ...exerciseMap, // Spread the existing exercise map
                'done': 'no', // Add the 'done' field
              }
            ]),
          }, SetOptions(merge: true));
        }

        // Update local state only if the exercise is successfully added to the database
        setState(() {
          DayData newExercise = DayData(
            name: day,
            exerciseName: exerciseName,
            repetitions: repetitions,
            sets: sets,
            weight: weight != null ? int.tryParse(weight) : null,
          );
          // if (exercisesByDay[index].isEmpty) {
          //   exercisesByDay[index] = [];
          // }
          exercisesByDay[index].add(newExercise);
          indexCounterList[index]++;
        }
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exercise saved successfully')),
        );
      }
    } catch (e) {
      print('Error saving exercise: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save exercise ')),
      );
    }
  }

  Future<void> deleteExerciseFromFirestore(
      String day, String exerciseName) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DateTime now = DateTime.now();
      String monthYear = "${_getMonthName(now.month)}${now.year}";
      String subCollectionName = 'Week$selectedWeek,$monthYear';

      CollectionReference userCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection(subCollectionName);

      DocumentReference dayDocumentRef = userCollection.doc(day);

      DocumentSnapshot dayDocument = await dayDocumentRef.get();

      if (dayDocument.exists) {
        // Remove the exercise from the exercises array in the day document
        List<dynamic> exercisesData = List.from(dayDocument['exercises']);
        exercisesData.removeWhere(
            (exercise) => exercise['exerciseName'] == exerciseName);
        await dayDocumentRef.update({
          'exercises': exercisesData,
        });

        // Remove the exercise from the executed subcollection
        QuerySnapshot executedSnapshot =
            await dayDocumentRef.collection('executed').get();
        executedSnapshot.docs.forEach((doc) async {
          List<dynamic> executedExercisesData = List.from(doc['exercises']);
          executedExercisesData.removeWhere(
              (exercise) => exercise['exerciseName'] == exerciseName);
          await doc.reference.update({
            'exercises': executedExercisesData,
          });
        });

        print('Exercise deleted successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exercise deleted successfully'),
          ),
        );
      } else {
        print('Document for $day does not exist');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Document For the $day Does not exeist'),
          ),
        );
      }
    } catch (e) {
      print('Error deleting exercise: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting exercise: $e'),
        ),
      );
    }
  }

  Future<void> fetchExercisesForDay(String day) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DateTime now = DateTime.now();
      String monthYear = "${_getMonthName(now.month)}${now.year}";
      String subCollectionName = 'Week$selectedWeek,$monthYear';

      CollectionReference userCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection(subCollectionName);

      DocumentSnapshot dayDocument = await userCollection.doc(day).get();

      if (dayDocument.exists) {
        List<dynamic> exercisesData = dayDocument['exercises'];

        List<DayData> exercisesList = exercisesData.map((exercise) {
          return DayData(
            name: day,
            exerciseName: exercise['exerciseName'],
            repetitions: exercise['repetitions']?.toString(),
            sets: exercise['sets']?.toString(),
            weight: exercise['weight'] as int?,
            // weight: exercise['weight'] != null ? exercise['weight'].toString() : null,
          );
        }).toList();

        setState(() {
          exercisesByDay[daysData
              .indexWhere((element) => element.name == day)] = exercisesList;
        });
      }
    } catch (e) {
      print('Error fetching exercises for $day: $e');
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
        title: Text(
          'Select Category and Exercise',
          style: GoogleFonts.montserrat(
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _weekNameController,
                  decoration: const InputDecoration(hintText: "Name Your Week"),
                  onChanged: (value) {
                    setState(() {
                      _weekName = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _saveWeekNameToDatabase();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: daysData.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        daysData[index].name,
                        semanticsLabel: 'Selected Week: $selectedWeek',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter localState) {
                                  this.localState = localState;
                                  return SingleChildScrollView(
                                    padding: EdgeInsets.only(bottom: 
                                    MediaQuery.of(context).viewInsets.bottom),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(height: 20),
                                          Row(
                                            children: [
                                              const SizedBox(width: 10),
                                              DropdownButton<String>(
                                                value: selectedCategory,
                                                hint: const Text(
                                                    'Select Category'),
                                                onChanged: (String? newValue) {
                                                  if (newValue != null) {
                                                    localState(() {
                                                      selectedCategory =
                                                          newValue;
                                                      selectedExercise = null;
                                                      if (selectedCategory !=
                                                          "yRBuIewVxfNASgu9gjPU") {
                                                        fetchExercises(
                                                            selectedCategory);
                                                      }
                                                    });
                                                    print(selectedCategory);
                                                  }
                                                },
                                                items: categories
                                                    .map((String category) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value:
                                                        category.split(":")[0],
                                                    child: Text(
                                                        category.split(":")[1]),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          // Conditionally show text field for "Other" option
                                          if (selectedCategory ==
                                              'yRBuIewVxfNASgu9gjPU')
                                            TextField(
                                              decoration: const InputDecoration(
                                                labelText: 'Enter Exercise '
                                                    'Name',
                                                border: OutlineInputBorder(),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedExercise = value;
                                                });
                                              },
                                            )
                                          else
                                            Row(
                                              children: [
                                                const SizedBox(width: 10),
                                                DropdownButton<String>(
                                                  value: selectedExercise,
                                                  hint: const Text(
                                                      'Select Exercise'),
                                                  onChanged:
                                                      (String? newValue) {
                                                    if (newValue != null) {
                                                      localState(() {
                                                        selectedExercise =
                                                            newValue;
                                                      });
                                                    }
                                                  },
                                                  items: exercises
                                                      .map((String exercise) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: exercise,
                                                      child: Text(exercise),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),

                                          const SizedBox(height: 20),
                                          TextField(
                                            decoration: const InputDecoration(
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
                                          const SizedBox(height: 20),
                                          TextField(
                                            decoration: const InputDecoration(
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
                                          const SizedBox(height: 20),
                                          TextField(
                                            decoration: const InputDecoration(
                                              labelText: 'Weight (kg)',
                                              border: OutlineInputBorder(),
                                            ),
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              setState(() {
                                                weight = value;
                                              });
                                            },
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(1.0),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Colors.purple,
                                                  Colors.deepPurple,
                                                  Colors.purple,
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ),
                                            ),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (selectedExercise !=
                                                      null) {
                                                    addExerciseToFirestore(
                                                      daysData[index].name,
                                                      selectedExercise!,
                                                      repetitions,
                                                      sets,
                                                      weight,
                                                      selectedWeek,
                                                      _weekName,
                                                      index,
                                                    );

                                                    DayData newExercise =
                                                        DayData(
                                                      name:
                                                          daysData[index].name,
                                                      exerciseName:
                                                          selectedExercise,
                                                      repetitions: repetitions,
                                                      sets: sets,
                                                      weight: weight != null
                                                          ? int.tryParse(
                                                              weight!)
                                                          : null,
                                                    );
                                                    // if (exercisesByDay[index]
                                                    //     .isEmpty) {
                                                    //   exercisesByDay[index] =
                                                    //       [];
                                                    // }
                                                    // exercisesByDay[index]
                                                    //     .add(newExercise);
                                                    // indexCounterList[index]++;
                                                  }
                                                });
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.transparent,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                              child: const Text('Save'),
                                            ),
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
                        child: const Text('Add Exercise'),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 60,
                          columns: [
                            const DataColumn(label: Text('S.No')),
                            const DataColumn(label: Text('Exercise')),
                            const DataColumn(label: Text('Reps')),
                            const DataColumn(label: Text('Sets')),
                            const DataColumn(label: Text('Weight(in kg)')),
                            const DataColumn(label: Text('Action')),
                          ],
                          rows: [
                            for (var i = 0;
                                i < exercisesByDay[index].length;
                                i++)
                              DataRow(
                                cells: [
                                  DataCell(Text((i + 1).toString())),
                                  DataCell(Text(
                                      exercisesByDay[index][i].exerciseName!)),
                                  DataCell(Text(
                                      exercisesByDay[index][i].repetitions ??
                                          '')),
                                  DataCell(Text(
                                      exercisesByDay[index][i].sets ?? '')),
                                  DataCell(Text(
                                      exercisesByDay[index][i].weight != null
                                          ? exercisesByDay[index][i]
                                              .weight
                                              .toString()
                                          : '')),
                                  DataCell(
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        if (exercisesByDay[index].isNotEmpty) {
                                          await deleteExerciseFromFirestore(
                                              daysData[index].name,
                                              exercisesByDay[index][i]
                                                  .exerciseName!);
                                          setState(() {
                                            exercisesByDay[index].removeAt(i);
                                          });
                                        }
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
          )
        ],
      ),
    );
  }
}

class DayData {
  final String name;
  String? exerciseName;
  String? repetitions;
  String? sets;
  int? weight;

  DayData({
    required this.name,
    this.exerciseName,
    this.repetitions,
    this.sets,
    this.weight,
  });
}
