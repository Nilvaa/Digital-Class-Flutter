import 'dart:io';
import 'dart:convert';
import 'package:digital_class/teacher/te_edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class T_profile extends StatefulWidget {
  final String tid;

  const T_profile({
    Key? key,
    required this.tid,
  }) : super(key: key);

  @override
  State<T_profile> createState() => _T_profileState();
}

class _T_profileState extends State<T_profile> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _teacherDetails;
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _teacherDetails = fetchTeacherDetails();
    _loadImage();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchTeacherDetails() async {
    return FirebaseFirestore.instance
        .collection('teacher')
        .doc(widget.tid)
        .get();
  }

  Future<void> _getImageFromGallery() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _processImage(File(pickedFile.path));
    }
  }

  Future<void> _processImage(File image) async {
    List<int> imageBytes = await image.readAsBytes();
    Uint8List uint8listImageBytes = Uint8List.fromList(imageBytes);

    List<int> compressedImage = await FlutterImageCompress.compressWithList(
      uint8listImageBytes,
      minHeight: 1920,
      minWidth: 1080,
      quality: 80,
    );

    String base64Image = base64Encode(compressedImage);

    String documentID = widget.tid;

    await FirebaseFirestore.instance
        .collection('teacher')
        .doc(documentID)
        .update({'teac_pic': base64Image});

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('teac_pic_$documentID', image.path);

    setState(() {
      _image = image;
      _loadTeacherDetails();
    });

    print('Image uploaded successfully');
  }

  void _deleteImage() async {
  String documentID = widget.tid;

  await FirebaseFirestore.instance
      .collection('teacher')
      .doc(documentID)
      .update({'teac_pic': ''});

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('teac_pic_$documentID');

  setState(() {
    _image = null; // Set _image to null to display the person icon
    _loadTeacherDetails(); // Load the image to update the state
  });

  print('Image deleted successfully');
}


  void _loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedImage = prefs.getString('teac_pic_${widget.tid}');
    if (storedImage != null) {
      setState(() {
        _image = File(storedImage);
      });
    }
  }

  void _loadTeacherDetails() {
    setState(() {
      _teacherDetails = fetchTeacherDetails();
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

  void _captureImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _processImage(File(pickedFile.path));
    }
  }

  Widget _buildImageSection() {
    return Positioned(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Teacher Profile",
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
              _buildImageSection(),
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
                      onPressed: () {
                        if (_image != null && _image!.path.isNotEmpty) {
                          _deleteImage();
                        } else {
                          _showImageOptions();
                        }
                      },
                      icon: Icon(
                        _image != null && _image!.path.isNotEmpty
                            ? Icons.delete
                            : Icons.edit,
                        color: Color.fromARGB(255, 2, 123, 40),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 130,
                left: 210,
                child: GestureDetector(
                  onTap: () {
                    if (_image != null && _image!.path.isNotEmpty) {
                      _deleteImage();
                    } else {
                      _showImageOptions();
                    }
                  },
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
                        onPressed:
                            null, // onPressed is handled by the GestureDetector
                        icon: Icon(
                          _image != null && _image!.path.isNotEmpty
                              ? Icons.delete
                              : Icons.edit,
                          color: Color.fromARGB(255, 2, 123, 40),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 70, top: 190),
                child: FutureBuilder(
                  future: _teacherDetails,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox.shrink();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      var teacherData = snapshot.data!.data();
                      var teacherName = teacherData?['uname'] ?? 'N/A';
                      return Text(
                        teacherName,
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
                  future: _teacherDetails,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox.shrink();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      var teacherData = snapshot.data!.data();
                      return Card(
                        color: Colors.white,
                        elevation: 5,
                        margin: EdgeInsets.all(16),
                        child: Padding(
                          padding: EdgeInsets.all(25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                '${teacherData?['email'] ?? 'N/A'}',
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
                                '${teacherData?['dept'] ?? 'N/A'}',
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
                                '${teacherData?['course'] ?? 'N/A'}',
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
                                    var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => T_edit_profile(teID: widget.tid),
                                      ),
                                    );

                                    if (result != null && result is bool && result) {
                                      _loadTeacherDetails();
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
