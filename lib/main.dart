// ignore_for_file: prefer_const_constructors, unused_import, use_key_in_widget_constructors, camel_case_types, avoid_print


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uygulamaflutter/PaymentPage.dart';
import 'package:uygulamaflutter/anasayfa.dart';
import 'package:uygulamaflutter/auth/login_screen.dart';
import 'package:uygulamaflutter/auth/signup_screen.dart';
import 'package:uygulamaflutter/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'deneme.dart';
import 'deneme1.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {  @override
void initState() {
  FirebaseAuth.instance
      .authStateChanges().listen((User? user) {
    if (user == null) {
      print('===========User is currently signed out!');
    } else {
      print('===========User is signed in!');
    }
  });
  super.initState();
}




 @override
Widget build(BuildContext context) {
  return   MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    // Eğer email Hesabı Doğrulanmış ise anasayfaya git değilse loign e gitsin.
    //home:  (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.emailVerified)? anasayfa() : homepage(),
    //home:  PaymentPage(info: '',),
    home: homepage(),


    routes: {
      "signup" : (context) => signup(),
      "login" : (context) => login(),
      "homepage" : (context) => homepage(),
      "anasayfa" : (context) => anasayfa(),
    },
  );
}
}
