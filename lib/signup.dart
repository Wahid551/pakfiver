import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  var selectgender;
  var selectcity;
  var gender = ["Male", "Female", "Others"];
  var city = ["Burewala", "Vehari", "Melsi"];
  final _formKey = GlobalKey<FormState>();
  var firstname = "";
  var lastname = "";
  var email = "";
  var Gender = "";
  var City = "";
  var dateofbirth = "";
  var password = "";
  var confirmpassword = "";

  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final GenderController = TextEditingController();
  final CityController = TextEditingController();
  final dateofbirthController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    GenderController.dispose();
    CityController.dispose();
    dateofbirthController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }

  registration() async {
    if (password == confirmpassword) {
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
      try {
        UserCredential result= await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        User? user = result.user;
           _firestore.collection("UserRecord").doc(FirebaseAuth.instance.currentUser.uid).set({
             "City":selectcity,
             "DoB":dateofbirthController.text,
             "Email":emailController.text,
             "FirstName":firstnameController.text,
             "Gender":selectgender,
             "LastName":lastnameController.text,
             "userImage":"no image",
             "phone":'92',
             "userUid":user.uid,
           });

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Registered Successfully. Please Login..",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password Provided is too Weak",
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
            ),
          );
        }
        else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account Already exists",
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            "Password and Confirm Password doesn't match",
            style: TextStyle(fontSize: 16.0, color: Colors.black),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.cyan[800],
        elevation: 8.0,
        centerTitle: true,
        title: Text(
          "Register",
        ),
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.reply,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 20.0, 0.0, 0.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'First Name',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.grey,
                          ),
                          icon: Icon(
                            FontAwesomeIcons.user,
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      controller: firstnameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter First Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 7.0, 0.0, 0.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Last Name ',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.grey,
                          ),
                          icon: Icon(
                            FontAwesomeIcons.user,
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      controller: lastnameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Last Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 7.0, 0.0, 0.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Email ',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat', color: Colors.grey),
                          icon: Icon(
                            FontAwesomeIcons.envelope,
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Email';
                        } else if (!value.contains('@')) {
                          return 'Please Enter Valid Email';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.fromLTRB(30.0, 7.0, 8.0, 0.0),
                    child: DropdownButton(
                      hint: Text(
                        'Select The Gender',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      isExpanded: true,
                      icon: Icon(
                        Icons.person,
                        size: 20.09,
                      ),
                      iconSize: 40.0,
                      value: selectgender,
                      onChanged: (newvalue) {
                        setState(() {
                          selectgender = newvalue;
                        });
                      },
                      items: gender.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.fromLTRB(30.0, 7.0, 8.0, 0.0),
                    child: DropdownButton(
                      hint: Text(
                        'Enter Your City',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      isExpanded: true,
                      icon: Icon(
                        Icons.location_city,
                        size: 20.09,
                      ),
                      iconSize: 40.0,
                      value: selectcity,
                      onChanged: (newValue) {
                        setState(() {
                          selectcity = newValue;
                        });
                      },
                      items: city.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 7.0, 0.0, 0.0),
                    child: TextFormField(
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                          labelText: 'Date Of Birth ',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat', color: Colors.grey),
                          icon: Icon(
                            FontAwesomeIcons.calendar,
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      controller: dateofbirthController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Date of Birth';
                        }

                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 7.0, 0.0, 0.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Password ',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat', color: Colors.grey),
                          icon: Icon(
                            FontAwesomeIcons.lock,
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Password';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 7.0, 0.0, 0.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Confirm Password ',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat', color: Colors.grey),
                          icon: Icon(
                            FontAwesomeIcons.userLock,
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      controller: confirmpasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Password';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 25.0),
                  Center(
                    child: Container(
                      height: 50.0,
                      width: 340.0,
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(100.0)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              firstname = firstnameController.text;
                              lastname = lastnameController.text;
                              email = emailController.text;
                              dateofbirth = dateofbirthController.text;
                              password = passwordController.text;
                              confirmpassword = confirmpasswordController.text;
                            });
                            registration();
                          }
                        },
                        color: Colors.cyan[800],
                        child: Text(
                          'Signup',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.cyan[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
