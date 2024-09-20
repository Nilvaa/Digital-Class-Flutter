import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class T_view_stud extends StatefulWidget {
  final String tid;

  const T_view_stud({
    Key? key,
    required this.tid,
  }) : super(key: key);

  @override
  State<T_view_stud> createState() => _T_view_studState();
}

class _T_view_studState extends State<T_view_stud> {
  final CollectionReference teacher =
      FirebaseFirestore.instance.collection('teacher');
  final CollectionReference student =
      FirebaseFirestore.instance.collection('student');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Students",
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
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
        elevation: 20,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: teacher.doc(widget.tid).get(),
        builder: (context, teacherSnapshot) {
          if (teacherSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!teacherSnapshot.hasData) {
            return Center(child: Text("Teacher not found"));
          }

          // Extract department of the teacher
          String teacherDept = teacherSnapshot.data!['dept'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 50, right: 30),
                  child: Text(
                    "Department: $teacherDept",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 2, 123, 40),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      student.where('dept', isEqualTo: teacherDept).snapshots(),
                  builder: (context, studentSnapshot) {
                    if (studentSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!studentSnapshot.hasData) {
                      return Center(child: Text("No students found"));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: studentSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var studentData = studentSnapshot.data!.docs[index];

                        Widget getAvatarWidget(DocumentSnapshot studentData) {
                          var data =
                              studentData.data() as Map<String, dynamic>?;

                          if (data != null && data.containsKey('stud_pic')) {
                            String? studPic = data['stud_pic'];

                            if (studPic != null && studPic.isNotEmpty) {
                              try {
                                // Decode base64 string and set the image
                                List<int> bytes = base64.decode(studPic);
                                return CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      MemoryImage(Uint8List.fromList(bytes)),
                                );
                              } catch (e) {
                                // Handle any potential decoding errors, e.g., invalid base64 string
                                print('Error decoding stud_pic: $e');
                              }
                            }
                          }

                          // Use a default person icon if 'stud_pic' is not present or empty
                          return CircleAvatar(
                            radius: 50,
                            child: Icon(
                               Icons.person,
                            size: 90,
                            color: Color.fromARGB(255, 2, 123, 40),
                            ),
                          );
                        }

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.02,
                            vertical: MediaQuery.of(context).size.width * 0.02,
                          ),
                          child: Card(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      child: getAvatarWidget(
                                          studentData), // Use avatarWidget as the child
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Name: ${studentData['uname']}",
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 2, 123, 40),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Email: ${studentData['email']}",
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 2, 123, 40),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w100,
                                            ),
                                          ),
                                          Text(
                                            "Roll Number: ${studentData['rollno']}",
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 2, 123, 40),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w100,
                                            ),
                                          ),
                                          Text(
                                            "Course: ${studentData['course']}",
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 2, 123, 40),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w100,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
