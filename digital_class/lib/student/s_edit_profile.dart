import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class S_edit_profile extends StatefulWidget {
  final String studID;

  const S_edit_profile({
    Key? key,
    required this.studID,
  }) : super(key: key);

  @override
  State<S_edit_profile> createState() => _S_edit_profileState();
}

class _S_edit_profileState extends State<S_edit_profile> {
  final CollectionReference student =
      FirebaseFirestore.instance.collection('student');
  final CollectionReference login =
      FirebaseFirestore.instance.collection('login');
  TextEditingController s_rno = TextEditingController();
  TextEditingController s_nam = TextEditingController();
  TextEditingController s_email = TextEditingController();
  TextEditingController s_pass = TextEditingController();
  TextEditingController dept = TextEditingController();
  TextEditingController cou = TextEditingController();

// Fetch student details using the provided studID
  Future<void> fetchStudentDetails() async {
    try {
      final studentDoc = await student.doc(widget.studID).get();
      if (studentDoc.exists) {
        final studentData = studentDoc.data() as Map<String, dynamic>;
        s_rno.text = studentData['rollno'] ?? '';
        s_nam.text = studentData['uname'] ?? '';
        s_email.text = studentData['email'] ?? '';
        s_pass.text = studentData['pass'] ?? '';
        dept.text = studentData['dept'] ?? '';
        cou.text = studentData['course'] ?? '';
      }
    } catch (e) {
      print('Error fetching student details: $e');
    }
  }

  void updateStudentDetails() async {
    try {
      // Update details in the student collection
      await student.doc(widget.studID).update({
        'rollno': s_rno.text,
        'uname': s_nam.text,
        'email': s_email.text,
        'pass': s_pass.text,
        'dept': dept.text,
        'course': cou.text,
      });

      // Update details in the login collection
      await login
          .where('user_id', isEqualTo: widget.studID)
          .limit(1)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          final loginDoc = querySnapshot.docs.first;
          loginDoc.reference.update({
            'pass': s_pass.text,
            'uname': s_email.text,
          });
        }
      });

      // Provide feedback to the user if needed
      // ...
    } catch (e) {
      print('Error updating student details: $e');
      // Handle update error
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStudentDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              TextField(
                controller: s_rno,
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
                  labelText: "Roll Number",
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 2, 123, 40),
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: s_nam,
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
                  labelText: "User name",
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 2, 123, 40),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: s_email,
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
                  labelText: "Email",
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 2, 123, 40),
                    // Change text color
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: s_pass,
                // obscureText: true,
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
                  labelText: "Password",
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 2, 123, 40), // Change text color
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: dept,
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
                  labelText: "Department",
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 2, 123, 40), // Change text color
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: cou,
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
                  labelText: "Course",
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 2, 123, 40), // Change text color
                  ),
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
                  updateStudentDetails();
                  // Return true as the result to indicate a successful update
                  Navigator.pop(context, true);
                },
                child: Text("Apply Changes"),
              ),
              // Add some space between the button and the text

              Container(
                child: lott(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  lott() {
    return Container(
      height: 200,
      width: 200,
      child: Lottie.network(
          'https://lottie.host/6c0b70f4-1f39-4499-9e32-d55e02bafe31/JZuSx7pd0l.json'),
    );
  }
}
