import 'package:application/components/MyButton.dart';
import 'package:application/components/squartile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/hihi.dart';

class AccountPage extends StatefulWidget {

  AccountPage({super.key,});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void _navigateToAccountPage(BuildContext context) {
    Navigator.pushNamed(context, '/ContactPage');
  }

  void signUserIn(BuildContext context) async{

showDialog(context: context, builder: (context){
  return const Center(
    child: CircularProgressIndicator(),
  );
});

    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);


Navigator.pop(context);

  // Une fois l'authentification réussie :
    _navigateToAccountPage(context);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar( title: Text(' Compte ') ,),

       body: SafeArea(
          child: Center (
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
               SizedBox(height: 20),
                  Icon(
              Icons.lock_rounded,
              size: 100,color: Colors.blue.shade900),
                  SizedBox(height: 30),
              
                  MyTextField(
                     controller:emailController,
                      hintText: 'Email ou Nom utilisateurs...',
                      obscureText: false
                  ),
              
              
              
                  SizedBox(height: 30),
                  MyTextField(
                    controller: passwordController ,
                      hintText: 'Mot de passe...',
                      obscureText: true,
                  ),
                  SizedBox(height: 10),
              
              
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('oublier le mot de passe ?',
                        style: TextStyle( color: Colors.grey[600]),),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  MyButton(
                    onTap: () => signUserIn(context), // Appeler la fonction _signUserIn lorsque le bouton est appuyé.
              
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Divider(
                          thickness:0.5 ,
                          color: Colors.grey,
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Ou continue avec',
                          style: TextStyle(color: Colors.blue.shade900),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                              thickness:0.5 ,
                              color: Colors.grey,
                            ))
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
              
                    mainAxisAlignment: MainAxisAlignment.center,
              
                    children: [
              
                      SquareTile(imagePath: 'asset/images/google.png'),
              
                      SizedBox(height: 10),
              
                    ]
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
              
                        Text('Vous n avez pas un compte ?',
                          style: TextStyle(color: Colors.grey.shade700),),
              
                        SizedBox(width: 10,),
              
                        Text('inscrivez vous',
                        style: TextStyle(color: Colors.blue,
                            fontWeight: FontWeight.bold),),
              
                      ],
              
              
                   )
                ],
              ),
            ),
    )));
  }
}
