import 'package:flutter/material.dart';
import 'package:whatsapp/cadastro.dart';
import 'package:whatsapp/home.dart';
import 'package:whatsapp/login.dart';

class RouteGenerator {
  // ignore: body_might_complete_normally_nullable
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const Login());
      case "/login":
        return MaterialPageRoute(builder: (_) => const Login());
      case "/cadastro":
        return MaterialPageRoute(builder: (_) => const Cadastro());
      case "/home":
        return MaterialPageRoute(builder: (_) => const Home());
      default:
        _erroRota();
    }
  }

  static Route<dynamic>? _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Tela não encontrada!"),
        ),
        body: const Center(
          child: Text("Tela não encontrada!"),
        ),
      );
    });
  }
}
