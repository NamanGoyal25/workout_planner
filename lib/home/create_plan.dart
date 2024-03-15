// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import 'days_page.dart';
//
// class CreatePlanPage extends StatefulWidget {
//   @override
//   _CreatePlanPageState createState() => _CreatePlanPageState();
// }
//
// class _CreatePlanPageState extends State<CreatePlanPage> {
//   int? selectedWeek;
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
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Expanded(
//             child: CardWidget(
//               title: "Week 1",
//               backgroundColour: Color(0xffFFAF58),
//               weekNumber: 1,
//               onTap: () {
//                 setState(() {
//                   selectedWeek = 1;
//                 });
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => DaysPage(selectedWeek: selectedWeek)),
//                 );
//               },
//             ),
//           ),
//           Expanded(
//             child: CardWidget(
//               title: "Week 2",
//               backgroundColour: Color(0xffFFAF58),
//               weekNumber: 2,
//               onTap: () {
//                 setState(() {
//                   selectedWeek = 2;
//                 });
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => DaysPage(selectedWeek: selectedWeek)),
//                 );
//               },
//             ),
//           ),
//           Expanded(
//             child: CardWidget(
//               title: "Week 3",
//               backgroundColour: Color(0xffFFAF58),
//               weekNumber: 3,
//               onTap: () {
//                 setState(() {
//                   selectedWeek = 3;
//                 });
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => DaysPage(selectedWeek: selectedWeek)),
//                 );
//               },
//             ),
//           ),
//           Expanded(
//             child: CardWidget(
//               title: "Week 4",
//               backgroundColour: Color(0xffFFAF58),
//               weekNumber: 4,
//               onTap: () {
//                 setState(() {
//                   selectedWeek = 4;
//                 });
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => DaysPage(selectedWeek: selectedWeek)),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class CardWidget extends StatelessWidget {
//   final String title;
//   final Color backgroundColour;
//   final int weekNumber;
//   final VoidCallback onTap;
//
//   const CardWidget({
//     required this.title,
//     required this.weekNumber,
//     required this.backgroundColour,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final startDate = getStartDateOfWeek(weekNumber);
//     final weekRange = getWeekRangeWithMonthNames(startDate);
//     return Container(
//       margin: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Colors.white, Colors.white],
//         ),
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xffFFAF58),
//             spreadRadius: 5,
//             blurRadius: 7,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Card(
//         elevation: 4,
//         margin: const EdgeInsets.all(0),
//         color: backgroundColour,
//         child: InkWell(
//           onTap: onTap,
//           child: Padding(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 8,),
//                 Text(title,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),),
//                 const SizedBox(height: 10),
//                 Text(
//                   ' ${weekRange.day} ${DateFormat('MMM').format(weekRange)}-${weekRange.add(Duration(days: 6)).day} ${DateFormat('MMM').format(weekRange.add(Duration(days: 6)))}',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   DateTime getStartDateOfWeek(int weekNumber) {
//     DateTime startDate = DateTime.now().subtract(
//       Duration(days: (DateTime.monday - 1) + (weekNumber - 1) * 7),
//     );
//     if (startDate.weekday != DateTime.monday) {
//       startDate = startDate.subtract(Duration(days: (startDate.weekday - DateTime.monday) % 7));
//     }
//     return startDate;
//   }
//
//   DateTime getWeekRangeWithMonthNames(DateTime startDate) {
//     DateTime endDate = startDate.add(Duration(days: 6));
//     DateTime lastDayOfMonth = DateTime(startDate.year, startDate.month + 1, 0);
//     if (endDate.isAfter(lastDayOfMonth)) {
//       endDate = lastDayOfMonth;
//     }
//     return endDate;
//   }
// }



import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      appBar: AppBar(
        title: Text(
            'Plan your workout',
            style: GoogleFonts.montserrat()// Use Google Fonts for app bar title
        ),
        centerTitle: true,
        backgroundColor: Color(0xff202020),
      ),
      backgroundColor: Color(0xff202020),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 55,
              bottom: 0,
              left: 0,
              right: 0,
              child: GridView.count(
                crossAxisCount: 2, // 2 columns
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                padding: EdgeInsets.all(20.0),
                children: [
                  buildCardWidget("Week 1", 1, Colors.deepPurple.shade400, Icons.sports_gymnastics),
                  buildCardWidget("Week 2", 2, Colors.deepPurple.shade400, Icons.directions_bike),
                  buildCardWidget("Week 3", 3, Colors.deepPurple.shade400, Icons.self_improvement_sharp),
                  buildCardWidget("Week 4", 4, Colors.deepPurple.shade400, Icons.fitness_center_sharp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCardWidget(String title, int weekNumber, Color backgroundColour, IconData iconData) {
    return Card(
      elevation: 10,
      color: backgroundColour.withOpacity(0.6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedWeek = weekNumber;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DaysPage(selectedWeek: selectedWeek)),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // Change this color to the desired circle color
              ),
              child: Icon(
                iconData,
                size: 35,
                color: backgroundColour, // Change this color to the desired icon color
              ),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
