import 'package:flutter/material.dart';
import 'package:whatsapp/model/conversa.dart';

class AbaContatos extends StatefulWidget {
  const AbaContatos({super.key});

  @override
  State<AbaContatos> createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {
  List<Conversa> listaConversas = [
    Conversa("Ana Maria", "Olá tudo bem?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-projeto-64d68.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=40b4fcf6-6cf8-43d2-bbb7-e25d11083b05"),
    Conversa("Pedro Silva", "Olá tudo bem?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-projeto-64d68.appspot.com/o/perfil%2Fperfil2.jpg?alt=media&token=c447d87f-23e4-4b79-85b0-100915431bd7"),
    Conversa("Marcela Almeida", "Olá tudo bem?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-projeto-64d68.appspot.com/o/perfil%2Fperfil3.jpg?alt=media&token=fe2aab5d-e701-459f-84bd-ff9f7fe99e99"),
    Conversa("José Ricardo", "Olá tudo bem?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-projeto-64d68.appspot.com/o/perfil%2Fperfil4.jpg?alt=media&token=3ce89cd6-b731-4910-affe-58e48ef4eb74"),
    Conversa("Jamilton", "Olá tudo bem?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-projeto-64d68.appspot.com/o/perfil%2Fperfil5.jpg?alt=media&token=0e62bfde-f7a0-4d7a-9410-733d6618a548"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listaConversas.length,
      itemBuilder: (context, indice) {
        Conversa conversa = listaConversas[indice];

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
        );
      },
    );
  }
}
