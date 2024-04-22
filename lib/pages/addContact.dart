
import 'package:application/pages/crud_services.dart';
import 'package:flutter/material.dart';
class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  TextEditingController _namecontroller=TextEditingController();
  TextEditingController _emailcontroller=TextEditingController();
  TextEditingController _phonecontroller=TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey.shade50 ,
        appBar: AppBar(title: Text("Add Contact")),
        body: Form(
          key: formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Icon(Icons.account_box_outlined,size: 100,color: Colors.blue.shade900),
                  SizedBox(height: 30),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * .7,
              
                      child: TextFormField(
                        validator: (value) => value!.isEmpty ? "Enter any name" : null,
                        controller: _namecontroller,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide( color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide( color: Colors.blue.shade900),
                          ),
                          fillColor: Colors.white,
                          filled: true,
              
                          label: Text("Name...",
                            style: TextStyle(
                                color: Colors.blue.shade900
                            ),
                          ),
                        ),
                      )
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * .7,
                      child: TextFormField(
              
                        controller: _emailcontroller,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide( color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide( color: Colors.blue.shade900),
                          ),
                          fillColor: Colors.white,
                          filled: true,
              
                          label: Text("Email...",
                            style: TextStyle(
                                color: Colors.blue.shade900
                            ), ),
                        ),
                      )
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * .7,
                      child: TextFormField(
                        controller: _phonecontroller,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide( color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide( color: Colors.blue.shade900),
                          ),
                          fillColor: Colors.white,
                          filled: true,
              
                          label: Text("Phone Number...",
                            style: TextStyle(
                                color: Colors.blue.shade900
                            ),),
                        ),
                      )
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
              
              
                      child: ElevatedButton( style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0), // Adjust the border radius as needed
                        ),
                      ),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.shade900),
                      ),
                        onPressed: () {
                        if (formKey.currentState!.validate()) {
                          CrudServices().addNewContacts(_namecontroller.text,
                              _phonecontroller.text, _emailcontroller.text);
                          Navigator.pop(context);
                          }
                        },
                        child: Text(
                          "Create",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
              
                        ),),
              
                  )
                ],
              ),
            ),
          ),
        )

    );
  }
}