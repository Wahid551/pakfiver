import 'package:flutter/material.dart';

import 'package:pakfiver/pages/home.dart';
import 'package:pakfiver/provider/usermode.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'search.dart';
import 'addproject.dart';
import 'inbox.dart';
import 'menu.dart';

class usermain extends StatefulWidget {
  const usermain({Key? key}) : super(key: key);

  @override
  _usermainState createState() => _usermainState();
}

class _usermainState extends State<usermain> {
  late UserMode usermode;
  int _selectedIndex = 0;
  static List<dynamic> _widgetOptions = <dynamic>[
    Home(),
    Search(),
    Addproject(),
    MessageInboxPage(),
    Menu(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
     usermode=Provider.of(context);
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color.fromARGB(2000, 34, 116, 135),
          ),
          BottomNavigationBarItem(
            icon:  Icon(Icons.search),
            label: 'Search',
            backgroundColor: Color.fromARGB(2000, 34, 116, 135),
          ),

          BottomNavigationBarItem(

            icon: Icon(Icons.add),
            label: usermode.status==true?'Add Gig':'Post Request',
            backgroundColor: Color.fromARGB(2000, 34, 116, 135),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Inbox',
            backgroundColor: Color.fromARGB(2000, 34, 116, 135),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
