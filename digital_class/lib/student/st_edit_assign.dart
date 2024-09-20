import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class S_edit_assign extends StatefulWidget {
  final String assignID;
  final String uploadedAssignmentDocID;

  const S_edit_assign({
    Key? key,
    required this.assignID,
    required this.uploadedAssignmentDocID,
  }) : super(key: key);

  @override
  State<S_edit_assign> createState() => _S_edit_assignState();
}

class _S_edit_assignState extends State<S_edit_assign> {
  File? selectedFile;
  bool isUploading = false;
  String? previousFileName;
  String? previousFileData;


  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> fetchPreviousFileData() async {
    try {
      // Fetch the document from the 'uploaded_assignment' collection
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('uploaded_assignment')
          .doc(widget.uploadedAssignmentDocID)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          previousFileName = docSnapshot['file_name'];
          previousFileData = docSnapshot['file_data'];
        });
      } else {
        print('Document not found in Firestore');
      }
    } catch (e) {
      print('Error fetching previous file data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch the previous file data when the widget is initialized
    fetchPreviousFileData();
  }

  String encodeFileToBase64(String path) {
    File file = File(path);
    List<int> fileBytes = file.readAsBytesSync();
    return base64Encode(fileBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Assignment",
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
                    : previousFileName ?? 'Recently Uploaded',
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
                if (selectedFile != null) {
                  setState(() {
                    isUploading = true;
                  });

                  try {
              // Perform your upload logic here...
              String fileData = encodeFileToBase64(selectedFile!.path);

              // Update the timestamp
              DateTime now = DateTime.now();
              String formattedTimestamp =
                  DateFormat('MMMM d, y ' 'at' ' h:mm:ss a z').format(now);

              // Assuming you have an 'uploaded_assignment' collection
              // and you want to update a document with uploadedAssignmentDocID
              await FirebaseFirestore.instance
                  .collection('uploaded_assignment')
                  .doc(widget.uploadedAssignmentDocID)
                  .update({
                'file_name': selectedFile!.path.split('/').last,
                'file_data': fileData,
                'timestamp': formattedTimestamp,
                // Add other fields you want to update
              });

                    setState(() {
                      isUploading = false;
                    });

                    await Future.delayed(Duration(
                        milliseconds: 500)); // Adjust the duration as needed
                    Navigator.pop(context);
                  } catch (e) {
                    print('Error updating Firestore: $e');
                  }
                }
              },
              child: Text("Submit Edit"),
            ),
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
