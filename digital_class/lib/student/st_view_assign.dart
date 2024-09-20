import 'package:digital_class/student/st_edit_assign.dart';
import 'package:digital_class/student/st_upload_assign.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class S_view_assign extends StatefulWidget {
  final String studID;

  const S_view_assign({Key? key, required this.studID}) : super(key: key);

  @override
  State<S_view_assign> createState() => _S_view_assignState();
}

class _S_view_assignState extends State<S_view_assign> {
  final CollectionReference assignment =
      FirebaseFirestore.instance.collection('assignment');
  final CollectionReference teacher =
      FirebaseFirestore.instance.collection('teacher');
  final CollectionReference student =
      FirebaseFirestore.instance.collection('student');
  final CollectionReference uploadedAssignment =
      FirebaseFirestore.instance.collection('uploaded_assignment');

  late String department = '';
  late DocumentSnapshot studentDoc;
  List<DocumentSnapshot> assignments = [];

  @override
  void initState() {
    super.initState();
    fetchStudentDepartment();
    loadAssignments();
  }

  void loadAssignments() async {
    try {
      QuerySnapshot assignmentSnapshot =
          await assignment.where('student_id', isEqualTo: widget.studID).get();

      print('Query Snapshot Documents: ${assignmentSnapshot.docs}');

      if (mounted) {
        setState(() {
          assignments = assignmentSnapshot.docs;
        });
      }
    } catch (e) {
      print('Error loading assignments: $e');
    }
  }

  void fetchStudentDepartment() async {
    try {
      studentDoc = await student.doc(widget.studID).get();

      if (studentDoc.exists) {
        var departmentValue = studentDoc.get('dept');

        if (departmentValue != null) {
          setState(() {
            department = departmentValue;
          });
        } else {
          print(
              'Field "dept" does not exist or is null in the document with ID: ${widget.studID}');
        }
      } else {
        print('Student not found with ID: ${widget.studID}');
      }
    } catch (e) {
      print('Error fetching student details: $e');
    }
  }

  Future<bool> checkAssignmentStatus(
      String assignmentId, String studentId) async {
    try {
      QuerySnapshot querySnapshot = await uploadedAssignment
          .where('assign_id', isEqualTo: assignmentId)
          .where('student_id', isEqualTo: studentId)
          .get();

      print(
          'Query Snapshot Documents for assignment ID $assignmentId and student ID $studentId: ${querySnapshot.docs}');

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot uploadedAssignmentDoc = querySnapshot.docs.first;

        print(
            'Document Data for assignment ID $assignmentId: ${uploadedAssignmentDoc.data()}');

        var data = uploadedAssignmentDoc.data() as Map<String, dynamic>? ?? {};

        var statusField = data['status'];

        return statusField == 'uploaded';
      } else {
        print(
            'No document found for assignment ID $assignmentId and student ID $studentId');
        return false;
      }
    } catch (e) {
      print('Error checking status field: $e');
      return false;
    }
  }

  Future<String> getUploadedAssignmentDocID(String assignID) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('uploaded_assignment')
          .where('assign_id', isEqualTo: assignID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String docID = querySnapshot.docs.first.id;
        print(
            'Found document for assignment ID $assignID, Document ID: $docID');
        return docID;
      } else {
        print('No document found for assignment ID $assignID');
        return '';
      }
    } catch (e) {
      print('Error getting uploaded assignment document ID: $e');
      return '';
    }
  }

  Future<String> getAssignmentStatus(
      String assignmentId, String studentId) async {
    try {
      QuerySnapshot querySnapshot = await uploadedAssignment
          .where('assign_id', isEqualTo: assignmentId)
          .where('student_id', isEqualTo: studentId)
          .get();

      print(
          'Query Snapshot Documents for assignment ID $assignmentId and student ID $studentId: ${querySnapshot.docs}');

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot uploadedAssignmentDoc = querySnapshot.docs.first;

        print(
            'Document Data for assignment ID $assignmentId: ${uploadedAssignmentDoc.data()}');

        var data = uploadedAssignmentDoc.data() as Map<String, dynamic>? ?? {};

        var statusField = data['status'];

        return statusField ?? '';
      } else {
        return '';
      }
    } catch (e) {
      print('Error checking status field: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Assignments",
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
      body: StreamBuilder(
        stream: teacher.where('dept', isEqualTo: department).snapshots(),
        builder: (context, AsyncSnapshot teacherSnapshot) {
          if (teacherSnapshot.hasData) {
            var teacherDocs = teacherSnapshot.data.docs;

            print('Teacher Documents: $teacherDocs');

            var teacherIds = teacherDocs.map((doc) => doc.id).toList();

            return StreamBuilder(
              stream: assignment
                  .where('teacher_id',
                      whereIn: teacherIds.isNotEmpty ? teacherIds : [''])
                  .snapshots(),
              builder: (context, AsyncSnapshot assignmentSnapshot) {
                if (assignmentSnapshot.hasData) {
                  assignments = assignmentSnapshot.data.docs;

                  return ListView.builder(
                    itemCount: assignments.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot assignsnap = assignments[index];

                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 230,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 239, 239, 239),
                                  blurRadius: 10,
                                  spreadRadius: 15,
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Topic: ${assignsnap['topic']}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Description: ${assignsnap['description']}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Deadline: ${assignsnap['deadline']}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: FutureBuilder<String>(
                                        future: getAssignmentStatus(
                                            assignsnap.id, widget.studID),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            String assignmentStatus =
                                                snapshot.data ?? '';

                                            print(
                                              'Assignment ID: ${assignsnap.id}, Status: $assignmentStatus',
                                            );

                                            return ElevatedButton(
                                              style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                padding:
                                                    MaterialStateProperty.all(
                                                  EdgeInsets.only(
                                                    left: 50,
                                                    right: 50,
                                                    top: 10,
                                                    bottom: 10,
                                                  ),
                                                ),
                                                foregroundColor:
                                                    MaterialStateProperty.all(
                                                  Color.fromARGB(
                                                      255, 255, 255, 255),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  Color.fromARGB(
                                                      255, 2, 123, 40),
                                                ),
                                                textStyle:
                                                    MaterialStateProperty.all(
                                                  TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              onPressed: assignmentStatus ==
                                                      'checked'
                                                  ? null // Disable the button if the assignment is checked
                                                  : () async {
                                                      if (assignmentStatus ==
                                                          'uploaded') {
                                                        print(
                                                          'Pressed Edit Assignment button for assignID: ${assignsnap.id}',
                                                        );

                                                        String
                                                            uploadedAssignmentDocID =
                                                            await getUploadedAssignmentDocID(
                                                                assignsnap.id);
                                                        print(
                                                          'Fetched uploadedAssignmentDocID: $uploadedAssignmentDocID',
                                                        );

                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                S_edit_assign(
                                                              assignID:
                                                                  assignsnap.id,
                                                              uploadedAssignmentDocID:
                                                                  uploadedAssignmentDocID,
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        print(
                                                          'Pressed Upload Assignment button for assignID: ${assignsnap.id}',
                                                        );

                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                S_upload_assign(
                                                              studID: widget
                                                                  .studID,
                                                              assignID:
                                                                  assignsnap.id,
                                                              onAssignmentUploaded:
                                                                  () {
                                                                loadAssignments();
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                              child: Text(
                                                assignmentStatus == 'checked'
                                                    ? "Assignment Checked"
                                                    : assignmentStatus ==
                                                            'uploaded'
                                                        ? "Edit Assignment"
                                                        : "Upload Assignment",
                                              ),
                                            );
                                          } else {
                                            return CircularProgressIndicator();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
