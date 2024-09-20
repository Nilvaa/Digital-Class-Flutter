import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class S_marks extends StatefulWidget {
  final String studID;

  const S_marks({Key? key, required this.studID}) : super(key: key);

  @override
  State<S_marks> createState() => _S_marksState();
}

class _S_marksState extends State<S_marks> {
  final CollectionReference uploadedAssignment =
      FirebaseFirestore.instance.collection('uploaded_assignment');
  final CollectionReference assignment =
      FirebaseFirestore.instance.collection('assignment');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Marks",
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
      body: StreamBuilder<QuerySnapshot>(
        stream: uploadedAssignment
            .where('student_id', isEqualTo: widget.studID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No assignments found for the student.'),
            );
          }

          // Display marks, feedback, and assignment description for each checked assignment in cards
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic>? data =
                  document.data() as Map<String, dynamic>?;

              if (data == null) {
                return Text('Data is null for a document.');
              }

              String? assignID = data['assign_id'];

              if (assignID == null) {
                return Text('assign_id is null for a document.');
              }

              // Retrieve assignment details based on assign_id
              return FutureBuilder<DocumentSnapshot>(
                future: assignment.doc(assignID).get(),
                builder: (context, assignmentSnapshot) {
                  if (assignmentSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    // No circular progress indicator needed here
                    return Container();
                  }

                  if (!assignmentSnapshot.hasData ||
                      !assignmentSnapshot.data!.exists) {
                    return Text('Assignment not found');
                  }

                  Map<String, dynamic>? assignmentData =
                      assignmentSnapshot.data!.data() as Map<String, dynamic>?;

                  if (assignmentData == null) {
                    return Text('Assignment data is null.');
                  }

                  String? assignmentTopic = assignmentData['topic'];
                  String? assignmentDescription = assignmentData['description'];
                  String? status = data['status'];

                  if (assignmentTopic == null ||
                      assignmentDescription == null ||
                      status != 'checked') {
                    // Skip this assignment if title, description, or status is null or status is not 'checked'
                    return Container();
                  }

                  // Extract marks and feedback from the uploaded_assignment
                  int? marks = data['marks'];
                  String? feedback = data['feedback'];
                
                  // Display marks and feedback only if they exist
                  List<Widget> details = [
                    Text(
                      'Assignment: $assignmentTopic',
                      style: TextStyle(
                        color: Color.fromARGB(255, 2, 123, 40),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Description: $assignmentDescription',
                      style: TextStyle(
                        color: Color.fromARGB(255, 2, 123, 40),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ];

                  if (marks != null) {
                    details.add(Text(
                      'Marks: $marks',
                      style: TextStyle(
                        color: Color.fromARGB(255, 2, 123, 40),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ));
                  }

                  if (feedback != null) {
                    details.add(Text(
                      'Feedback: $feedback',
                      style: TextStyle(
                        color: Color.fromARGB(255, 2, 123, 40),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ));
                  }

                  // Return a card with assignment details
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Card(
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: details,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
