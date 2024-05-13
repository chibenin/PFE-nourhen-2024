import 'package:application/pages/Home%20page.dart';
import 'package:application/pages/account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:application/pages/ContactPage.dart';
import 'package:google_sign_in/google_sign_in.dart';
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});
SignInWithGoogle() async{
  final GoogleSignInAccount? gUser= await GoogleSignIn().signIn();
  final GoogleSignInAuthentication gAuth= await gUser!.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: gAuth.accessToken,
    idToken: gAuth.idToken
  );
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

  static Future logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/AccountPage', (route) => false);
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: StreamBuilder<User?>(

          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot) {
            if (snapshot.hasData) {
              return HomePage();
            }
            else {
              return AccountPage();
            }
          }
          ),
    );
  }
}
