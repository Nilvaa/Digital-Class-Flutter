import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_class/teacher/te_view_class.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class T_edit_class extends StatefulWidget {
  const T_edit_class({Key? key, required this.clId,required this.teacherID}) : super(key: key);

  final String clId;
   final String teacherID;
 

  @override
  State<T_edit_class> createState() => _T_edit_classState();
}

class _T_edit_classState extends State<T_edit_class> {
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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      print("Fetching data for clId: ${widget.clId}");
      if (widget.clId.isEmpty) {
        print('Error: clId is empty');
        return;
      }

      DocumentSnapshot documentSnapshot =
          await onlineclass.doc(widget.clId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? classData =
            documentSnapshot.data() as Map<String, dynamic>?;

        if (classData != null) {
          setState(() {
            link.text = classData['meet_link'] ?? '';
            date.text = classData['date'] ?? '';
            time.text = classData['time'] ?? '';
            sub.text = classData['subject'] ?? '';
          });
          print("Data fetched successfully: $classData");
        } else {
          print('Error: Data is not in the expected format');
        }
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

 Future<void> updateClassData() async {
  try {
    // Get the current document reference
    DocumentReference documentReference = onlineclass.doc(widget.clId);

    // Update the document with the new values
    await documentReference.update({
      'meet_link': link.text,
      'date': date.text,
      'time': time.text,
      'subject': sub.text,
    });

    print('Data updated successfully');

    // Navigate to view schedules after editing
    _viewSchedules();
  } catch (e) {
    print('Error updating data: $e');
  }
}

void _viewSchedules() {
  // Navigate to ViewSchedulesPage
  Navigator.pushReplacement(
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
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
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
                    color: Color.fromARGB(255, 2, 123, 40),
                  ),
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 2, 123, 40),
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
                    color: Color.fromARGB(255, 2, 123, 40),
                  ),
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 2, 123, 40),
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
                    color: Color.fromARGB(255, 2, 123, 40),
                  ),
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 2, 123, 40),
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
                onPressed: () {
                  updateClassData();
                },
                child: Text("Edit"),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
