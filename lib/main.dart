import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:g9_learn_firebase/pages/home_page.dart';
import 'package:g9_learn_firebase/pages/login_page.dart';
import 'package:g9_learn_firebase/services/auth_service.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService.auth.authStateChanges().map((event) => event),
        builder: (context, snapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: snapshot.hasData ?const HomePage() :const LoginPage(),
          );
        }
    );
  }
}
