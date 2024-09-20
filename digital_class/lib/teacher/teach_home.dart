import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_class/teacher/te_add_class.dart';
import 'package:digital_class/teacher/te_profile.dart';
import 'package:digital_class/teacher/te_uploaded_assign.dart';
import 'package:digital_class/teacher/te_view_stud.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class T_home extends StatefulWidget {
  const T_home({super.key, required String tid});

  @override
  State<T_home> createState() => _T_homeState();
}

class _T_homeState extends State<T_home> {
  final CollectionReference teacher =
      FirebaseFirestore.instance.collection('teacher');
  late String t_id;
  String teacherName = ''; // Variable to store the teacher's name

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    t_id = args['id']; // Get the teacher ID from arguments

    // Fetch the teacher's name using the t_id
    DocumentSnapshot teacherSnapshot = await teacher.doc(t_id).get();
    if (teacherSnapshot.exists) {
      setState(() {
        teacherName = teacherSnapshot['uname'];
      });
    }
    print(teacherName);
    print("hello");
    print(t_id);
  }

  int indexnum = 0;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Classmate",
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
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
              backgroundColor: Color.fromARGB(255, 2, 123, 40),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_rounded),
              label: "Students",
              backgroundColor: Color.fromARGB(255, 2, 123, 40),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_rounded),
              label: "Assignments",
              backgroundColor: Color.fromARGB(255, 2, 123, 40),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
              backgroundColor: Color.fromARGB(255, 2, 123, 40),
            )
          ],
          currentIndex: indexnum,
          onTap: (int index) {
            setState(() {
              indexnum = index;
            });
            switch (index) {
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => T_view_stud(tid: t_id)),
                );
                break;
              case 2:
                Navigator.pushNamed(context, '/add_assignment', arguments: {
                  'id': t_id,
                });
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => T_profile(tid: t_id)),
                );
                break;
            }
          }),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Text(
                "Hello,",
                style: GoogleFonts.homemadeApple(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 2, 123, 40),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 70, top: 5),
            child: Text(
              '$teacherName💚',
              style: GoogleFonts.miniver(
                  fontSize: 30,
                  color: Color.fromARGB(255, 2, 123, 40),
                  fontWeight: FontWeight.w100),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 200,
              child: InkWell(
                onTap: () {
                  print("tapped");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => T_uploaded(teacherID: t_id)),
                  );
                },
                child: Card(
                  color: Colors.white,
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'images/teac.jpg',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 20), // Adjust the width as needed
                        Expanded(
                          child: Text(
                            "Explore and grade the assignments your students have shared – where learning meets assessment effortlessly.",
                            style: GoogleFonts.bilbo(
                                color: Color.fromARGB(255, 2, 123, 40),
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 200,
              child: InkWell(
                onTap: () {
                  print("tapped");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => T_class(teacherID: t_id)),
                  );
                },
                child: Card(
                  color: Colors.white,
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 5, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            "Craft a virtual classroom experience – where learning meets comfort, one click at a time.",
                            style: GoogleFonts.bilbo(
                                color: Color.fromARGB(255, 2, 123, 40),
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),

                        SizedBox(width: 10), // Adjust the width as needed
                        Image.asset(
                          'images/online.jpg',
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
