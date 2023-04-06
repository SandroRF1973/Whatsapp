import 'package:flutter/material.dart';
import 'package:whatsapp/model/conversa.dart';

class AbaConversas extends StatefulWidget {
  const AbaConversas({super.key});

  @override
  State<AbaConversas> createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {
  final List<Conversa> _listaConversas = [];

  @override
  void initState() {
    super.initState();

    Conversa conversa = Conversa();

    conversa.nome = "Ana Clara";
    conversa.mensagem = "Olá, tudo bem?";
    conversa.caminhoFoto =
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-projeto-64d68.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=40b4fcf6-6cf8-43d2-bbb7-e25d11083b05";

    _listaConversas.add(conversa);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _listaConversas.length,
      itemBuilder: (context, indice) {
        Conversa conversa = _listaConversas[indice];

        return ListTile(
          contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          leading: CircleAvatar(
            maxRadius: 30,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(conversa.caminhoFoto),
          ),
          title: Text(conversa.nome,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Text(conversa.mensagem,
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
        );
      },
    );
  }
}
