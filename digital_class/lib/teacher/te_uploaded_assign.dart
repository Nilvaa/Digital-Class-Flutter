import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class T_uploaded extends StatefulWidget {
  final String teacherID;

  const T_uploaded({
    Key? key,
    required this.teacherID,
  }) : super(key: key);

  @override
  State<T_uploaded> createState() => _T_uploadedState();
}

class _T_uploadedState extends State<T_uploaded> {
  final CollectionReference assignmentCollection =
      FirebaseFirestore.instance.collection('assignment');
  final CollectionReference uploadedAssignmentCollection =
      FirebaseFirestore.instance.collection('uploaded_assignment');

  late List<Map<String, dynamic>> assignments = [];

  @override
  void initState() {
    super.initState();
    loadAssignments();
  }

  Future<void> loadAssignments() async {
    try {
      QuerySnapshot<Object?> assignmentDocs = await assignmentCollection
          .where('teacher_id', isEqualTo: widget.teacherID)
          .get();

      List<String> assignIds =
          assignmentDocs.docs.map((doc) => doc.id as String).toList();

      assignments = [];

      for (String assignId in assignIds) {
        DocumentSnapshot assignmentDoc =
            await assignmentCollection.doc(assignId).get();

        QuerySnapshot<Object?> uploadedAssignments =
            await uploadedAssignmentCollection
                .where('assign_id', isEqualTo: assignId)
                .where('status', isEqualTo: 'uploaded')
                .get();

        String description =
            assignmentDoc['description'] ?? 'No description available';

        List<Map<String, dynamic>> assignmentList =
            uploadedAssignments.docs.map((uploadedDoc) {
          return {
            ...uploadedDoc.data() as Map<String, dynamic>,
            'assign_id': uploadedDoc.id,
            'description': description,
          };
        }).toList();

        assignments.addAll(assignmentList);
      }
    } catch (e) {
      print('Error loading assignments: $e');
    }

    setState(() {});
  }

  // Helper function to convert dynamic to DateTime
  DateTime convertToDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else {
      return DateTime.now();
    }
  }

  Future<void> displayAssignment(Map<String, dynamic> assignment) async {
    try {
      String fileData = assignment['file_data'];
      Uint8List decodedBytes = base64.decode(fileData);

      DateTime dateTime = convertToDateTime(assignment['timestamp']);

      String path = await createFile(decodedBytes);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text(
              "Assignment Details",
              style: TextStyle(
                color: Color.fromARGB(255, 2, 123, 40),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Container(
            height: 250,
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, 
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "Roll Number: ${assignment['rollno']}",
                    style: TextStyle(
                      color: Color.fromARGB(255, 2, 123, 40),
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "File Name: ${assignment['file_name']}",
                    style: TextStyle(
                      color: Color.fromARGB(255, 2, 123, 40),
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "Date: ${DateFormat('MMMM d, y').format(dateTime)}",
                    style: TextStyle(
                      color: Color.fromARGB(255, 2, 123, 40),
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "Time: ${DateFormat('hh:mm:ss a').format(dateTime)}",
                    style: TextStyle(
                      color: Color.fromARGB(255, 2, 123, 40),
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PDFViewerScreen(decodedBytes),
                          ),
                        );
                      },
                      child: Text("View PDF"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Close"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      print('Error displaying assignment: $e');
    }
  }

  Future<String> createFile(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/temp.pdf').create();
    await file.writeAsBytes(bytes);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Uploaded Assignment",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 2, 123, 40),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
        elevation: 20,
      ),
      body: assignments.isNotEmpty
          ? ListView.builder(
              itemCount: assignments.length,
              itemBuilder: (context, index) {
                final int currentIndex = index; // Store the value of index

                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: Card(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Roll Number: ${assignments[currentIndex]['rollno']}",
                            style: TextStyle(
                              color: Color.fromARGB(255, 2, 123, 40),
                              fontSize: 15,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                          Text(
                            "Topic: ${assignments[currentIndex]['description']}",
                            style: TextStyle(
                              color: Color.fromARGB(255, 2, 123, 40),
                              fontSize: 15,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                          Text(
                            "File Name: ${assignments[currentIndex]['file_name']}",
                            style: TextStyle(
                              color: Color.fromARGB(255, 2, 123, 40),
                              fontSize: 15,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, right: 10),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color.fromARGB(255, 2, 123, 40)),
                                    foregroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                  onPressed: () => displayAssignment(
                                      assignments[currentIndex]),
                                  child: Text("View Assignment"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                ),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color.fromARGB(255, 2, 123, 40)),
                                    foregroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        int marks =
                                            0; // Variable to store marks
                                        String feedback =
                                            ''; // Variable to store feedback

                                        return AlertDialog(
                                          title: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 70),
                                            child: Text(
                                              "Add Marks",
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 2, 123, 40),
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                decoration: InputDecoration(
                                                    labelText: 'Marks',
                                                    labelStyle: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 2, 123, 40),
                                                    )),
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 2, 123, 40),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (value) {
                                                  marks =
                                                      int.tryParse(value) ?? 0;
                                                },
                                              ),
                                              TextField(
                                                decoration: InputDecoration(
                                                    labelText: 'Feedback',
                                                    labelStyle: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 2, 123, 40),
                                                    )),
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 2, 123, 40),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                onChanged: (value) {
                                                  feedback = value;
                                                },
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                if (marks >= 0 &&
                                                    feedback.isNotEmpty) {
                                                  uploadedAssignmentCollection
                                                      .doc(assignments[
                                                              currentIndex]
                                                          ['assign_id'])
                                                      .update({
                                                    'status': 'checked',
                                                    'marks': marks,
                                                    'feedback': feedback,
                                                  }).then((_) {
                                                    loadAssignments();
                                                    Navigator.pop(
                                                        context); // Close the dialog
                                                  });
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 2, 123, 40),
                                                    content: Text(
                                                        'Please enter a valid marks value and feedback.'),
                                                  ));
                                                }
                                              },
                                              child: Text("Save"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text("Add Marks"),
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
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final Uint8List pdfBytes;

  PDFViewerScreen(this.pdfBytes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PDF Viewer",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 2, 123, 40),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
        elevation: 20,
      ),
      body: SfPdfViewer.memory(pdfBytes),
    );
  }
}
