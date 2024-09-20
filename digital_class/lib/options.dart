import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Options extends StatefulWidget {
  const Options({Key? key}) : super(key: key);

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 2, 123, 40),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 300,
              margin: EdgeInsets.only(bottom: 10.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Card(
                  shadowColor: const Color.fromARGB(255, 255, 255, 255),
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30, top: 20),
                    child: Column(
                      children: [
                        ListTile(
                          trailing: Container(
                            height: 200,
                            width: 220,
                            child: Lottie.network(
                              'https://lottie.host/80fdd714-e593-4f5f-8eb5-f8598f0cf4d3/ky7FzFOeEO.json',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 175),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            'Teacher', // Your text here
                            style: TextStyle(
                              color: Color.fromARGB(255, 2, 123, 40),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 70,
            ),
            Container(
              height: 300,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/stud_reg');
                },
                child: Card(
                  shadowColor: const Color.fromARGB(255, 255, 255, 255),
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25, top: 20),
                    child: Column(
                      children: [
                        ListTile(
                          trailing: Container(
                            height: 200,
                            width: 220,
                            child: Lottie.network(
                              'https://lottie.host/1b23b9c4-14b6-4836-b812-c7f420f62d39/AEFqX7l9rE.json',
                              fit: BoxFit.cover,
                            ),
                          ),
                          onTap: () {
                            print('Card 2 tapped');
                          },
                        ),
                        SizedBox(height: 170),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            'Student',
                            style: TextStyle(
                              color: Color.fromARGB(255, 2, 123, 40),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
