import 'package:application/pages/crud_services.dart';
import 'package:flutter/material.dart';
class UpdateContact extends StatefulWidget {
  const UpdateContact({super.key, required this.docID, required this.name, required this.phone, required this.email});
final String docID, name ,phone,email ;
  @override
  State<UpdateContact> createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {
  TextEditingController _namecontroller=TextEditingController();
  TextEditingController _emailcontroller=TextEditingController();
  TextEditingController _phonecontroller=TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
   _emailcontroller.text=widget.email;
   _phonecontroller.text=widget.phone;
   _namecontroller.text=widget.name;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey.shade50 ,
        appBar: AppBar(title: Text("Update Contact")),
        body: Form(
          key: formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                Image.asset('asset/images/form.png',height: 100,),
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
                          CrudServices().updateContact(_namecontroller.text,
                              _phonecontroller.text, _emailcontroller.text,widget.docID);
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "Update",
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