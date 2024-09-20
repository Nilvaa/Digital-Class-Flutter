import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final CollectionReference user =
      FirebaseFirestore.instance.collection('user');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: user.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot usersnap = snapshot.data.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 239, 239, 239),
                            blurRadius: 10,
                            spreadRadius: 15,
                          )
                        ]
                      ),
                      
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 2, 123, 40),
                              radius: 30,
                              
                              ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(usersnap['uname'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),),
                               Text(usersnap['pass'].toString(),
                               style: TextStyle(fontSize: 18),),
                                Text(usersnap['num'].toString(),
                               style: TextStyle(fontSize: 18),)
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(onPressed: (){}, icon: Icon(Icons.edit),
                              iconSize: 30,
                                color:Color.fromARGB(255, 2, 123, 40) ,
                              ),
                               IconButton(onPressed: (){}, icon: Icon(Icons.delete),
                                iconSize: 30,
                                color:Color.fromARGB(255, 2, 123, 40) ,
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
