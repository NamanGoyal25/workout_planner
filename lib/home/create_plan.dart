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
