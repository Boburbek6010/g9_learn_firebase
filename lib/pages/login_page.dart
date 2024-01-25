import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:g9_learn_firebase/pages/register_page.dart';

import '../services/auth_service.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    hintText: "Email"
                ),
              ),
              TextField(
                controller: passController,
                decoration: const InputDecoration(
                    hintText: "Password"
                ),
              ),
              MaterialButton(
                onPressed: ()async{
                  User? user;
                  user = await AuthService.loginUser(context, emailController.text, passController.text);
                  if(user != null){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                  }
                },
                child: const Text("Login"),
              ),
              MaterialButton(
                onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                },
                child: const Text("Don't you have an account?"),
              ),

              const SizedBox(height: 100),

              MaterialButton(
                onPressed: ()async{
                  User? user;
                  user = await AuthService.loginWithGoogle();
                  if(user != null){
                    log(user.email.toString());
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(user: user,)), (route) => false);
                  }else{
                    log("Failed");
                  }
                },
                child: const Icon(Icons.g_mobiledata, size: 55, color: Colors.red,),
              )
            ],
          ),
        ),
      ),
    );
  }
}
