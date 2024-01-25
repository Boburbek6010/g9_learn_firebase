import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{

  static FirebaseAuth auth = FirebaseAuth.instance;
  static GoogleSignIn google = GoogleSignIn();

  static Future<User?> registerUser(BuildContext context, String fullName, String email, String password)async{
    try{
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      if(userCredential.user != null){
        log("message");
        await userCredential.user?.updateDisplayName(fullName);
      }
      return userCredential.user;
    }catch(e){
      Future.delayed(Duration.zero).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
      });
    }
    return null;
  }

  static Future<User?> loginUser(BuildContext context, String email, String password)async{
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    }catch(e){
      Future.delayed(Duration.zero).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
      });
    }
    return null;
  }

  static Future<User?> loginWithGoogle()async{
    final GoogleSignInAccount? gUser = await google.signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential.user;
  }

  static Future<void> deleteAccount()async{
    await auth.currentUser?.delete();
  }

  static Future<void> logOut()async{
    await google.signOut();
    await auth.signOut();
  }

}