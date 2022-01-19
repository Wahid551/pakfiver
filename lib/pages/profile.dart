import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pakfiver/pages/drawer.dart';
import 'package:pakfiver/provider/userDataProvider.dart';
import 'package:random_string/random_string.dart';

class MyProfile extends StatefulWidget {
  late userData userProvider;

  MyProfile({required this.userProvider});

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  File? selectedImage;
  final picker = ImagePicker();

  // Get Image from Gallery

  updateData() async {
    if (formkey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: new Row(
                children: [
                  new CircularProgressIndicator(),
                  SizedBox(
                    width: 25.0,
                  ),
                  new Text("Loading, Please wait"),
                ],
              ),
            ),
          );
        },
      );

      if (selectedImage != null) {
        /// uploading image to firebase storage
        Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child("UserImages")
            .child("${randomAlphaNumeric(9)}.jpg");
        final UploadTask task = firebaseStorageRef.putFile(selectedImage);

        task.whenComplete(() async {
          try {
            var downloadURL = await firebaseStorageRef.getDownloadURL();
            print("this is url $downloadURL");

            /// Add Data to Firestore
            widget.userProvider.UpdateData(downloadURL, phone, widget.userProvider.currentUserData.firstName,city);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green.shade900,
                content: Text(
                  "Profile Updated Successfully",
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
              ),
            );
          } catch (onError) {
            print("Error");
          }
        });
      } else {
        /// Add Data to Firestore
        widget.userProvider.UpdateData(
            widget.userProvider.currentUserData.userImage, phone, widget.userProvider.currentUserData.firstName,city);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green.shade900,
            content: Text(
              "Profile Updated Successfully",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      }
    }
  }

  Widget listTile({required IconData icon, required String title}) {
    return Column(
      children: [
        Divider(
          height: 1,
        ),
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          trailing: Icon(Icons.arrow_forward_ios),
        )
      ],
    );
  }

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String name = '';

  String phone = '';

  String city='';

  @override
  Widget build(BuildContext context) {
    var userData = widget.userProvider.currentUserData;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(2000, 34, 116, 135),
        elevation: 0.0,
        title: Text(
          "My Profile",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black45,
          ),
        ),
      ),
      drawer: MyDrawer(
        userProvider: widget.userProvider,
      ),
      body: Stack(
        children: [
          Column(

            children: [
              Container(
                height: 100,
                color: Color.fromARGB(2000, 34, 116, 135),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: ListView(

                    children: [
                      SizedBox(
                        height: 60.0,
                      ),
                      Text(
                        'Personal Information',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: formkey,
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: userData.lastName,
                              cursorColor: Colors.black26,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              validator: (val) {
                                return val!.isEmpty || val.length < 3
                                    ? "Enter Name 3+ characters"
                                    : null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'User Name',
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black))),
                              onChanged: (_val) {
                                setState(() {
                                  name = _val;
                                });
                              },
                            ),
                            TextFormField(
                              initialValue: userData.userEmail,
                              cursorColor: Colors.black26,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              onChanged: (_val) {
                                setState(() {
                                  // email = _val;
                                });
                              },
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val!)
                                    ? null
                                    : "Enter Correct Email";
                              },
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black))),
                            ),
                            TextFormField(
                              initialValue: userData.phone,
                              onChanged: (_val) {
                                setState(() {
                                  phone = _val;
                                });
                              },
                              cursorColor: Colors.black26,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              validator: (val) {
                                return val!.length < 11
                                    ? "Phone # be like 03000000000"
                                    : null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black))),
                            ),
                            TextFormField(
                              initialValue: userData.city,
                              cursorColor: Colors.black26,
                              style:
                              TextStyle(color: Colors.black, fontSize: 16),
                              validator: (val) {
                                return val!.isEmpty || val.length < 3
                                    ? "Enter City "
                                    : null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'City',
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.black)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.black))),
                              onChanged: (_val) {
                                setState(() {
                                  city = _val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              height: 50.0,

                              child: MaterialButton(
                                onPressed: () {
                                  updateData();
                                },
                                child: Text("Update Profile"),
                                color: Colors.green,
                                shape: StadiumBorder(),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 30),
            child: GestureDetector(
              onTap: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: new Row(
                          children: [
                            new CircularProgressIndicator(),
                            SizedBox(
                              width: 25.0,
                            ),
                            new Text("Loading, Please wait"),
                          ],
                        ),
                      ),
                    );
                  },
                );
                final pickedFile =
                    await picker.getImage(source: ImageSource.gallery);

                // ignore: unnecessary_null_comparison
                if (pickedFile != null) {
                  setState(() {
                    selectedImage = File(pickedFile.path);
                  });
                  Navigator.of(context).pop();
                } else {
                  print('No image selected.');
                }
              },
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Color.fromARGB(2000, 34, 116, 135),
                // child: userData.userImage != 'no image'
                child: selectedImage != null
                    ? CircleAvatar(
                        backgroundImage: FileImage(selectedImage!),
                        radius: 45,
                        backgroundColor: Colors.white,
                      )
                    : userData.userImage == 'no image'
                        ? CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.add_a_photo),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(userData.userImage),
                            radius: 45,
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
