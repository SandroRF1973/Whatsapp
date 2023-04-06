// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:whatsapp/home.dart';
import 'package:whatsapp/login.dart';
import 'package:whatsapp/routegenerator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

void main() async {
  //final ThemeData temaPadrao = ThemeData(primaryColor: const Color(0xff075E54), accentColor:  );

  final ThemeData theme = ThemeData();
  final ThemeData temaIOS = ThemeData().copyWith(
      colorScheme: theme.colorScheme.copyWith(
          primary: Colors.grey[200], secondary: const Color(0xff25D366)));
  final ThemeData temaPadrao = ThemeData().copyWith(
      colorScheme: theme.colorScheme.copyWith(
          primary: const Color(0xff075E54),
          secondary: const Color(0xff25D366)));

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const Login(),
    theme: Platform.isIOS ? temaIOS : temaPadrao,
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
  ));
}
