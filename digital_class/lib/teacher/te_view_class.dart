import 'package:digital_class/teacher/te_edit_class.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class T_view_class extends StatefulWidget {
  final String teacherID;

  const T_view_class({
    Key? key,
    required this.teacherID,
  }) : super(key: key);

  @override
  State<T_view_class> createState() => _T_view_classState();
}

class _T_view_classState extends State<T_view_class> {
  final CollectionReference onlineclass =
      FirebaseFirestore.instance.collection('online_class');

  Future<void> deleteClass(String classId) async {
    try {
      await onlineclass.doc(classId).delete();
      print('Document deleted successfully');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "View Schedules",
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
      body: StreamBuilder(
        stream: onlineclass
            .where('teacher_id', isEqualTo: widget.teacherID)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.docs.length ?? 0,
              itemBuilder: (context, index) {
                var classData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Subject: ${classData['subject']} ',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 2, 123, 40)),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Date: ${classData['date']} ',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 2, 123, 40)),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Time: ${classData['time']}',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 2, 123, 40)),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Meet Link: ${classData['meet_link']}',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 2, 123, 40)),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.only(
                                        left: 50,
                                        right: 48,
                                        top: 10,
                                        bottom: 10,
                                      )),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                        Color.fromARGB(255, 255, 255, 255),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        Color.fromARGB(255, 2, 123, 40),
                                      ),
                                      textStyle:
                                          MaterialStateProperty.all(TextStyle(
                                        fontSize: 15,
                                      )),
                                    ),
                                    onPressed: () {
                                      print(
                                          'online class id: ${snapshot.data!.docs[index].id}');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => T_edit_class(
                                            clId: snapshot.data!.docs[index].id,
                                            teacherID: widget.teacherID,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text("Edit"),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.only(
                                        left: 50,
                                        right: 50,
                                        top: 10,
                                        bottom: 10,
                                      )),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                        Color.fromARGB(255, 255, 255, 255),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        Color.fromARGB(255, 2, 123, 40),
                                      ),
                                      textStyle:
                                          MaterialStateProperty.all(TextStyle(
                                        fontSize: 15,
                                      )),
                                    ),
                                    onPressed: () {
                                      String classId =
                                          snapshot.data!.docs[index].id;
                                      print('online class id: $classId');
                                      deleteClass(classId);
                                    },
                                    child: Text("Delete"),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
