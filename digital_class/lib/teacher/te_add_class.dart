import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_class/teacher/te_view_class.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class T_class extends StatefulWidget {
  final String teacherID;
  const T_class({
    Key? key,
    required this.teacherID,
  }) : super(key: key);

  @override
  State<T_class> createState() => _T_classState();
}

class _T_classState extends State<T_class> {
  final CollectionReference onlineclass =
      FirebaseFirestore.instance.collection('online_class');
  TextEditingController link = TextEditingController();
  final TextEditingController date = TextEditingController();
  final TextEditingController time = TextEditingController();
  TextEditingController sub = TextEditingController();

  void _date(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        date.text =
            formattedDate; // Update the text field with the selected date
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final formattedHour =
          pickedTime.hourOfPeriod == 0 ? 12 : pickedTime.hourOfPeriod;
      final formattedMinutes = pickedTime.minute.toString().padLeft(2, '0');
      final periodIndicator = pickedTime.period == DayPeriod.am ? 'AM' : 'PM';

      final formattedTime = '$formattedHour:$formattedMinutes $periodIndicator';

      setState(() {
        time.text = formattedTime;
      });
    }
  }

  void _scheduleClass() {
  // Extract data from text fields
  String linkValue = link.text;
  String dateValue = date.text;
  String timeValue = time.text;
  String subValue = sub.text;

  // Check if any field is empty before storing
  if (linkValue.isEmpty ||
      dateValue.isEmpty ||
      timeValue.isEmpty ||
      subValue.isEmpty) {
    // Show a snackbar or some error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please fill in all fields'),
      ),
    );
    return;
  }

  // Store data in online_class collection
  onlineclass.add({
    'teacher_id': widget.teacherID,
    'meet_link': linkValue,
    'date': dateValue,
    'time': timeValue,
    'subject': subValue,
  });

  // Optionally, you can show a success message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Color.fromARGB(255, 2, 123, 40),
      content: Text('Class scheduled successfully'),
    ),
  );

  // Clear the text fields after scheduling
  link.clear();
  date.clear();
  time.clear();
  sub.clear();

  // Navigate to view schedules
  _viewSchedules();
}

void _viewSchedules() {
  // Navigate to ViewSchedulesPage and pass the teacherID
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => T_view_class(teacherID: widget.teacherID),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Schedule online class",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 2, 123, 40),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            )
          ],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
          elevation: 20,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 90,
                ),
                TextField(
                  controller: link,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 2, 123, 40),
                        width: 3,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 68, 187, 82),
                        width: 3,
                      ),
                    ),
                    labelText: "Meet link",
                    labelStyle: TextStyle(
                      color:
                          Color.fromARGB(255, 2, 123, 40), // Change text color
                    ),
                    hintStyle: TextStyle(
                      color:
                          Color.fromARGB(255, 2, 123, 40), // Change hint color
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  onTap: () {
                    _date(context);
                  },
                  controller: date,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 2, 123, 40),
                        width: 3,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 68, 187, 82),
                        width: 3,
                      ),
                    ),
                    labelText: "Date",
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 2, 123, 40),
                    ),
                    prefixIcon: Icon(Icons.date_range,
                        color: Color.fromARGB(255, 2, 123, 40)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  onTap: () {
                    _pickTime(context);
                  },
                  controller: time,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 2, 123, 40),
                        width: 3,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 68, 187, 82),
                        width: 3,
                      ),
                    ),
                    labelText: "Time",
                    labelStyle: TextStyle(
                      color:
                          Color.fromARGB(255, 2, 123, 40), // Change text color
                    ),
                    hintStyle: TextStyle(
                      color:
                          Color.fromARGB(255, 2, 123, 40), // Change hint color
                    ),
                    prefixIcon: Icon(Icons.timelapse,
                        color: Color.fromARGB(255, 2, 123, 40)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: sub,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 2, 123, 40),
                        width: 3,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 68, 187, 82),
                        width: 3,
                      ),
                    ),
                    labelText: "Subject",
                    labelStyle: TextStyle(
                      color:
                          Color.fromARGB(255, 2, 123, 40), // Change text color
                    ),
                    hintStyle: TextStyle(
                      color:
                          Color.fromARGB(255, 2, 123, 40), // Change hint color
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                    padding: MaterialStateProperty.all(EdgeInsets.only(
                      left: 50,
                      right: 50,
                      top: 10,
                      bottom: 10,
                    )),
                    foregroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 255, 255, 255),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 2, 123, 40),
                    ),
                    textStyle: MaterialStateProperty.all(const TextStyle(
                      fontSize: 15,
                    )),
                  ),
                  onPressed: _scheduleClass,
                  child: Text("Schedule"),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                    padding: MaterialStateProperty.all(EdgeInsets.only(
                      left: 50,
                      right: 50,
                      top: 10,
                      bottom: 10,
                    )),
                    foregroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 255, 255, 255),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 2, 123, 40),
                    ),
                    textStyle: MaterialStateProperty.all(const TextStyle(
                      fontSize: 15,
                    )),
                  ),
                 onPressed: _viewSchedules,
                  child: Text("View Schedules"),
                ),
              ],
            ),
          ),
        ));
  }
}
