import 'package:flutter/material.dart';
import 'package:whatsapp/cadastro.dart';
import 'package:whatsapp/configuracoes.dart';
import 'package:whatsapp/home.dart';
import 'package:whatsapp/login.dart';
import 'package:whatsapp/mensagens.dart';
import 'package:whatsapp/model/usuario.dart';

class RouteGenerator {
  // ignore: body_might_complete_normally_nullable
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const Login());
      case "/login":
        return MaterialPageRoute(builder: (_) => const Login());
      case "/cadastro":
        return MaterialPageRoute(builder: (_) => const Cadastro());
      case "/home":
        return MaterialPageRoute(builder: (_) => const Home());
      case "/configuracoes":
        return MaterialPageRoute(builder: (_) => const Configuracoes());
      case "/mensagens":
        return MaterialPageRoute(builder: (_) => Mensagens(args as Usuario));

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
