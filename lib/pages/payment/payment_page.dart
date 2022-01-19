import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class payment_home extends StatefulWidget {
  const payment_home({Key? key}) : super(key: key);

  @override
  _payment_homeState createState() => _payment_homeState();
}

class _payment_homeState extends State<payment_home> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color.fromARGB(2000, 34, 116, 135),
    elevation: 8.0,
    title: Text(
    "Payment",
    ),
        ),

      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: ListView(
          children: [

            Image(image: AssetImage('assets/images/jazcash.png'),height: 180,),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 20.0, 0.0, 0.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Account Holder Name',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.grey,
                          ),
                          icon: Icon(
                            FontAwesomeIcons.user,
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      // controller: firstnameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Account Holder Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 7.0, 0.0, 0.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Account Number',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat', color: Colors.grey),
                          icon: Icon(
                            FontAwesomeIcons.lock,
                          ),

                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      keyboardType: TextInputType.number,
                      // controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Account Number';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 20.0, 0.0, 0.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Purpose of Send Money',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.grey,
                          ),
                          icon: Icon(
                            FontAwesomeIcons.sortUp,
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      // controller: firstnameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Purpose';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 7.0, 0.0, 0.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Enter Receiver phone number',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat', color: Colors.grey),
                          icon: Icon(
                            FontAwesomeIcons.phone,
                          ),

                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          )),
                      // controller: passwordController,
                      keyboardType:TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            MaterialButton(
              padding: EdgeInsets.all(10.0),
              color:  Color.fromARGB(2000, 34, 116, 135),
              onPressed: (){},
              child: Text('Submit Request',style: TextStyle(fontSize: 20.0,color: Colors.white),),
              shape: StadiumBorder(),

            ),
          ],
        )
      ),
    );
  }
}
