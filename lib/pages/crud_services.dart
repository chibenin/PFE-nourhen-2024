import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class CrudServices{
  User? user = FirebaseAuth.instance.currentUser;
  Future addNewContacts(String name,String phone,String email)
  async {
    Map < String,dynamic> data  ={
      "name":name,
      "email":email,
      "phone":phone,


    };
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("contacts")
          .add(data);
      print("Document Added");
    }
    catch (e) {
   print(e.toString());
    }
  }
  Stream<QuerySnapshot> getContacts() async* {
    var contacts= FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("contacts")
        .snapshots();
    yield* contacts;
  }
  Future updateContact(String name,String phone,String email,String docID)
  async {
    Map < String,dynamic> data  ={
      "name":name,
      "email":email,
      "phone":phone,


    };
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("contacts")
          .doc(docID)
          .update(data);
      print("Document Updated");
    }
    catch(e) {
      print(e.toString());
    }
  }
  Future deleteContact(String docID)async{
    try{
     await FirebaseFirestore.instance
         .collection("users")
         .doc(user!.uid)
         .collection("contacts")
         .doc(docID)
         .delete();
     print("contact deleted");
    }
    catch(e) {
      print(e.toString());
    }
  }
}
