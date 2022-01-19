

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pakfiver/model/gigModel.dart';
import 'package:pakfiver/pages/My_Gigs.dart';
import 'package:pakfiver/provider/gigprovider.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

class EditGig extends StatefulWidget {
  GigModel gigData;

  EditGig({required this.gigData});

  @override
  _EditGigState createState() => _EditGigState();
}

class _EditGigState extends State<EditGig> {
  bool _isLoading = false;
  File? selectedImage;
  final picker = ImagePicker();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  late GigProvider _gigProvider;
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
  late String imgUrl=widget.gigData.ImgUrl,title=widget.gigData.title,price=widget.gigData.price,desc=widget.gigData.desc,skilss=widget.gigData.skill;
  // Update Data
  updateGig() async {

      if (formKey.currentState!.validate() && selectedImage!=null) {

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
                "skill":skilss,
                'userImage': widget.gigData.userImage,
                'userName': widget.gigData.userName,
                "userUid":widget.gigData.uid,
                'DateTime': DateTime.now().toIso8601String(),
              };

              /// Add Data to Firestore
              _gigProvider.UpdateGig(gigMap,widget.gigData.uid).then((result) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => My_Gigs()));
              });
            } catch (onError) {
              print("Error");
            }
          });
          // var downloadUrl =
          //     await (await task.whenComplete(() => null)).ref.getDownloadURL();

        } else {}
      }

    else {
      if (formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        Map<String, dynamic> gigMap = {
          "imgUrl":imgUrl,
          "price": price,
          "title": title,
          "desc": desc,
          "skill":skilss,
          'userImage': widget.gigData.userImage,
          'userName': widget.gigData.userName,
          "userUid":widget.gigData.uid,
          'DateTime': DateTime.now().toIso8601String(),
        };
        _gigProvider.UpdateGig(gigMap,widget.gigData.uid).then((value) {
          print('Data is uploaded');
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>My_Gigs()));
        });
      }
    }

  }
  @override
  Widget build(BuildContext context) {
    _gigProvider = Provider.of(context);
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color.fromARGB(2000, 34, 116, 135),
        elevation: 8.0,
        title: Text(
          "Edit Gig",
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: FlatButton(
              onPressed: () {
                 updateGig();
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
      // drawer: MyDrawer(
      //   userProvider: _userData,
      // ),
      body: _isLoading==true?Center(child: Container(
        child: CircularProgressIndicator(),
      ),) :
      Container(
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () {
                     getImage();
                  },
                  child:selectedImage!=null?
                  Container(
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
                  ):
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 170,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        widget.gigData.ImgUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ),
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
                             'Choose a name for your project',
                              style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              initialValue: widget.gigData.title,
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
                                setState(() {
                                  title = val;
                                });
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
                              initialValue: widget.gigData.price,
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
                                setState(() {
                                  price = val;
                                });
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
                              initialValue: widget.gigData.desc,
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
                                setState(() {
                                  desc = val;
                                });
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
                            Text(
                              'What skills you have',
                              style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10.0,),
                            TextFormField(
                              initialValue: widget.gigData.skill,
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
                               setState(() {
                                 skilss=val;
                               });
                              },
                              validator: (val) {
                                return val!.isEmpty || val.length < 10
                                    ? "Enter skills"
                                    : null;
                              },
                            ),
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
