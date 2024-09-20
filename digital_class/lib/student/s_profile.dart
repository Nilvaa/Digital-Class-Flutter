import 'dart:io';
import 'dart:convert';
import 'package:digital_class/student/s_edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class S_profile extends StatefulWidget {
  final String studID;

  const S_profile({
    Key? key,
    required this.studID,
  }) : super(key: key);

  @override
  State<S_profile> createState() => _S_profileState();
}

class _S_profileState extends State<S_profile> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _studentDetails;

  File? _image;
  final picker = ImagePicker();
  bool _imageUploaded = false;

  @override
  void initState() {
    super.initState();
    _studentDetails = fetchStudentDetails();
    _loadImageUploadedState();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchStudentDetails() async {
    return FirebaseFirestore.instance
        .collection('student')
        .doc(widget.studID)
        .get();
  }

  Future<void> _getImageFromGallery() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    _processImage(pickedFile);

    // Save the image data locally
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('imageUploaded_${widget.studID}', true);
  }

  Future<void> _processImage(XFile? pickedFile) async {
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _uploadImage();
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> _uploadImage() async {
    if (_image != null) {
      try {
        // Read the file as bytes
        List<int> imageBytes = await _image!.readAsBytes();

        Uint8List uint8listImageBytes = Uint8List.fromList(imageBytes);

        // Compress the image
        List<int> compressedImage = await FlutterImageCompress.compressWithList(
          uint8listImageBytes,
          minHeight: 1920,
          minWidth: 1080,
          quality: 80,
        );

        // Convert to base64
        String base64Image = base64Encode(compressedImage);

        // Reference the document ID using widget.studID
        String documentID = widget.studID;
        print("pro_icccccccccccccccccccccccc");
        print(documentID);
        print('Base64 Image: $base64Image');

        await FirebaseFirestore.instance
            .collection('student')
            .doc(documentID)
            .update({'stud_pic': base64Image});

        // Save the image data locally
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('stud_pic_$documentID', _image!.path);

        setState(() {
          _imageUploaded = true;
        });

        print('Image uploaded successfully');
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  void _deleteImage() async {
    try {
      String documentID = widget.studID;

      // Update the 'stud_pic' field to an empty string in Firestore
      await FirebaseFirestore.instance
          .collection('student')
          .doc(documentID)
          .update({'stud_pic': ''});

      // Remove the image data from local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('stud_pic_$documentID');

      // Set the flag to indicate that the image has been deleted
      setState(() {
        _imageUploaded = false;
        _image = null; // Set _image to null to display the default icon
      });

      // Refresh the student details to reflect the updated image
      setState(() {
        _studentDetails = fetchStudentDetails();
      });

      print('Image deleted successfully');
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  Future<void> _captureImage() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    _processImage(pickedFile);
  }

  Future<String?> _getStoredImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('stud_pic_${widget.studID}');
  }

  void _loadImageUploadedState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? imageUploaded = prefs.getBool('imageUploaded_${widget.studID}');
    if (imageUploaded != null) {
      setState(() {
        _imageUploaded = imageUploaded;
        if (_imageUploaded) {
          _getStoredImage().then((storedImage) {
            if (storedImage != null) {
              setState(() {
                _image = File(storedImage);
              });
            }
          });
        }
      });
    }
  }

  void _loadStudentDetails() {
    // Add logic to refresh student details or fetch updated data
    setState(() {
      _studentDetails = fetchStudentDetails();
    });
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a picture'),
                onTap: () {
                  Navigator.of(context).pop();
                  _captureImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Student Profile",
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
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: 500,
          height: 900,
          child: Stack(
            children: [
              Positioned(
                top: -30,
                left: 105,
                child: SizedBox(
                  height: 270,
                  child: CircleAvatar(
                    child: _image != null
                        ? ClipOval(
                            child: Image.file(
                              _image!,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 90,
                            color: Color.fromARGB(255, 2, 123, 40),
                          ),
                    radius: 75,
                  ),
                ),
              ),
              Positioned(
                top: 130,
                left: 210,
                child: Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color.fromARGB(255, 255, 255, 255),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    child: IconButton(
                      onPressed: _imageUploaded
                          ? _deleteImage // Call delete function if image uploaded
                          : _showImageOptions, // Call edit function otherwise
                      icon: Icon(
                        _imageUploaded
                            ? Icons.delete // Show delete icon if image uploaded
                            : Icons.edit, // Show edit icon otherwise
                        color: Color.fromARGB(255, 2, 123, 40),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 110, top: 190),
                child: FutureBuilder(
                  future: _studentDetails,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox.shrink();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      var studentData = snapshot.data!.data();
                      var studentName = studentData?['uname'] ?? 'N/A';
                      return Text(
                        studentName,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 1.2,
                          color: Color.fromARGB(255, 2, 123, 40),
                        ),
                      );
                    }
                  },
                ),
              ),
              Positioned(
                top: 220,
                left: 30,
                width: 300,
                child: FutureBuilder(
                  future: _studentDetails,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox.shrink();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      var studentData = snapshot.data!.data();
                      return Card(
                        color: Colors.white,
                        elevation: 5,
                        margin: EdgeInsets.all(16),
                        child: Padding(
                          padding: EdgeInsets.all(25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ROLL NUMBER:',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 2, 123, 40),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '${studentData?['rollno'] ?? 'N/A'}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 2, 123, 40),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Text(
                                'EMAIL:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 2, 123, 40),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${studentData?['email'] ?? 'N/A'}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 2, 123, 40),
                                ),
                              ),
                              SizedBox(height: 30),
                              Text(
                                'DEPARTMENT:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 2, 123, 40),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${studentData?['dept'] ?? 'N/A'}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 2, 123, 40),
                                ),
                              ),
                              SizedBox(height: 30),
                              Text(
                                'COURSE:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 2, 123, 40),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${studentData?['course'] ?? 'N/A'}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 2, 123, 40),
                                ),
                              ),
                              SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    padding: MaterialStateProperty.all(
                                      EdgeInsets.only(
                                        left: 50,
                                        right: 50,
                                        top: 10,
                                        bottom: 10,
                                      ),
                                    ),
                                    foregroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 2, 123, 40),
                                    ),
                                    textStyle: MaterialStateProperty.all(
                                      TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    // Navigate to the edit profile page and wait for the result
                                    var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => S_edit_profile(studID: widget.studID),
                                      ),
                                    );

                                    // Check if the result is not null and update the UI
                                    if (result != null && result is bool && result) {
                                      // Perform actions to refresh the UI or fetch updated data
                                      _loadStudentDetails(); // Add a function to refresh student details
                                    }
                                  },
                                  child: Text("EDIT"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
