import 'package:application/components/MyButton.dart';
import 'package:application/components/squartile.dart';
import 'package:application/pages/RegisterPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../components/hihi.dart';
import 'auth.dart';

class AccountPage extends StatefulWidget {

  AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void _navigateToAccountPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/HomePage');
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
      appBar: AppBar(
        title: Text('Account',
            style: TextStyle( fontSize: 20,
          fontWeight: FontWeight.bold,color: Colors.blue.shade900)) ,),

       body: SafeArea(
          child: Center (
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
               SizedBox(height: 20),
                  Image.asset('asset/images/login.png',),
                  SizedBox(height: 30),
                  MyTextField(
                     controller:emailController,
                      hintText: 'Email or name...',
                      obscureText: false
                  ),
                  SizedBox(height: 30),
                  MyTextField(
                    controller: passwordController ,
                      hintText: 'Password...',
                      obscureText: true,
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 25),
                  MyButton(
                    color:Colors.blue[900],
                    text: "Login ",
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
                          child: Text('Or continue with',
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
                        SquareTile(
                          onTap: ()=> AuthPage().SignInWithGoogle(),
                          imagePath: 'asset/images/google.png'),
                        SizedBox(height: 10),
                      ]
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("You don't have an account ?" ,
                          style: TextStyle(color: Colors.grey.shade700),),
                        SizedBox(width: 10,),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterPage()),
                            );
                          },
                          child: Text(
                            'Register Now',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                   )
                ],
              ),
            ),
    )));
  }
}
