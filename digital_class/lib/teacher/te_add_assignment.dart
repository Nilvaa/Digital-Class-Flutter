import 'package:digital_class/teacher/te_view_assignment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class T_add_assign extends StatefulWidget {
  final String t_id;

  T_add_assign({Key? key, required this.t_id}) : super(key: key);

  @override
  State<T_add_assign> createState() => _T_add_assignState();
}

class _T_add_assignState extends State<T_add_assign> {
  late String te_id;
  final CollectionReference assignment =
      FirebaseFirestore.instance.collection('assignment');
  TextEditingController topic = TextEditingController();
  TextEditingController des = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  void _addAssignment() {
    assignment.add({
      'teacher_id': te_id, // Set the teacher_id
      'topic': topic.text,
      'description': des.text,
      'deadline': _deadlineController.text,
    }).then((value) {
      // Assignment added successfully
      print('Assignment added: $value');
      // Optionally, you can navigate to another page or show a success message.
    }).catchError((error) {
      // Error handling, e.g., show an error message.
      print('Error adding assignment: $error');
    });
  }

  void _deadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        _deadlineController.text =
            formattedDate; // Update the text field with the selected date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context)!.settings.arguments as Map;

    if (args != null && args.containsKey('id')) {
      te_id = args['id'];
      print("heyyyyyyyyyyyyyyyyy");
      print(te_id);
    } else {
      print("Error: Unable to retrieve teacher ID from arguments.");
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Assignment",
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
              ))
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
        elevation: 20,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              TextField(
                controller: topic,
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
                  labelText: "Assignment Topic",
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 2, 123, 40), // Change text color
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: des,
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
                  labelText: "Description",
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 2, 123, 40), // Change text color
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                onTap: () {
                  _deadline(context);
                },
                controller: _deadlineController,
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
                  labelText: "Deadline",
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 2, 123, 40), // Change text color
                  ),
                  prefixIcon: Icon(Icons.date_range,color: Color.fromARGB(255, 2, 123, 40)),
                ),
              ),
              SizedBox(height: 20),
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
                  textStyle: MaterialStateProperty.all(TextStyle(
                    fontSize: 15,
                  )),
                ),
                onPressed: () {
                  _addAssignment();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Te_view_assign(
                          teacherId: te_id), // Pass the teacher ID
                      settings: RouteSettings(arguments: {'id': te_id}),
                    ),
                  );
                },
                child: Text("Add Assignment"),
              ),
              SizedBox(height: 10),
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
                  textStyle: MaterialStateProperty.all(TextStyle(
                    fontSize: 15,
                  )),
                ),
                onPressed: () {
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Te_view_assign(
                          teacherId: te_id), // Pass the teacher ID
                      settings: RouteSettings(arguments: {'id': te_id}),
                    ),
                  );
                },
                child: Text("View Assignment"),
              ),
              Container(
                child: Align(
                  child: lott(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  lott() {
    return Container(
      child: Lottie.network(
          'https://lottie.host/a08fc775-8b50-4a7f-9b55-be067b311971/14mlsZYJVq.json'),
    );
  }
}
