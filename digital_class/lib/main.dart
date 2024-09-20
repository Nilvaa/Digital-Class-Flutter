import 'dart:io';
import 'package:digital_class/login/login.dart';
import 'package:digital_class/options.dart';
import 'package:digital_class/splash.dart';
import 'package:digital_class/student/st_home.dart';
import 'package:digital_class/student/st_view_assign.dart';
import 'package:digital_class/student/stud_reg.dart';
import 'package:digital_class/teacher/te_edit_class.dart';
import 'package:digital_class/teacher/te_profile.dart';
import 'package:digital_class/teacher/te_register.dart';
import 'package:digital_class/teacher/te_add_assignment.dart';
import 'package:digital_class/teacher/te_edit_assign.dart';
import 'package:digital_class/teacher/te_view_assignment.dart';
import 'package:digital_class/teacher/te_view_stud.dart';
import 'package:digital_class/teacher/teach_home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "IzaSyB0aZVCqrZAETmAKTEFBPwyJ4qnelptlLc",
              appId: "1:1022636922779:android:312d7fba6b00e43ed2f33e",
              messagingSenderId: "1022636922779",
              projectId: "digitalclass-52dc8"),
        )
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Class Room',
      routes: {
        '/': (context) => Splash(),
        '/opt': (context) => Options(),
        '/register': (context) => Register(),
        '/stud_reg': (context) => St_register(),
        '/view_stud': (context) => T_view_stud(tid: '',),
        '/t_profile': (context) => T_profile(tid: '',),
        '/stud_home': (context) => S_home(),
        '/t_edit_assign': (context) => const Te_edit_assign(),
        '/t_edit_class': (context) => const T_edit_class(clId: '',teacherID: ''),
        '/teac_home': (context) => T_home(tid: ''),
        '/t_view_assign': (context) => Te_view_assign(teacherId: '',),
        '/add_assignment': (context) => T_add_assign(t_id: '',),
        '/st_view_assign':(context) => S_view_assign(studID: ''),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme:
            GoogleFonts.expletusSansTextTheme(Theme.of(context).textTheme),
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 2, 123, 40)),
        useMaterial3: true,
        primarySwatch: Colors.lightGreen,
      ),

      // home: const Viewteacher(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
