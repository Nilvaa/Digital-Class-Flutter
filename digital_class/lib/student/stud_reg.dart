import 'package:digital_class/login/login.dart';
import 'package:digital_class/dummytest/viewteacher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class St_register extends StatefulWidget {
  const St_register({super.key});

  @override
  State<St_register> createState() => _St_registerState();
}

class _St_registerState extends State<St_register> {
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

  void stud_reg() async {
    try {
      final studentDoc = await student.add({
        'rollno': s_rno.text,
        'uname': s_nam.text,
        'pass': s_pass.text,
        'email': s_email.text,
        'dept': dept.text,
        'course': cou.text,
        
      });

      final studentId = studentDoc.id;

      final log = {
        'pass': s_pass.text,
        'uname': s_email.text,
        'status': 'student',
        'user_id': studentId, 
      };

      await login.add(log);

      // The registration is complete with the teacher_id as a foreign key in the "login" collection.
    } catch (e) {
      print("Error registering user: $e");
      // Handle registration error
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      // Query to find the teacher with the given email and password
      final loginQuery = await login
          .where('uname', isEqualTo: email)
          .where('pass', isEqualTo: password)
          .limit(1)
          .get();

      if (loginQuery.docs.isNotEmpty) {
        final loginDoc = loginQuery.docs.first;
        final studentId = loginDoc.get('user_id');

        // You can now use teacherId to identify the teacher who logged in.
        // Perform any actions you need with the teacher's information.
      } else {
        // Handle login failure (user not found, incorrect credentials, etc.)
      }
    } catch (e) {
      print("Error logging in: $e");
      // Handle login error
    }
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
                obscureText: true,
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
                  stud_reg();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Login(title: '',)));
                },
                child: Text("SIGN UP"),
              ),
              SizedBox(
                  height: 20), // Add some space between the button and the text
              RichText(
                text: TextSpan(
                  text: 'Already a user? ',
                  style: TextStyle(color: Color.fromARGB(255, 68, 187, 82)),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Login',
                      style: TextStyle(
                        color: Color.fromARGB(
                            255, 2, 123, 40), // Change the color as needed
                        // You can also add other styles like fontWeight, fontSize, etc.
                        decoration: TextDecoration.none,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Add your navigation logic to the login page here
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Login(
                                        title: '',
                                      )));
                        },
                    ),
                  ],
                ),
              ),
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
