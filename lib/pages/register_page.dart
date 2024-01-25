import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {


  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(
                hintText: "Full name"
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  hintText: "Email"
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passController,
              decoration: const InputDecoration(
                  hintText: "Password"
              ),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: ()async{
                User? user;
                if(fullNameController.text.isNotEmpty && emailController.text.isNotEmpty && passController.text.isNotEmpty){
                  user = await AuthService.registerUser(context, fullNameController.text, emailController.text, passController.text);
                  if(user != null){
                    log(user.toString());
                    Future.delayed(Duration.zero).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully registered")));
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(
                        // user: user,
                      )));
                    });
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong")));
                  }
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all the gaps")));
                }
              },
              color: Colors.blueGrey,
              child: const Text("Register"),
            )
          ],
        ),
      ),
    );
  }
}
