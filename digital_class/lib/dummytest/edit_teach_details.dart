import 'package:digital_class/login/login.dart';
import 'package:digital_class/dummytest/viewteacher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Editteach extends StatefulWidget {
  const Editteach({super.key});

  @override
  State<Editteach> createState() => _EditteachState();
}

class _EditteachState extends State<Editteach> {
  final CollectionReference teacher =
      FirebaseFirestore.instance.collection('teacher');
  TextEditingController t_nam = TextEditingController();
  TextEditingController t_email = TextEditingController();
  TextEditingController t_pass = TextEditingController();
  TextEditingController dept = TextEditingController();
  TextEditingController cou = TextEditingController();

  void update_teach(id) {
    final data = {
      'uname': t_nam.text,
      'pass': t_pass.text,
      'email': t_email.text,
      'dept': dept.text,
      'course': cou.text,
    };
    teacher.doc(id).update(data);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    t_nam.text = args['uname'];
    t_email.text = args['email'];
    t_pass.text = args['pass'];
    dept.text = args['dept'];
    cou.text = args['course'];
    final t_id = args['id'];
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
                      color: Color.fromARGB(255, 116, 231, 183),
                      width: 3,
                    ),
                  ),
                  labelText: "User name",
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 2, 123, 40), // Change text color
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
                      color: Color.fromARGB(255, 116, 231, 183),
                      width: 3,
                    ),
                  ),
                  labelText: "Email",
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 2, 123, 40), // Change text color
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: t_pass,
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
                      color: Color.fromARGB(255, 116, 231, 183),
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
                      color: Color.fromARGB(255, 116, 231, 183),
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
                      color: Color.fromARGB(255, 116, 231, 183),
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
                    Color.fromARGB(255, 116, 231, 183),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 2, 123, 40),
                  ),
                  textStyle: MaterialStateProperty.all(TextStyle(
                    fontSize: 15,
                  )),
                ),
                onPressed: () {
                  // print(args);
                  update_teach(t_id);
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Viewteacher()));
                },
                child: Text("UPDATE"),
              ),
              SizedBox(height: 20),
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
