import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:workout_planner/home/create_plan.dart';

Future<Map<String, int>> getCategoryCounts(String userId) async {
  // Initialize an empty map to store the count of each category
  Map<String, int> categoryCounts = {};

  try {
    // Query all 'executed' collections across all users
    QuerySnapshot<Map<String, dynamic>> executedSnapshots =
        await FirebaseFirestore.instance.collectionGroup('executed').get();

    // Iterate over each 'executed' document
    for (QueryDocumentSnapshot<Map<String, dynamic>> executedDoc
        in executedSnapshots.docs) {
      // Get the data from the 'executed' document
      Map<String, dynamic> executedData = executedDoc.data();

      // Check if the 'exercises' array exists
      if (executedData.containsKey('exercises')) {
        List<dynamic> exercises = executedData['exercises'];

        // Iterate over each exercise in the 'exercises' array
        for (var exercise in exercises) {
          // Check if the exercise is marked as 'done'
          if (exercise['done'] == 'yes') {
            String categoryName = exercise['categoryName'];

            // Increment the count for the category
            categoryCounts.update(categoryName, (value) => value + 1,
                ifAbsent: () => 1);
          }
        }
      }
    }
  } catch (error) {
    // Handle any errors that occur during the process
    print("Error: $error");
    // If an error occurs, return an empty map or handle it according to your application's logic
    return {};
  }

  // Print the category counts
  print(categoryCounts);
  return categoryCounts;
}

// Function to retrieve total sets for all exercises
Future<Map<String, int>> getTotalSetsForAllExercises(String userId) async {
  // Initialize an empty map to store total sets for each exercise
  Map<String, int> totalSetsPerExercise = {};
  print(userId);
  try {
    // Query all 'executed' collections across all users
    QuerySnapshot<Map<String, dynamic>> executedSnapshots =
        await FirebaseFirestore.instance.collectionGroup('executed').get();

    // Iterate over each 'executed' document
    for (QueryDocumentSnapshot<Map<String, dynamic>> executedDoc
        in executedSnapshots.docs) {
      // Get the data from the 'executed' document
      Map<String, dynamic> executedData = executedDoc.data();

      // Check if the 'exercises' array exists
      if (executedData.containsKey('exercises')) {
        List<dynamic> exercises = executedData['exercises'];
        print(exercises);

        // Iterate over each exercise in the 'exercises' array
        for (var exercise in exercises) {
          // Check if the exercise is marked as 'done'
          if (exercise['done'] == 'yes') {
            String exerciseName = exercise['exerciseName'];
            int sets = exercise['sets'];

            // Update the total sets for the exercise across all users and weeks
            totalSetsPerExercise.update(exerciseName, (value) => value + sets,
                ifAbsent: () => sets);
          }
        }
      }
    }
  } catch (error) {
    // Handle any errors that occur during the process
    print("Error: $error");
  }

  // Print the total sets for each exercise
  print("Total sets: $totalSetsPerExercise");

  // Returning the map containing total sets for each exercise
  return totalSetsPerExercise;
}

// Function to check if the user is logging in for the first time
Future<bool> isFirstTimeUser() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userData.exists) {
      final bool hasLoggedInBefore = userData.get('hasLoggedInBefore') ?? false;

      if (!hasLoggedInBefore) {
        print("User has never logged in before");
        // Update the hasLoggedInBefore field to true
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'hasLoggedInBefore': true});
        return true; // User is logging in for the first time
      } else {
        print("User has logged in before");
        return false; // User has logged in before
      }
    } else {
      print("User data does not exist in Firestore");
      // Handle scenario where user data doesn't exist
      return true; // Treat as first-time user
    }
  } else {
    // User is not authenticated
    print("User is not authenticated");
    return false; // Treat as not first-time user
  }
}
//
// class ExercisePieChart extends StatefulWidget {
//   final Map<String, int> categoryCounts;
//
//   const ExercisePieChart({required this.categoryCounts});
//
//   @override
//   State<ExercisePieChart> createState() => _ExercisePieChartState();
// }
//
// class _ExercisePieChartState extends State<ExercisePieChart> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: SizedBox(
//         width: 300,
//         child: AspectRatio(
//           aspectRatio: 1.6,
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.transparent,
//               border: Border(),
//             ),
//             child: PieChart(
//               PieChartData(
//                 sections: _generatePieChartData(),
//                 centerSpaceRadius: 30,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   List<PieChartSectionData> _generatePieChartData() {
//     // Define a list of colors for each category
//     final List<Color> categoryColors = [
//       Colors.red,
//       Colors.green,
//       Colors.blue,
//       Colors.orange,
//       Colors.purple,
//       // Add more colors as needed
//     ];
//     // Define an index variable to iterate over categoryColors
//     int colorIndex = 0;
//     return widget.categoryCounts.keys.map((category) {
//       final int value = widget.categoryCounts[category] ?? 0;
//       final Color sectionColor =
//           categoryColors[colorIndex % categoryColors.length];
//       colorIndex++;
//       return PieChartSectionData(
//         color: sectionColor,
//         value: value.toDouble(),
//         title: category,
//         radius: 50,
//         titleStyle: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//         // ).copyWith(
//         // Use copyWith to add gesture recognizer
//         badgeWidget: GestureDetector(
//           onTap: () {
//             // Handle tap event for the specific category
//             print('Tapped on category: $category');
//           },
//           child:
//               Container(), // Placeholder widget, replace with your desired widget
//         ),
//

class ExercisePieChart extends StatefulWidget {
  final Map<String, int> categoryCounts;

  const ExercisePieChart({required this.categoryCounts});

  @override
  State<ExercisePieChart> createState() => _ExercisePieChartState();
}

class _ExercisePieChartState extends State<ExercisePieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (pieTouchResponse) {
                      setState(() {
                        if (pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),

                  borderData: FlBorderData(
                    show: false,
                  ),

                  sectionsSpace: 4,
                  centerSpaceRadius: 30,
                  sections: _generatePieChartData(),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.categoryCounts.keys.map((category) {
              final index =
                  widget.categoryCounts.keys.toList().indexOf(category);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Indicator(
                  color: _categoryColors[index % _categoryColors.length],
                  text: category,
                  isSquare: true,
                ),
              );
            }).toList(),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  List<Color> get _categoryColors => [
        Color(0xffFF4900),
        Colors.green,
        Colors.blue,
        Colors.orange,
        Colors.purple,
        // Add more colors as needed
      ];

  List<PieChartSectionData> _generatePieChartData() {
    final List<Color> categoryColors = _categoryColors;
    int colorIndex = 0;

    // Calculate the total count
    final int totalCount =
        widget.categoryCounts.values.fold(0, (sum, item) => sum + item);
    return widget.categoryCounts.keys.map((category) {
      final int value = widget.categoryCounts[category] ?? 0;
      final double percentage =
          totalCount == 0 ? 0 : (value / totalCount) * 100;

      final isTouched = colorIndex == touchedIndex;
      final double fontSize = isTouched ? 25.0 : 16.0;
      final double radius = isTouched ? 60.0 : 50.0;
      final Color sectionColor =
          categoryColors[colorIndex % categoryColors.length];
      colorIndex++;

      return PieChartSectionData(
        color: sectionColor,
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
        ),
      );
    }).toList();
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    this.isSquare = true,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white38,
          ),
        )
      ],
    );
  }
}

class ExerciseBarChart extends StatefulWidget {
  final Map<String, int> data;

  const ExerciseBarChart({required this.data});

  @override
  _ExerciseBarChartState createState() => _ExerciseBarChartState();
}

class _ExerciseBarChartState extends State<ExerciseBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController)
          ..addListener(() {
            setState(() {});
          });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: AspectRatio(
        aspectRatio: 1.6,
        child: BarChart(
          BarChartData(
            backgroundColor: Colors.transparent,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                // tooltipMargin: 8,
                tooltipBgColor: Colors.black,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final String exerciseName =
                      widget.data.keys.elementAt(group.x.toInt());
                  final String repetitions =
                      widget.data.values.elementAt(group.x.toInt()).toString();
                  return BarTooltipItem(
                    '$exerciseName: $repetitions',
                    const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) =>
                    TextStyle(color: Colors.white, fontSize: 12),
                margin: 10,
                getTitles: (value) {
                  final int index = value.toInt();
                  if (index >= 0 && index < widget.data.length) {
                    return widget.data.keys.elementAt(index);
                  }
                  return '';
                },
              ),
              leftTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 15,
                getTextStyles: (value) =>
                    const TextStyle(color: Colors.white, fontSize: 12),
                margin: 10,
                getTitles: (value) {
                  if (value % 5 == 0) {
                    return value.toInt().toString();
                  }
                  return '';
                },
              ),
            ),
            borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(color: Colors.white),
                  left: BorderSide(color: Colors.transparent),
                )),
            barGroups: widget.data.entries.map((entry) {
              return BarChartGroupData(
                x: widget.data.keys.toList().indexOf(entry.key),
                barRods: [
                  BarChartRodData(
                    y: entry.value.toDouble() * _animation.value,
                    // Apply animation
                    colors: [Colors.deepPurple],
                    width: 20,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                    // Apply gradient
                    gradientFrom: Offset(0, 1),
                    gradientTo: Offset(0, 0),
                    gradientColorStops: [0.5, 1.0],
                    // End of gradient
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // String? mostExecutedCategory;
  late Map<String, int> categoryCounts = {};
  Map<String, int> totalSetsData = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    categoryCounts = await getCategoryCounts(userId);
    totalSetsData = await getTotalSetsForAllExercises(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> categoryCounts = {};
    return FutureBuilder<bool>(
      future: isFirstTimeUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final bool isFirstTime = snapshot.data ?? true;

        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          return Scaffold(
            body: Center(
              child: Text("User not authenticated. Redirecting to login..."),
            ),
          );
        }

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (userSnapshot.hasError) {
              return Text('Error fetching user data: ${userSnapshot.error}');
            }

            final userData = userSnapshot.data;

            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              return const Scaffold(
                body: Center(
                  child: Text("User data not found. Redirecting to login..."),
                ),
              );
            }

            final String? _profileImageUrl = userData?.get('profileImageUrl');
            final String? _name = userData?.get('name');

            return FutureBuilder<Map<String, int>>(
              future: getTotalSetsForAllExercises(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final totalSetsData = snapshot.data!;

                return FutureBuilder<Map<String, int>>(
                  future: getCategoryCounts(user.uid),
                  builder: (context, categorySnapshot) {
                    if (categorySnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (categorySnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${categorySnapshot.error}'));
                    }

                    categoryCounts = categorySnapshot.data!;

                    if (!isFirstTime) {
                      return Scaffold(
                        backgroundColor: Colors.black,
                        body: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(
                                    left: 25, right: 10, top: 55),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Hi, $_name 👋🏻',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 30,
                                              color: Colors.white),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/profile');
                                          },
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                100, 10, 10, 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                    color:
                                                        Colors.grey.shade700)),
                                            child: CircleAvatar(
                                              radius: 22,
                                              backgroundColor: Colors.grey,
                                              child: _profileImageUrl != null
                                                  ? ClipOval(
                                                      child: Image.network(
                                                        _profileImageUrl,
                                                        width: 60,
                                                        height: 60,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : Icon(
                                                      Icons.person,
                                                      color: Colors.white,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.stacked_bar_chart_sharp,
                                          // Icons.local_fire_department,
                                          color: Color(
                                              0xFF74FFE8), // Add your custom color here
                                        ),
                                        SizedBox(width: 1),
                                        Text(
                                          "Your Workout Stats!",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20,
                                            color: Color(
                                                0xFF74FFE8), // Add your custom color here
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Card(
                                child: Container(
                                  width: 340,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(40)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.local_fire_department,
                                            color: Color(0xffFF4900),
                                          ),
                                          Text(
                                            "Most Executed Category",
                                            style: TextStyle(
                                              color: Color(0xffFF4900),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Text("Check your most executed category"
                                          " to help you balance your training"),
                                      Divider(
                                        color: Colors.white38,
                                      ),
                                      // SizedBox(height: 20,),
                                      ExercisePieChart(
                                          categoryCounts: categoryCounts),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Card(
                                child: Container(
                                  width: 340,
                                  height: 330,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            // Align text to the start
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.local_fire_department,
                                                    color: Color(0xffFF4900),
                                                  ),
                                                  // SizedBox(width: 8),
                                                  // Add space between icon and text
                                                  Text(
                                                    "Most executed Exercise",
                                                    style: TextStyle(
                                                      color: Color(0xffFF4900),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              // Add space between title and description
                                              Text(
                                                "See your top exercises to "
                                                "track and adjust\nyour "
                                                "routine.",

                                                style: TextStyle(
                                                  // fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.left,
                                                // Align text to the left
                                                softWrap:
                                                    true, // Enable text wrapping
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.white38,
                                      ),
                                      SizedBox(height: 10),
                                      ExerciseBarChart(data: totalSetsData),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 1,
                                  child: ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.grey.shade800,
                                          Colors.grey.shade800,
                                          Colors.grey.shade800,
                                          Colors.grey.shade800,
                                          Colors.transparent,
                                          Colors.transparent,
                                        ],
                                      ).createShader(bounds);
                                    },
                                    blendMode: BlendMode.dstIn,
                                    child: Image.asset(
                                      'assets/dot.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 20,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    padding: EdgeInsets.only(
                                        left: 25, right: 10, top: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Hi, $_name 👋🏻',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 25,
                                              color: Colors.white),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/profile');
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                    color:
                                                        Colors.grey.shade700)),
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.grey,
                                              child: _profileImageUrl != null
                                                  ? ClipOval(
                                                      child: Image.network(
                                                        _profileImageUrl,
                                                        width: 60,
                                                        height: 60,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : Icon(
                                                      Icons.person,
                                                      color: Colors.white,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Manage your",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 33,
                                        fontWeight: FontWeight.w600)),
                                Text("daily workouts",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 33,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 6),
                                Text("Set Your Workout Plan ",
                                    style: TextStyle(
                                        color: Colors.deepPurple[300],
                                        fontSize: 16)),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, 'create');
                                  },
                                  child: Icon(Icons.arrow_forward_outlined),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    routes: {'create': (context) => CreatePlanPage()},
  ));
}
