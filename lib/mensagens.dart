import 'package:flutter/material.dart';
import 'package:whatsapp/model/usuario.dart';

class Mensagens extends StatefulWidget {
  late Usuario contato;

  Mensagens(this.contato);

  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contato.nome),
      ),
      body: Container(),
    );
  }
}
