import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:animated_battery_gauge/animated_battery_gauge.dart';
import 'package:animated_battery_gauge/battery_gauge.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'Circle Progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin  {

  final databaseReference = FirebaseDatabase.instance.ref();
  var inc ;
  var  humidity ;
  var  temp ;
  var  b1 ;
  var cdc;
  @override
  _ESP1Init(double temp,double humid,double b1, double inc, double cdc) {
    esp1ProgressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 5000)); //5s
    tempAnimation =
    Tween<double>(begin: -50, end: temp).animate(esp1ProgressController as Animation<double>)
      ..addListener(() {
        setState(() {});
      });
    humidityAnimation =
    Tween<double>(begin: 0, end: humid).animate(esp1ProgressController as Animation<double>)
      ..addListener(() {
        setState(() {});
      });

    esp1ProgressController.forward();
  }
  late AnimationController esp1ProgressController;
  late Animation<double> tempAnimation;
  late Animation<double> humidityAnimation;
  void initState() {
    super.initState();
    initFirebaseMessaging();
    initESP1();
    listenESP1();
  }

  void initESP1(){
    databaseReference.child('ESP1').once().then((event) {
      final dataSnapshot = event.snapshot;
      temp = (dataSnapshot.value as Map)["T"];
      humidity = (dataSnapshot.value as Map)["H"];
      b1 = (dataSnapshot.value as Map)["B1"];
     inc = (dataSnapshot.value as Map)["INC"];
     cdc = (dataSnapshot.value as Map)["CDC"];
      _ESP1Init(temp, humidity,b1,inc,cdc);
    });
  }
  Future<void> initFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    // Subscribe the device to the topic 'all' (or any other topic you want)
    await messaging.subscribeToTopic('all');
    // Set up handlers for receiving messages, handling initialization, etc.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received message: ${message.notification?.title}");
      // Handle received message as needed
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("App opened from notification: ${message.notification?.title}");
      // Handle notification opening as needed
    });

    // Retrieve the FCM token
    String? token = await messaging.getToken();
    print("FCM token: $token");
  }
  void sendNotification(String title, String body) async {
    try {
      // Construct the FCM message
      var message = {
        'notification': {
          'title': title,
          'body': body,
        },
        'priority': 'high',
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        },
        'to': '/topics/all', // Send notification to all devices subscribed to the 'all' topic
      };

      // Send the message via HTTP POST request
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAD6FsCCo:APA91bFxazV_fPwncWa-N2y8ph9lpF1pbIiKRcFaPvrbGRaB2hjxXkcDqoEQ1vLTRU6jBiebFNxVludC2rRNCVXc3Jc5WBsSX2FGyEBnRu7GkkiltZ1CtyJvkcFFGvJOiRpiZ67Cd4Ik',
        },
        body: json.encode(message),
      );

      try {
        await FirebaseFirestore.instance.collection('notifications').add({
          'message': message,
          'timestamp': Timestamp.now(),
        });
      } catch (e) {
        print('Error saving notification: $e');
      }

      // Check response status
      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  void listenESP1(){
    databaseReference.child('ESP1').onChildChanged.listen((event) {

      if (event.snapshot.key == "H") {
        humidity = event.snapshot.value;
        if (humidity > 50.0) {
          sendNotification("High Humidity Alert", "Humidity is over 50%: $humidity%");
        }
      }
      if (event.snapshot.key == "T") {
        temp = event.snapshot.value;
        if (temp > 27.0) {
          sendNotification(
              "High Temperature Alert", "Temperature is over 27°C: $temp°C");
        }
      }
      if(event.snapshot.key == "B1"){
        b1 = event.snapshot.value ;
      }
      if (event.snapshot.key == "CDC") {
        cdc = event.snapshot.value;
        if (cdc  == 1.0 ) {
          sendNotification(
              "Power Off ","Battery mode ON :$b1%");
        }
      }
      if(event.snapshot.key == "INC"){
        inc = event.snapshot.value ;
        if (inc  == 1.0 ) {
          sendNotification(
              "Fire Alert", "Gaz detected ");
        }
      }
      _ESP1Init(temp, humidity,b1,inc,cdc);
    });
  }
  @override
  Widget build(BuildContext context) {
    return temp == null ? const Center(
      child: CircularProgressIndicator(backgroundColor: Colors.white54,color: Colors.blueAccent,),
    ) :
      Scaffold(
      backgroundColor: Colors.blue[900],

       drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            DrawerHeader(child: Image.asset('asset/images/notification.png',width: 70,),
                ),
            ListTile(
                leading: Icon(Icons.home, color: Colors.blue[900],),
                title: Text("Home",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900])),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/HomePage');
                }
            ),
            ListTile(
                leading: Icon(Icons.account_circle, color: Colors.blue[900],),
                title: Text("Contact",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900])),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/ContactPage');
                }
                ),
            ListTile(
                leading: Icon(Icons.history, color: Colors.blue[900],),
                title: Text("History of Anomalies",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900])),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/notification');
                }
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: InkWell(
                onTap: () async {
                  await AuthPage.logout(context);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.blue[900],
                      size: 30,
                    ),
                    SizedBox(width: 16),
                    Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 20, // Adjust the font size as needed
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

       body: CustomScrollView(
        slivers: [
           SliverAppBar(
            title:  AnimatedBatteryGauge(
            duration: Duration(seconds: 2),
             value: b1 ,
             size: Size(50, 20),
            borderColor: CupertinoColors.systemGrey,
            valueColor: CupertinoColors.white,
            mode: BatteryGaugePaintMode.none,
              hasText: false,
           ),
            backgroundColor: Colors.white70,
            expandedHeight: 100,
            floating: true,
            pinned: true,
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 400,
                  color: Colors.white,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        foregroundPainter: CircleProgress(tempAnimation.value, true),
                        child: SizedBox.expand(),
                      ),
                      Positioned(
                        top: 20,
                        child: Text(
                          'T E M P E R A T U R E ',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${tempAnimation.value}°C',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                            ),
                            SizedBox(width: 10),
                            Image.asset(
                              'asset/images/7979754-thermometre-deux-thermometres-prevision-de-temps-chaud-et-froid-thermometres-meteorologiques-en-celsius-et-fahrenheit-mesure-chaleur-et-froid-vecteur-main-dessiner-illustration-isole-vectoriel.jpg',
                              height: 120,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),


          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 400,
                  color: Colors.white,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        foregroundPainter: CircleProgress(humidityAnimation.value, true),
                        child: SizedBox.expand(),
                      ),
                      Positioned(
                        top: 20,
                        child: Text(
                          'H U M I D I T Y  ',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${humidityAnimation.value}%',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                            ),
                            Image.asset(
                              'asset/images/humide.png',
                              height: 120,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),


          SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                      height: 400,
                      color: Colors.white,
                      child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top:30,
                              child: Text(" F I R E",
                                style: TextStyle(color: Colors.blue.shade900,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            if (inc == 0) ...[
                              Image.asset('asset/images/fire-flames.gif'),
                              Positioned(
                                  bottom: 50,
                                  child: Text("Normal state",
                                      style: TextStyle(color: Colors.cyan,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold
                                      )
                                  )
                              )
                            ] else ...[
                              Image.asset('asset/images/fire-flame.gif'),
                              Positioned(
                                bottom: 60,
                                  child: Text("FIRE DETECTED!",
                                      style: TextStyle(color: Colors.red,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800
                                  )
                              )
                              )]
                          ])),
                ),
              )
          )
        ],
      ),
    );
  }
}