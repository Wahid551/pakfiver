import 'package:flutter/material.dart';

class Terms_Conditions extends StatelessWidget {
  const Terms_Conditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color.fromARGB(2000, 34, 116, 135),
        elevation: 8.0,
        title: Text(
          "PAK FIVER",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text("Terms & Conditions",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22.0),),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("A Terms and Conditions agreement is the agreement that includes the terms, the rules and the guidelines of acceptable behavior and other useful sections to which users must agree in order to use or access your website and mobile app.",
                        softWrap: true,
                        style: TextStyle(fontSize: 18.0),
                        maxLines: 7,

                      ),
                      SizedBox(height: 10.0,),
                      Text( "* Protect your intellectual property",
                        softWrap: true,
                        style: TextStyle(fontSize: 18.0),
                        maxLines: 7,

                      ),
                      SizedBox(height: 10.0,),
                      Text( "* Protect your intellectual property",
                        softWrap: true,
                        style: TextStyle(fontSize: 18.0),
                        maxLines: 7,

                      ), SizedBox(height: 10.0,),
                      Text( "* Protect your intellectual property",
                        softWrap: true,
                        style: TextStyle(fontSize: 18.0),
                        maxLines: 7,

                      ),
                      SizedBox(height: 10.0,),
                      Text("A Terms and Conditions agreement is the agreement that includes the terms, the rules and the guidelines of acceptable behavior and other useful sections to which users must agree in order to use or access your website and mobile app.",
                        softWrap: true,
                        style: TextStyle(fontSize: 18.0),
                        maxLines: 7,

                      ),
                    ],

                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
