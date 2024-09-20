import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:lottie/lottie.dart';

class S_upload_assign extends StatefulWidget {
  final String studID;
  final String assignID;
   final VoidCallback onAssignmentUploaded; 

  const S_upload_assign({
    Key? key,
    required this.studID,
    required this.assignID,
    required this.onAssignmentUploaded,
  }) : super(key: key);

  

  State<S_upload_assign> createState() => _S_upload_assignState();
}

class _S_upload_assignState extends State<S_upload_assign> {
  File? selectedFile;
  bool isUploading = false;
  bool _isMounted = false;

  @override
   void initState() {
    super.initState();
    _isMounted = true;
  }

    @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> uploadAssignment(DocumentSnapshot studentDoc) async {
    setState(() {
      isUploading = true;
    });

    if (selectedFile != null) {
      try {
        // Get file name without extension
        String fileName = selectedFile!.path.split('/').last;
        String fileNameWithoutExtension = fileName.split('.').first;

        // Convert file to bytes
        List<int> fileBytes = selectedFile!.readAsBytesSync();

        // Encode file bytes as base64
        String base64String = base64Encode(fileBytes);

        // Reference to the uploaded_assignment collection
        CollectionReference uploadedAssignment =
            FirebaseFirestore.instance.collection('uploaded_assignment');

        // Store assignment details in Firestore
        await uploadedAssignment.add({
          'student_id': widget.studID,
          'rollno': studentDoc.get('rollno'),
          'assign_id': widget.assignID,
          'file_name': fileNameWithoutExtension,
          'file_data': base64String,
          'status': 'uploaded',
          'timestamp': FieldValue.serverTimestamp(),
        });
// Adjust the duration as needed

      print('Assignment uploaded successfully.');

      widget.onAssignmentUploaded();
await Future.delayed(Duration(milliseconds: 500)); // Adjust the duration as needed
Navigator.pop(context);

      
      } catch (e) {
        print('Error uploading assignment: $e');
      } finally {
       if (_isMounted) {
          setState(() {
            isUploading = false;
          });
        }
      }
    } else {
      print('No file selected for upload.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Upload Assignment",
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
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 2, 123, 40),
                    width: 3,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 68, 187, 82),
                    width: 3,
                  ),
                ),
                labelText: "File Upload",
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 2, 123, 40),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () {
                    pickFile();
                  },
                ),
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 2, 123, 40),
                ),
              ),
              readOnly: true,
              controller: TextEditingController(
                text: selectedFile != null
                    ? 'Uploading: ${selectedFile!.path.split('/').last}'
                    : 'No file uploaded',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
                padding: MaterialStateProperty.all(EdgeInsets.only(
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
                textStyle: MaterialStateProperty.all(TextStyle(
                  fontSize: 15,
                )),
              ),
              onPressed: () async {
                // Fetch student details before uploading
                DocumentSnapshot studentDoc = await FirebaseFirestore.instance
                    .collection('student')
                    .doc(widget.studID)
                    .get();
               
                uploadAssignment(studentDoc);
              },
              child: Text("Upload File"),
            ),
            // SizedBox(height: 30),
           Visibility(
              visible: isUploading,
              child: SizedBox(
                height: 150,
                width: 150,
                child: Lottie.network(
                  'https://lottie.host/704c1fb7-c527-4dfd-951f-39e0ee380adf/55xQtad6jT.json',
                  repeat: true,
                  
                ),
              ),
           )
          ],
        ),
      ),
    );
  }
}
