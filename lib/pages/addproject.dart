import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pakfiver/pages/drawer.dart';
import 'package:pakfiver/pages/notification.dart';
import 'package:pakfiver/provider/gigprovider.dart';
import 'package:pakfiver/provider/requesrProvider.dart';
import 'package:pakfiver/provider/userDataProvider.dart';
import 'package:pakfiver/provider/usermode.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

import 'home.dart';

class Addproject extends StatefulWidget {
  const Addproject({Key? key}) : super(key: key);

  @override
  _AddprojectState createState() => _AddprojectState();
}

class _AddprojectState extends State<Addproject> {
  late UserMode userMode;
  late userData _userData;
  bool _isLoading = false;
  File? selectedImage;
  final picker = ImagePicker();
  String price = '', title = '', desc = '',skill='';
  late GigProvider _gigProvider;
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  // Get Image from Gallery
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  late RequestProvider requestProvider;
  // Upload image to Cloud Storage then Add Data To Firestore
  uploadBlog() async {
    if(userMode.status==true){
      if (formKey.currentState!.validate() && selectedImage != null) {
        if (selectedImage != null) {
          setState(() {
            _isLoading = true;
          });

          /// uploading image to firebase storage
          Reference firebaseStorageRef = FirebaseStorage.instance
              .ref()
              .child("GigImages")
              .child("${randomAlphaNumeric(9)}.jpg");

          final UploadTask task = firebaseStorageRef.putFile(selectedImage);

          task.whenComplete(() async {
            try {
              var downloadURL = await firebaseStorageRef.getDownloadURL();
              print("this is url $downloadURL");
              Map<String, dynamic> gigMap = {
                "imgUrl": downloadURL,
                "price": price,
                "title": title,
                "desc": desc,
                "skill":skill,
                'userImage': _userData.currentUserData.userImage,
                'userName': _userData.currentUserData.firstName,
                "userUid":_userData.currentUserData.uid,
                'DateTime': DateTime.now().toIso8601String(),
              };

              /// Add Data to Firestore
              _gigProvider.addData(gigMap).then((result) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Home()));
              });
            } catch (onError) {
              print("Error");
            }
          });
          // var downloadUrl =
          //     await (await task.whenComplete(() => null)).ref.getDownloadURL();

        } else {}
      }
      //
      // else{
      //   if(formKey.currentState!.validate()){
      //     setState(() {
      //       _isLoading=true;
      //     });
      //     Map<String, dynamic> gigMap = {
      //
      //       "price": price,
      //       "title": title,
      //       "desc": desc,
      //       "userUid":_userData.currentUserData.uid,
      //       'DateTime': DateTime.now().toIso8601String(),
      //     };
      //   }
      // }
    }
    else {
      if (formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        Map<String, dynamic> gigMap = {
          "price": price,
          "title": title,
          "desc": desc,
          "userImage":_userData.currentUserData.userImage,
          "userName":_userData.currentUserData.firstName,
          "userUid":"${randomAlphaNumeric(9)}${_userData.currentUserData.uid}",
          'DateTime': DateTime.now().toIso8601String(),
        };
        requestProvider.addData(gigMap).then((value) {
          print('Data is uploaded');
         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home()));
        });
      }
    }

  }

  @override
  Widget build(BuildContext context) {
     userMode=Provider.of(context);
    _gigProvider = Provider.of(context);
    _userData = Provider.of(context);
    requestProvider=Provider.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color.fromARGB(2000, 34, 116, 135),
        elevation: 8.0,
        title: Text(
          userMode.status==true?"Add Gig":'Post Request',
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: FlatButton(
              onPressed: () {
                uploadBlog();
              },
              child: Icon(
                Icons.file_upload,
                color: Colors.white,
                size: 28.0,
              ),
            ),
          ),
        ],
      ),
      drawer: MyDrawer(
        userProvider: _userData,
      ),
      body: _isLoading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
              child: ListView(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                     userMode.status==true? GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: selectedImage != null
                            ? Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                height: 170,
                                width: MediaQuery.of(context).size.width,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                height: 170,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.black,
                                  size: 50.0,
                                ),
                              ),
                      ):Container(),
                      SizedBox(
                        height: 8.0,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: <Widget>[
                            Form(
                              key: formKey,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userMode.status==true?'Choose a name for your project':'Choose title of developer you need',
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "Project Title",
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueGrey),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blueGrey,
                                                width: 2.0))),
                                    onChanged: (val) {
                                      title = val;
                                    },
                                    validator: (val) {
                                      return val!.isEmpty || val.length < 6
                                          ? "Enter Title  6+ characters"
                                          : null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'Enter Price',
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold),
                                  ),

                                  SizedBox(
                                    height: 10.0,
                                  ),


                                  TextFormField(
                                    cursorColor:
                                        Color.fromARGB(2000, 34, 116, 135),
                                    decoration: InputDecoration(
                                        hintText: "Price",
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueGrey),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blueGrey,
                                                width: 2.0))),
                                    onChanged: (val) {
                                      price = val;
                                    },
                                    validator: (val) {
                                      return val!.isEmpty || val.length < 3
                                          ? "Enter 2+ Digits"
                                          : null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'Tell us more about your project',
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  TextFormField(
                                    maxLines: 7,
                                    maxLengthEnforced: true,
                                    decoration: InputDecoration(
                                        hintText: "Description",
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueGrey),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blueGrey,
                                                width: 2.0))),
                                    onChanged: (val) {
                                      desc = val;
                                    },
                                    validator: (val) {
                                      return val!.isEmpty || val.length < 10
                                          ? "Enter Description 10+ characters"
                                          : null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  userMode.status==true?Text(
                                    'What skills you have',
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold),
                                  ):Container(),
                                  SizedBox(height: 10.0,),
                                  userMode.status==true?TextFormField(
                                    maxLines: 2,
                                    maxLengthEnforced: true,
                                    decoration: InputDecoration(
                                        hintText: "SKills",
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueGrey),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blueGrey,
                                                width: 2.0))),
                                    onChanged: (val) {
                                      skill= val;
                                    },
                                    validator: (val) {
                                      return val!.isEmpty || val.length < 10
                                          ? "Enter skills"
                                          : null;
                                    },
                                  ):Container(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
