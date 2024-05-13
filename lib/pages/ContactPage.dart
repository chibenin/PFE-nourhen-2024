import 'package:application/pages/UpdateContact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'auth.dart';
import 'crud_services.dart';

class ContactPage extends StatefulWidget {

  ContactPage({super.key});

 @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.blue[900] ,
        title: Text(' Contacts',style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white)
        ),

      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:Colors.blue[900] ,
        onPressed: (){
          Navigator.pushNamed(context, "/add");
        } ,
      child: Icon(Icons.person_add, color:Colors.white ,),
      ) ,
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
      body: StreamBuilder<QuerySnapshot>(
            stream:CrudServices().getContacts(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError){
             return Text("something went wrong");
          }
             if (snapshot.connectionState==ConnectionState.waiting){
             return Center(child: Text("Loading"),
            );
          }
            return

                ListView(
                children:snapshot.data!.docs.map((DocumentSnapshot document ){
                  Map<String,dynamic> data= document.data()! as Map<String,dynamic>;
                       return Slidable(
                         endActionPane: ActionPane(
                           motion: StretchMotion(),
                           children: [

                             SlidableAction(
                               onPressed: ((context) {
                                 CrudServices().deleteContact(document.id);
                                 // delete
                               }),
                               backgroundColor: Colors.red,
                               icon: Icons.delete,
                             ), // SlidableAction
                           ],
                         ),
                         child: ListTile(
                             onTap: ()=>
                             Navigator.push(context, MaterialPageRoute(
                                 builder: (context)=> UpdateContact(
                                   name:data["name"] ,
                                     phone: data["phone"],
                                     email: data["email"],
                                     docID: document.id
                                 )
                               )
                             ),
                             leading: CircleAvatar(
                               backgroundColor:Colors.blue[900] ,
                             child: Text(data["name"][0],
                                 style: TextStyle(
                                 fontWeight: FontWeight.bold,
                                 color: Colors.white)
                             ),
                             ),
                             title: Text(data["name"],
                                 style: TextStyle(
                                 fontSize: 15,
                                 color: Colors.black)
                             ),
                             subtitle: Text(data["phone"],style: TextStyle(
                                 fontSize: 15,
                                 color: Colors.black)),
                           ),
                       );
                       })
                         .toList()
                         .cast(),
                    );
                  },
                ),
             );
  }
}
