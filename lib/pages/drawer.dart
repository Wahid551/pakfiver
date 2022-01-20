import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pakfiver/pages/My_Gigs.dart';
import 'package:pakfiver/pages/My_Requests/my_requests.dart';
import 'package:pakfiver/pages/Terms_Conditions.dart';
import 'package:pakfiver/pages/about.dart';
import 'package:pakfiver/pages/addproject.dart';
import 'package:pakfiver/pages/buyersHomePage.dart';
import 'package:pakfiver/pages/buyersRequest.dart';
import 'package:pakfiver/pages/inbox.dart';
import 'package:pakfiver/pages/payment/payment_page.dart';
import 'package:pakfiver/pages/payment/payment_summary.dart';
import 'package:pakfiver/pages/privacy_policies.dart';
import 'package:pakfiver/pages/profile.dart';
import 'package:pakfiver/pages/usermain.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pakfiver/login.dart';
import 'package:pakfiver/provider/gigprovider.dart';
import 'package:pakfiver/provider/requesrProvider.dart';
import 'package:pakfiver/provider/userDataProvider.dart';
import 'package:pakfiver/provider/usermode.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

import 'home.dart';

class MyDrawer extends StatefulWidget {
  late userData userProvider;

  MyDrawer({required this.userProvider});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  Widget listTile(
      {required IconData icon,
      required String title,
      required Function() click}) {
    return Column(
      children: [
        Divider(
          height: 1,
        ),
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: click,
        )
      ],
    );
  }

  File? selectedImage;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var data = widget.userProvider.currentUserData;
    UserMode usrmode=Provider.of<UserMode>(context);
    RequestProvider requestProvider=Provider.of(context);
    requestProvider.getData();
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0.0),
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(2000, 34, 116, 135),
            ),
            accountName: Text(
              data.firstName,
              style: TextStyle(
                fontSize: 22.0,
              ),
            ),
            accountEmail: Text(data.userEmail),
            currentAccountPicture: data.userImage != 'no image'
                ? CircleAvatar(
                    backgroundImage: NetworkImage(
                      data.userImage,
                    ),
                    radius: 45,
                    backgroundColor: Colors.white,
                  )
                : CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.add_a_photo),
                  ),
          ),
           Card(
            elevation: 8.0,
            child: Container(
              height: 60.0,
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListTile(
                leading: Icon(
                  Icons.credit_card,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  "Seller mode",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Switch(
                  value: usrmode.status,
                  onChanged: (value) {
                       // _exchangeProvider.exchangePage();
                      usrmode.Status(value);
                       // usrmode.gigHomePage==false?
                       // usrmode.exchangePage(true):usrmode.exchangePage(false);
                    //    usrmode.gigHomePage==true?
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home())):Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RequestPages()));
                  },
                  activeTrackColor: Color(0xFF8bd9ad),
                  activeColor: Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
          listTile(icon: Icons.shop_outlined, title: "My Profile", click: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyProfile(userProvider: widget.userProvider)));
          }),
          usrmode.status==true?listTile(icon: Icons.receipt, title: "Buyers Request", click: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RequestPage()));
          })
              :
          listTile(icon: Icons.add_box, title: "Post Request", click: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Addproject()));
          }),
          usrmode.status==false?listTile(icon: Icons.receipt, title: "My Requests", click: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>My_request()));
          }):Container(),
          listTile(icon: Icons.shop_outlined, title: "My Gigs", click: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>My_Gigs()));
          }),
          listTile(icon: Icons.payment_outlined, title: "Payment", click: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>payment_home()));
          }),
          listTile(icon: Icons.payments_sharp, title: "Payment Summary", click: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>payment_summary()));
          }),
          listTile(
              icon: Icons.chat_bubble_outline_outlined,
              title: "Chat Box",
              click: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MessageInboxPage()));
              }),
          listTile(
              icon: Icons.home_max_outlined, title: "Home Page", click: ()   {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home()));
          }),
          listTile(
              icon: Icons.file_copy_outlined,
              title: "Terms & Conditions",
              click: () {
                Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Terms_Conditions()));
              }),
          listTile(
              icon: Icons.policy_outlined,
              title: "Privacy Policy",
              click: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Privacy_policies()));
              }),
          listTile(icon: Icons.add_chart, title: "About", click: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AboutPage()));
          }),
          listTile(
            icon: Icons.exit_to_app_outlined,
            title: "Log Out",
            click: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
