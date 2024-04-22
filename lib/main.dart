import 'package:application/pages/ContactPage.dart';
import 'package:application/pages/Home page.dart';
import 'package:application/pages/account_page.dart';
import 'package:application/pages/addContact.dart';

import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {




  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        routes: {
          '/HomePage': (context) =>  HomePage(),
          '/AccountPage': (context) =>  AccountPage(),
          '/ContactPage': (context) =>  ContactPage(),
          "/add": (context) => AddContact(),
        }
    );
  }
}
