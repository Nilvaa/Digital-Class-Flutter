import 'package:digital_class/login/login.dart';
import 'package:digital_class/student/s_profile.dart';
import 'package:digital_class/student/st_view_assign.dart';
import 'package:digital_class/student/st_view_mark.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class S_home extends StatefulWidget {
  const S_home({Key? key}) : super(key: key);

  @override
  State<S_home> createState() => _S_homeState();
}

class _S_homeState extends State<S_home> {
  final CollectionReference student =
      FirebaseFirestore.instance.collection('student');
  final CollectionReference teacher =
      FirebaseFirestore.instance.collection('teacher');
  final CollectionReference onlineclass =
      FirebaseFirestore.instance.collection('online_class');

  late String studentName = '';
  late String user_id;
  int selectedIndex = 0;
  String studentDepartment = '';


  List<Map<String, dynamic>> onlineClassesList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      fetchStudentDetails();
    });
  }

  void fetchStudentDetails() async {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    user_id = args['id'];

    try {
      var studentDoc = await student.doc(user_id).get();

      if (studentDoc.exists) {
        var uname = studentDoc.get('uname');
        var department = studentDoc.get('dept');
        print('Student name: $uname, Department: $department');
        print("studddddddddddddddddddddd");
        setState(() {
          studentName = uname ?? '';
          studentDepartment = department ?? '';
        });
        fetchOnlineClasses(); // Fetch online classes after getting department
      } else {
        print('in home Student not found with ID: $user_id');
      }
    } catch (e) {
      print('Error fetching student details: $e');
    }
  }

  void fetchOnlineClasses() async {
    try {
      // Query teachers in the same department
      var teachersQuery =
          await teacher.where('dept', isEqualTo: studentDepartment).get();

      var teacherIds = teachersQuery.docs.map((doc) => doc.id).toList();

      print('Teacher IDs: $teacherIds');

      // Query online classes with matching teacher_id
      var onlineClassesQuery =
          await onlineclass.where('teacher_id', whereIn: teacherIds).get();
      var onlineClasses = onlineClassesQuery.docs.map((doc) {
        var meetLink = doc['meet_link'];
        
        return {
          'subject': doc['subject'],
          'meet_link': meetLink,
          'date': doc['date'],
          'time': doc['time'],
          'teacher_id': doc['teacher_id'],
        };
      }).toList();

      print('Online Classes: $onlineClasses');

      setState(() {
        onlineClassesList = onlineClasses;
      });
    } catch (e) {
      print('Error fetching online classes: $e');
    }
  }

  void navigateToRoute(BuildContext context, Widget route) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => route));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Classmate",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 2, 123, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
        elevation: 20,
      ),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountEmail: Text("WELCOME TO CLASSMATE💚"),
              accountName: Text(
                'HELLO ${studentName.toUpperCase()}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            buildDrawerItem(0, Icons.note_alt, "Assignments"),
            buildDrawerItem(1, Icons.assessment, "Marks"),
            buildDrawerItem(2, Icons.person, "Profile"),
            buildDrawerItem(3, Icons.logout, "Sign Out"),
          ],
        ),
      ),
      body: Container(
        // height: 200,
        width: 500,
        child: ListView.builder(
          itemCount: onlineClassesList.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(
                      255, 9, 10, 9), 
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.brown, 
                    width: 10,
                  ),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Class about : ${onlineClassesList[index]['subject']}',
                      style: GoogleFonts.gaegu(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    FutureBuilder(
                      future: getTeacherName(
                          onlineClassesList[index]['teacher_id']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                            'Loading teacher name...',
                            style: GoogleFonts.gaegu(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error loading teacher name',
                            style: GoogleFonts.gaegu(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          );
                        } else {
                          return Text(
                            'Conducted by: ${snapshot.data}',
                            style: GoogleFonts.gaegu(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final url = Uri.parse('https://${onlineClassesList[index]['meet_link'].trim()}');
                        print('URL: $url');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                          print("clicked");
                        }
                      },
                      child: Text(
                        'Join Through: ${onlineClassesList[index]['meet_link']}',
                        style: GoogleFonts.gaegu(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'On: ${onlineClassesList[index]['date']}',
                      style: GoogleFonts.gaegu(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'At: ${onlineClassesList[index]['time']}',
                      style: GoogleFonts.gaegu(
                        fontSize: 16,
                        color: Colors.white, // Text color on the board
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<String> getTeacherName(String teacherId) async {
    try {
      var teacherDoc = await teacher.doc(teacherId).get();
      if (teacherDoc.exists) {
        var teacherName = teacherDoc.get('uname');
        return teacherName ?? 'Unknown Teacher';
      } else {
        return 'Unknown Teacher';
      }
    } catch (e) {
      print('Error fetching teacher name: $e');
      return 'Unknown Teacher';
    }
  }

  Widget buildDrawerItem(int index, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      iconColor: Color.fromARGB(255, 2, 123, 40),
      title: Text(
        title,
        style: TextStyle(fontSize: 18),
      ),
      textColor: Color.fromARGB(255, 2, 123, 40),
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        handleNavigation(index);
      },
    );
  }

  void handleNavigation(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => S_view_assign(studID: user_id),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => S_marks(studID: user_id)),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => S_profile(studID: user_id)),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Login(
                    title: '',
                  )),
        );
        break;
    }
  }
}

//  @override
//   Future<bool> didPopRoute() async {
//     if (lastBackPressed == null ||
//         DateTime.now().difference(lastBackPressed!) > Duration(seconds: 2)) {
//       lastBackPressed = DateTime.now();
//       Fluttertoast.showToast(
//         msg: "Press back again to exit.",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//       return false;
//     } else {
//       return true; // Allow the app to exit
//     }
//   }

