import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class T_edit_profile extends StatefulWidget {
  final String teID;

  const T_edit_profile({
    Key? key,
    required this.teID,
  }) : super(key: key);

  @override
  State<T_edit_profile> createState() => _T_edit_profileState();
}

class _T_edit_profileState extends State<T_edit_profile> {
  final CollectionReference teacher =
      FirebaseFirestore.instance.collection('teacher');
  final CollectionReference login =
      FirebaseFirestore.instance.collection('login');
  TextEditingController t_nam = TextEditingController();
  TextEditingController t_email = TextEditingController();
  TextEditingController t_pass = TextEditingController();
  TextEditingController dept = TextEditingController();
  TextEditingController cou = TextEditingController();

  Future<void> fetchTeacherDetails() async {
    try {
      final teacherDoc = await teacher.doc(widget.teID).get();
      if (teacherDoc.exists) {
        final teacherData = teacherDoc.data() as Map<String, dynamic>;

        t_nam.text = teacherData['uname'] ?? '';
        t_email.text = teacherData['email'] ?? '';
        t_pass.text = teacherData['pass'] ?? '';
        dept.text = teacherData['dept'] ?? '';
        cou.text = teacherData['course'] ?? '';
      }
    } catch (e) {
      print('Error fetching teacher details: $e');
    }
  }

  void updateTeacherDetails() async {
    try {
      // Update details in the teacher collection
      await teacher.doc(widget.teID).update({
        'uname': t_nam.text,
        'email': t_email.text,
        'pass': t_pass.text,
        'dept': dept.text,
        'course': cou.text,
      });

      // Update details in the login collection
      await login
          .where('user_id', isEqualTo: widget.teID)
          .limit(1)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          final loginDoc = querySnapshot.docs.first;
          loginDoc.reference.update({
            'pass': t_pass.text,
            'uname': t_email.text,
          });
        }
      });

      // Provide feedback to the user if needed
      // ...
    } catch (e) {
      print('Error updating teacher details: $e');
      // Handle update error
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTeacherDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              TextField(
                controller: t_nam,
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
                controller: t_email,
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
                controller: t_pass,
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
                  updateTeacherDetails();
                  // Return true as the result to indicate a successful update
                  Navigator.pop(context, true);
                },
                child: Text("Apply Changes"),
              ),
              SizedBox(
                  height: 20), // Add some space between the button and the text

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
      child: Lottie.network(
          'https://lottie.host/e0baa190-84f5-43ba-b4d4-538d531d6d0e/BeF1xROzSf.json'),
    );
  }
}
