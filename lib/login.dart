import 'package:pakfiver/forget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pakfiver/pages/buyersHomePage.dart';
import 'package:pakfiver/pages/usermain.dart';
import 'package:pakfiver/provider/gigprovider.dart';
import 'package:pakfiver/provider/usermode.dart';
import 'package:provider/provider.dart';
import 'signup.dart';
import 'forget.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  var email = "";
  var password = "";

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  userLogin() async {
    try {
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
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => usermain(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "No User Found for that Email",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Wrong Password Provided by User",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  late UserMode usrmode;
  Widget build(BuildContext context) {
     usrmode=Provider.of<UserMode>(context);
    bool status=usrmode.status;
    GigProvider _gigProvider=Provider.of<GigProvider>(context);
    _gigProvider.getData();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Container(
                      width: 200,
                      height: 300,
                      child: Image.asset(
                        'assets/images/fiverr.png',
                      )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: new Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'Email ID',
                          errorStyle: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 15.0,
                          ),
                          icon: Icon(
                            FontAwesomeIcons.envelope,
                            color: Colors.teal[700],
                          ),
                        ),
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
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                          autofocus: false,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            errorStyle: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 15.0,
                            ),
                            icon: Icon(
                              FontAwesomeIcons.userLock,
                              color: Colors.teal[700],
                            ),
                          ),
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Password';
                            }
                            return null;
                          }),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Center(
                      child: Container(
                        height: 50.0,
                        width: 350.0,
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(100.0)),
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              setState(
                                () {
                                  email = emailController.text;
                                  password = passwordController.text;
                                },
                              );
                              userLogin();
                            }
                          },
                          color: Colors.cyan[800],
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("New User? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpPage()));
                            },
                            child: Text(
                              "Create Account",
                              style: TextStyle(
                                color: Colors.cyan[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Forget()));
                      },
                      child: Text(
                        "Forget Password",
                        style: TextStyle(
                          color: Colors.cyan[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
