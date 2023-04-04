import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AbaContatos extends StatefulWidget {
  const AbaContatos({super.key});

  @override
  State<AbaContatos> createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {
  late String _idUsuarioLogado;
  late String _emailUsuarioLogado;

  Future<List<Usuario>> _recuperarContatos() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection("usuarios").get();

    List<Usuario> listaUsuarios = [];

    for (DocumentSnapshot item in querySnapshot.docs) {
      Map<String, dynamic> dados = item.data() as Map<String, dynamic>;

      if (dados["email"] == _emailUsuarioLogado) {
        continue;
      }

      Usuario usuario = Usuario();
      usuario.email = dados["email"];
      usuario.nome = dados["nome"];
      usuario.urlImagem = dados["urlImagem"];

      listaUsuarios.add(usuario);
    }

    return listaUsuarios;
  }

  _recuperarDadosUsuario() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    FirebaseAuth auth = FirebaseAuth.instance;
    final usuarioLogado = auth.currentUser;
    _idUsuarioLogado = usuarioLogado!.uid;
    _emailUsuarioLogado = usuarioLogado.email!;
  }

  @override
  void initState() {
    super.initState();

    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Usuario>>(
      future: _recuperarContatos(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            // ignore: prefer_const_literals_to_create_immutables
            return Center(
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text("Carregando contatos"),
                  const CircularProgressIndicator()
                ],
              ),
            );
          case ConnectionState.active:
            return const SizedBox();
          case ConnectionState.done:
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (_, indice) {
                List<Usuario> listaItens = snapshot.data ?? [];

                Usuario usuario = listaItens[indice];

                return ListTile(
                  onTap: () {},
                  contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  leading: CircleAvatar(
                    maxRadius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        // ignore: unnecessary_null_comparison
                        usuario.urlImagem != null
                            ? NetworkImage(usuario.urlImagem)
                            : null,
                  ),
                  title: Text(usuario.nome,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                );
              },
            );
        }
      },
    );
  }
}
