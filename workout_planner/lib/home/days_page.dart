import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DaysPage extends StatefulWidget {
  const DaysPage({Key? key}) : super(key: key);

  @override
  State<DaysPage> createState() => _DaysPageState();
}

class _DaysPageState extends State<DaysPage> {
  String? selectedCategory;
  String? selectedExercise;
  List<String> categories = [];
  List<String> exercises = [];
  bool categorySelected= false;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }
  void fetchCategories() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('categories').get();
      setState(() {
        categories = querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  void fetchExercises(String selectedCategory) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .doc(selectedCategory)
          .collection('exercises')
          .get();
      print(categories);
      

      List<String> fetchedExercises = [];
      querySnapshot.docs.forEach((doc) {
        String exerciseName = doc['name'];
        print(doc['exerciseName']);
        fetchedExercises.add(exerciseName);
      });
      setState(() {
        exercises = fetchedExercises;
        categorySelected = true;
      });
      print('Fetched exercises: $exercises');
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
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButton<String>(
                            value: selectedCategory,
                            hint: Text('Select Category'),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCategory = newValue;
                                print('Selected Category: $selectedCategory'); // Add this line
                                fetchExercises(newValue!);
                              });
                            },
                            items: categories.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                          ),

                          SizedBox(height: 20),
                          DropdownButton<String>(
                            value: selectedExercise,
                            hint: Text('Select Exercise'),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedExercise = newValue;
                                fetchExercises(newValue!);

                              });
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
                    );
                  },
                );
              },
            );
          },
          child: Text('Open Popup'),

        ),
      ),
    );
  }
}













// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:workout_plWidget {
// const DaysPage({Key? key}) : super(key: key);
//
// @override
// State<DaysPage> createState() => _DaysPageState();
// }
//
// class _DaysPageState extends State<DaysPage> {
// CategoryModel? categoryModel;
// List<String> exercises = [];
// List<CategoryModel> categoryModelList = [];
// QuerySnapshot? exercisesSnapshot;lanner/models/category_model.dart';
//
// class DaysPage extends Statefu
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCategories();
//   }
//
//   void fetchCategories() async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('categories')
//           .get();
//
//       List<String> fetchedCategories = [];
//
//       querySnapshot.docs.forEach((doc) async {
//         categoryModelList.add(CategoryModel.toObject(doc.data()));
//       });
//
//       setState(() {});
//
//       print('Fetched Categories: ${categoryModelList.toString()}');
//       print('Fetched Exercises: $exercises');
//     } catch (e) {
//       print('Error fetching categories: $e');
//     }
//   }
//
//   void fetchExercises() async {
//     try {
//       if (categoryModel != null) {
//         final snapshot = await FirebaseFirestore.instance
//             .collection("exercises")
//             .where("categoryId", isEqualTo: categoryModel!.categoryId)
//             .get();
//
//         List<String> fetchedExercises = [];
//
//         snapshot.docs.forEach((doc) {
//           fetchedExercises.add(doc['name']);
//         });
//
//         setState(() {
//           exercises = fetchedExercises;
//         });
//       } else {
//         print('No category selected.');
//       }
//     } catch (e) {
//       print("Error Fetching Exercises: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: Text('Create Plan Page'),
//         backgroundColor: Colors.black,
//         centerTitle: true,
//         titleTextStyle: const TextStyle(
//           color: Colors.white,
//           fontSize: 20,
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             buildDayButton("Day 1\nMonday", Colors.pinkAccent),
//             buildDayButton("Day 2\nTuesday", Colors.pinkAccent),
//             buildDayButton("Day 3\nWednesday", Colors.pinkAccent),
//             buildDayButton("Day 4\nThursday", Colors.pinkAccent),
//             buildDayButton("Day 5\nFriday", Colors.pinkAccent),
//             buildDayButton("Day 6\nSaturday", Colors.pinkAccent),
//             buildDayButton("Day 7\nSunday", Colors.pinkAccent),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildDayButton(String title, Color backgroundColour) {
//     return Padding(
//       padding: const EdgeInsets.all(8),
//       child: ElevatedButton(
//         onPressed: () {
//           showModalBottomSheet(
//             context: context,
//             builder: (BuildContext context) {
//               categoryModel = categoryModel ?? categoryModelList[0];
//               String selectedExercises =
//               exercises.isNotEmpty ? exercises[0] : '';
//               String repetitions = '';
//               String sets = '';
//
//               return StatefulBuilder(
//                 builder: (BuildContext context, StateSetter setState) {
//                   return SingleChildScrollView(
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           DropdownButton<CategoryModel>(
//                             value: categoryModel,
//                             onChanged: (CategoryModel? model) {
//                               categoryModel = model;
//                               fetchExercises();
//                               setState(() {
//                                 print('${categoryModel}');
//                               });
//                             },
//                             items: categoryModelList
//                                 .map<DropdownMenuItem<CategoryModel>>(
//                                     (CategoryModel model) {
//                                   return DropdownMenuItem<CategoryModel>(
//                                     value: model,
//                                     child: Text(model.name ?? "Not Available"),
//                                   );
//                                 }).toList(),
//                           ),
//                           DropdownButton<String>(
//                             value: selectedExercises,
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 selectedExercises = newValue!;
//                               });
//                             },
//                             items: exercises.map<DropdownMenuItem<String>>(
//                                     (String value) {
//                                   return DropdownMenuItem<String>(
//                                     value: value,
//                                     child: Text(value),
//                                   );
//                                 }).toList(),
//                           ),
//                           const SizedBox(height: 30),
//                           TextField(
//                             onChanged: (value) {
//                               repetitions = value;
//                             },
//                             decoration: const InputDecoration(
//                               labelText: 'Repetitions',
//                               border: OutlineInputBorder(),
//                             ),
//                             keyboardType: TextInputType.number,
//                           ),
//                           const SizedBox(height: 16),
//                           TextField(
//                             onChanged: (value) {
//                               sets = value;
//                             },
//                             decoration: const InputDecoration(
//                               labelText: 'Sets',
//                               border: OutlineInputBorder(),
//                             ),
//                             keyboardType: TextInputType.number,
//                           ),
//                           SizedBox(height: 16),
//                           Align(
//                             alignment: Alignment.center,
//                             child: TextButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                               child: Text('Save'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: backgroundColour,
//           padding: EdgeInsets.symmetric(vertical: 20),
//         ),
//         child: Text(
//           title,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
//
//
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:workout_planner/models/category_model.dart';
// // //
// // class DaysPage extends StatefulWidget {
// //   const DaysPage({Key? key}) : super(key: key);
// //
// //   @override
// //   State<DaysPage> createState() => _DaysPageState();
// // }
// //
// // class _DaysPageState extends State<DaysPage> {
// //   // List<String> categories = [
// //   //   'Category 1',
// //   //   'Category 2',
// //   CategoryModel? categoryModel;
// //   //   'Category 3',
// //   //   'Category 4',
// //   // ];
// //   // List<String> categories = [];
// //   // String? selectedCategoryId; // Declare selectedCategoryId here
// //   List<String> exercises = [];
// //   List<CategoryModel> categoryModelList = [];
// //   QuerySnapshot? exercisesSnapshot;
// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchCategories();
// //   }
// //
// //   void fetchCategories() async {
// //     try {
// //       // Get the documents from the 'categories' collection
// //       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
// //           .collection('categories').get();
// //
// //       List<String> fetchedCategories = [];
// //       List<List<String>> fetchedExercises = [];
// //
// //       // Iterate through the documents in the query snapshot
// //       querySnapshot.docs.forEach((doc) async {
// //         categoryModelList.add(CategoryModel.toObject(doc.data()));
// //       });
// //
// // setState(() {
// //
// // });
// //       print('Fetched Categories: ${categoryModelList.toString()}');
// //       print('Fetched Exercises: $exercises');
// //
// //     } catch (e) {
// //       print('Error fetching categories: $e');
// //     }
// //   }
// //
// //   void fetchExercises() async {
// //     try {
// //       // Ensure a category has been selected
// //       if (categoryModel != null) {
// //         // Get the documents from the 'exercises' collection where 'category Id' matches the selected category's ID
// //         final snapshot = await FirebaseFirestore.instance
// //             .collection("exercises")
// //             .where("categoryId", isEqualTo: categoryModel!.categoryId)
// //             .get();
// //
// //         List<String> fetchedExercises = [];
// //
// //         // Iterate through the documents in the exercises snapshot
// //         snapshot.docs.forEach((doc) {
// //           fetchedExercises.add(doc['name']);
// //         });
// //
// //         setState(() {
// //           exercises = fetchedExercises;
// //         });
// //       } else {
// //         print('No category selected.');
// //       }
// //     } catch (e) {
// //       print("Error Fetching Exercises: $e");
// //     }
// //   }
// //
// //
// //
