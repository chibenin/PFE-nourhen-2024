import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
      appBar: AppBar( title: Text(' Contacts'),

      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, "/add");
        } ,
      child: Icon(Icons.person_add),
      ) ,
     drawer: Drawer(
       child: ListView(
         children: [
           DrawerHeader(child: Column(
             mainAxisAlignment: MainAxisAlignment.end,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               CircleAvatar(
                 maxRadius: 32,
                 child: Text(FirebaseAuth.instance.currentUser.toString()[0]),

               )
             ],
           ))
         ],
       ),

     ),
      body: Center(
       child: Slidable(
          endActionPane: ActionPane(
           motion: StretchMotion(),
            children: [
           SlidableAction(
             onPressed: (BuildContext context) {
            //   CrudServices().deleteContact(widget.docID);
                },
            backgroundColor: Colors.red,
              icon: Icons.delete,

               ), // SlidableAction
        ],
         ),
         child: Container(
            color: Colors.grey[300],

          child: StreamBuilder<QuerySnapshot>(
          stream:CrudServices().getContacts(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError){
            return Text("something went wrong");
          }
          if (snapshot.connectionState==ConnectionState.waiting){
            return Center(child: Text("Loading"),
            );
          }
          return ListView(
            children:snapshot.data!.docs.map((DocumentSnapshot document ){
              Map<String,dynamic> data= document.data()! as Map<String,dynamic>;
                   return ListTile(
                leading: CircleAvatar(
                  child: Text(data["name"][0]),),
                title: Text(data["name"]),
                subtitle: Text(data["phone"]),

              );
            })
                .toList()
                .cast(),
          );
        }, ),
      ),
    )
      )
    );
  }
}
