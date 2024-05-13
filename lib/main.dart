import 'package:application/pages/ContactPage.dart';
import 'package:application/pages/Home page.dart';
import 'package:application/pages/RegisterPage.dart';
import 'package:application/pages/account_page.dart';
import 'package:application/pages/addContact.dart';
import 'package:application/pages/notification_history_page.dart';

import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'API/firebase_api.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AccountPage(),
        navigatorKey: navigatorKey,
        routes: {
          '/HomePage': (context) =>  HomePage(),
          '/AccountPage': (context) =>  AccountPage(),
          '/ContactPage': (context) =>  ContactPage(),
          "/add": (context) => AddContact(),
          "/RegisterPage": (context) =>RegisterPage(),
          "/notification":(context) =>NotificationHistoryPage(),
        }
    );
  }


}
