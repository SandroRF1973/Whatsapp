import 'package:flutter/material.dart';
import 'package:whatsapp/model/usuario.dart';

class Mensagens extends StatefulWidget {
  late Usuario contato;

  Mensagens(this.contato);

  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  final TextEditingController _controllerMensagem = TextEditingController();
  _enviarMensagem() {}
  _enviarFoto() {}

  @override
  Widget build(BuildContext context) {
    var caixaMensagem = Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextField(
                controller: _controllerMensagem,
                autofocus: true,
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
                  hintText: "Digite uma mensagem...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32)),
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () {
                      _enviarFoto();
                    },
                  ),
                ),
              ),
            ),
          ),
          FloatingActionButton(
              backgroundColor: const Color(0xff075E54),
              // ignore: sort_child_properties_last
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
              mini: true,
              onPressed: _enviarMensagem)
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contato.nome),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("imagens/bg.png"), fit: BoxFit.cover)),
        child: SafeArea(
            child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [const Text("listview"), caixaMensagem],
          ),
        )),
      ),
    );
  }
}
