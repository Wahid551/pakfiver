import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pakfiver/pages/home.dart';
import 'package:pakfiver/provider/exchange_homePage.dart';
import 'package:pakfiver/provider/gigprovider.dart';
import 'package:pakfiver/provider/notification_provider.dart';
import 'package:pakfiver/provider/requesrProvider.dart';

import 'package:pakfiver/provider/userDataProvider.dart';
import 'package:pakfiver/provider/usermode.dart';
import 'package:provider/provider.dart';
import 'login.dart';


import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<userData>(
          create: (context) => userData(),
        ),
        ChangeNotifierProvider<GigProvider>(
          create: (context) => GigProvider(),
        ),
        ChangeNotifierProvider<UserMode>(
          create: (context) => UserMode(),
        ),
        ChangeNotifierProvider<RequestProvider>(
          create: (context) => RequestProvider(),
        ),
        ChangeNotifierProvider<Notification_provider>(
          create: (context) => Notification_provider(),
        ),
        ChangeNotifierProvider<ExchangeProvider>(
          create: (context) => ExchangeProvider(),
        ),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login(),
      ),
    );
  }
}
