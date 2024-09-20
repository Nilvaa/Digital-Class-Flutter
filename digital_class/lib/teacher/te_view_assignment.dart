import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Te_view_assign extends StatefulWidget {
  final String teacherId;
  const Te_view_assign({Key? key, required this.teacherId}) : super(key: key);

  @override
  State<Te_view_assign> createState() => _Te_view_assignState();
}

class _Te_view_assignState extends State<Te_view_assign> {
  final CollectionReference assignment =
      FirebaseFirestore.instance.collection('assignment');

  void delete_assign(id) {
    assignment.doc(id).delete();
    Fluttertoast.showToast(
          msg: "Assignment Deleted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color.fromARGB(255, 6, 67, 26),
          textColor: Color.fromARGB(255, 255, 255, 255),
          fontSize: 16.0,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Recent Assignments",
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
              ))
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
        elevation: 20,
      ),
      body: StreamBuilder(
        stream: assignment
            .where('teacher_id', isEqualTo: widget.teacherId)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot assignsnap = snapshot.data.docs[index];
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
                          ]),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Topic: ${assignsnap['topic']}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
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
                                    foregroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 2, 123, 40),
                                    ),
                                    textStyle:
                                        MaterialStateProperty.all(TextStyle(
                                      fontSize: 15,
                                    )),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/t_edit_assign',
                                        arguments: {
                                          'topic': assignsnap['topic'],
                                          'teacher_id':
                                              assignsnap['teacher_id'],
                                          'description':
                                              assignsnap['description'],
                                          'deadline': assignsnap['deadline'],
                                          'a_id': assignsnap.id,
                                        });
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
                                    foregroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 2, 123, 40),
                                    ),
                                    textStyle:
                                        MaterialStateProperty.all(TextStyle(
                                      fontSize: 15,
                                    )),
                                  ),
                                  onPressed: () {
                                    delete_assign(assignsnap.id);
                                  },
                                  child: Text("Delete"),
                                  
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
          }
          return Container();
        },
      ),
    );
  }
}
