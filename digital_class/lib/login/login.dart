import 'package:digital_class/options.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  const Login({super.key, required String title});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final CollectionReference login =
      FirebaseFirestore.instance.collection('login');
  final CollectionReference teacher =
      FirebaseFirestore.instance.collection('teacher');
  final CollectionReference student =
      FirebaseFirestore.instance.collection('student');
  TextEditingController u_nam = TextEditingController();
  TextEditingController u_pass = TextEditingController();

  void u_login() {
    String username = u_nam.text;
    String password = u_pass.text;

    
    login
        .where('uname', isEqualTo: username)
        .where('pass', isEqualTo: password)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final String userid = userDoc['user_id'];
        final String status = userDoc['status'];

        print("User ID: $userid, Status: $status");

        if (status == 'student') {
          Navigator.pushNamed(context, '/stud_home', arguments: {
            'id': userid,
          });

          print("Student logged in");
        } else if (status == 'teacher') {
          Navigator.pushNamed(context, '/teac_home', arguments: {
            'id': userid,
          });
          print("Teacher logged in");
        } else {
          Fluttertoast.showToast(
            msg: "Invalid user status",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: Color.fromARGB(255, 6, 67, 26),
            textColor: Color.fromARGB(255, 255, 255, 255),
            fontSize: 16.0,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Incorrect username or password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Color.fromARGB(255, 6, 67, 26),
          textColor: Color.fromARGB(255, 255, 255, 255),
          fontSize: 16.0,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '“Education is the movement from darkness to light.”',
                      style: GoogleFonts.bethEllen(
                        color: Color.fromARGB(255, 68, 187, 82),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    Container(
                      child: TextField(
                        controller: u_nam,
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
                            color: Color.fromARGB(
                                255, 2, 123, 40), // Change text color
                          ),
                          hintStyle: TextStyle(
                            color: Color.fromARGB(
                                255, 2, 123, 40), // Change hint color
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: u_pass,
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
                          color: Color.fromARGB(
                              255, 2, 123, 40), // Change text color
                        ),
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(
                              255, 2, 123, 40), // Change hint color
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
                        u_login(); // Assuming this is where you navigate to S_home

                        print(
                            "printting log in id in login.dart in onpressws fn");
                        print(login.id);
                      },
                      child: Text("LOGIN"),
                    ),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: 'New user? ',
                        style:
                            TextStyle(color: Color.fromARGB(255, 68, 187, 82)),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              color: Color.fromARGB(255, 2, 123,
                                  40), // Change the color as needed
                              // You can also add other styles like fontWeight, fontSize, etc.
                              decoration: TextDecoration.none,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Add your navigation logic to the login page here
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Options()));
                              },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: content(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  content() {
    return Container(
      child: Lottie.network(
          'https://lottie.host/c37d562f-6b8a-432b-bb9a-6534948072aa/XCnI0QBohK.json'),
    );
  }
}
