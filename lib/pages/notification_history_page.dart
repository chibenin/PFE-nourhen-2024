import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'auth.dart';

class NotificationHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.blue[900] ,
        title: Text(' History of Anomalies ',style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white)
        ),

      ),
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
                        fontSize: 20,
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Une erreur est survenue.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucune notification.'));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic>? messageData =
              document.data() as Map<String, dynamic>?;

              if (messageData == null ||
                  messageData['message'] == null ||
                  messageData['message']['notification'] == null) {
                return SizedBox(); // Si les données sont nulles ou si le champ 'message' ou 'notification' est nul, ne rien afficher
              }

              Map<String, dynamic> notificationData =
              messageData['message']['notification'] as Map<String, dynamic>;

              String title = notificationData['title'] as String;
              String body = notificationData['body'] as String;

              Timestamp timestamp = messageData['timestamp'] as Timestamp;
              DateTime dateTime = timestamp.toDate();

              // Formater la date et l'heure
              String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);

              return ListTile(
                title: Text(title,
                  style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(body),
                    SizedBox(height: 4),
                    Text(formattedDate), // Afficher la date et l'heure formatées
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
