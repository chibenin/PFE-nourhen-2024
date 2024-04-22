import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'Circle Progress.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin  {

  final databaseReference = FirebaseDatabase.instance.ref();

  late AnimationController esp1ProgressController;
  late AnimationController esp2ProgressController;
  late Animation<double> tempAnimation;
  late Animation<double> humidityAnimation;
  var inc ;
  var  humidity ;
  var  temp ;
  @override
  void initState() {
    super.initState();
    initESP1();
    initESP2();
    listenESP1();
    listenESP2();
  }
  void initESP1(){
    databaseReference.child('ESP1').once().then((event) {
      final dataSnapshot = event.snapshot;
      temp = (dataSnapshot.value as Map)["T"];
      humidity = (dataSnapshot.value as Map)['H'];
      _ESP1Init(temp, humidity);
    });
  }

  void listenESP1(){
    databaseReference.child('ESP1').onChildChanged.listen((event) {

      if(event.snapshot.key == "H"){
        humidity = event.snapshot.value;
      }
      if(event.snapshot.key == "T"){
        temp = event.snapshot.value ;
      }
      _ESP1Init(temp, humidity);
    });
  }

  void initESP2(){
    databaseReference.child('ESP2').once().then((event) {
      final dataSnapshot = event.snapshot;
      inc = (dataSnapshot.value as Map)["INC"];
    });
  }

  void listenESP2(){
    databaseReference.child('ESP2').onChildChanged.listen((event) {
      if(event.snapshot.key == "INC"){
        inc = event.snapshot.value ;
        setState(() {});
      }
    });
  }


  _ESP1Init(double temp, double humid) {
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[800],

      drawer: Drawer(
        backgroundColor: Colors.blue[50],
        child: Column(
          children: [

            DrawerHeader(
                child: Icon(Icons.notifications_active_outlined
                )),
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
                title: Text("Account",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900])),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/AccountPage');
                }
            )
          ],
        ),

      ),

      body: CustomScrollView(
        slivers: [
          SliverAppBar(

            title: Icon(
              Icons.battery_saver_rounded, size: 30, color: Colors.white,),
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
                      child: Column(

                          children: [
                            if (inc == 0) ...[

                              Text(" F I R E",
                                style: TextStyle(color: Colors.blue.shade900,
                                   fontSize: 30,
                                   fontWeight: FontWeight.bold
                                   ),
                                 ),

                               Image.asset('asset/images/green_fire.png',
                                    width: 400,),

                              ] else ...[


                                   Text(" F I R E",
                                    style: TextStyle(color: Colors.blue.shade900,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold
                                    ),),


                               Image.asset(
                                  'asset/images/17214608-flamme-rouge-sur-fond-blanc-vectoriel.jpg',
                                  width: 400,),
                            ]
                          ])),
                ),
              )
          )
        ],
      ),
    );
  }
}