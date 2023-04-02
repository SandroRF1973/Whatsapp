// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:whatsapp/home.dart';
import 'package:whatsapp/login.dart';
import 'package:whatsapp/routegenerator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();

  // FirebaseFirestore.instance
  //     .collection("usuarios")
  //     .doc("002")
  //     .set({"nome": "Ana"});

  final ThemeData theme = ThemeData();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const Login(),
    theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
            primary: const Color(0xff075E54),
            secondary: const Color(0xff25D366))),
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
  ));
}
