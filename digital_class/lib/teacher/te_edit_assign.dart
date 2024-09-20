import 'package:digital_class/teacher/te_view_assignment.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class Te_edit_assign extends StatefulWidget {
  const Te_edit_assign({super.key});

  @override
  State<Te_edit_assign> createState() => _Te_edit_assignState();
}

class _Te_edit_assignState extends State<Te_edit_assign> {
  final CollectionReference assignment =
      FirebaseFirestore.instance.collection('assignment');
  TextEditingController topic = TextEditingController();
  TextEditingController des = TextEditingController();
  TextEditingController _deadlineController = TextEditingController();


 @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments as Map;
    topic.text = args['topic'];
    des.text = args['description'];
    _deadlineController.text = args['deadline'];
  }

   Future<void> edit_assign(id) async {
    final data = {
      'topic': topic.text,
      'description': des.text,
      'deadline': _deadlineController.text,
    };
    
   try {
    await assignment.doc(id).update(data);
    print("Update successful!");

    // Fetch the teacherId from the assignment collection
    DocumentSnapshot assignmentSnapshot = await assignment.doc(id).get();
    String teacherId = assignmentSnapshot['teacher_id'];

    // Navigate back to Te_view_assign() with the retrieved teacherId
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Te_view_assign(teacherId: teacherId)),
    );
  } catch (error) {
    print("Error updating assignment: $error");
    // Handle error if needed
  }
}

  void _deadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _deadlineController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    

    final a_id = args['a_id'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Assignment",
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
                    color: Color.fromARGB(255, 2, 123, 40),
                  ),
                  prefixIcon: Icon(Icons.date_range),
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
                  edit_assign(a_id);
                },
                child: Text("Update"),
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
