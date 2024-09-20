import 'package:digital_class/dummytest/edit_teach_details.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Viewteacher extends StatefulWidget {
  const Viewteacher({super.key});

  @override
  State<Viewteacher> createState() => _ViewteacherState();
}

class _ViewteacherState extends State<Viewteacher> {
  final CollectionReference teacher =
      FirebaseFirestore.instance.collection('teacher');

  void delete_teac(id) {
    teacher.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: teacher.orderBy('uname').snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot teachersnap = snapshot.data.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 239, 239, 239),
                              blurRadius: 10,
                              spreadRadius: 15,
                            )
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              child: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 2, 123, 40),
                                radius: 28,
                                child: Text(
                                  teachersnap['course'],
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                teachersnap['uname'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                teachersnap['pass'].toString(),
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                teachersnap['email'].toString(),
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                teachersnap['dept'].toString(),
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/edit',
                                      arguments: {
                                        'uname': teachersnap['uname'],
                                        'pass': teachersnap['pass'],
                                        'email': teachersnap['email'],
                                        'dept': teachersnap['dept'],
                                        'course': teachersnap['course'],
                                        'id': teachersnap.id,
                                      });
                                },
                                icon: Icon(Icons.edit),
                                iconSize: 30,
                                color: Color.fromARGB(255, 2, 123, 40),
                              ),
                              IconButton(
                                onPressed: () {
                                  delete_teac(teachersnap.id);
                                },
                                icon: Icon(Icons.delete),
                                iconSize: 30,
                                color: Color.fromARGB(255, 2, 123, 40),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
