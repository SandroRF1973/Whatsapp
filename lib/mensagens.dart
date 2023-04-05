import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/mensagem.dart';
import 'package:whatsapp/model/usuario.dart';

class Mensagens extends StatefulWidget {
  late Usuario contato;

  Mensagens(this.contato);

  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  late String _idUsuarioLogado;
  late String _idUsuarioDestinatario;

  List<String> listaMensagens = [
    "Olá!",
    "Olá, tudo bem?",
    "Tudo ótimo, e contigo?"
  ];
  final TextEditingController _controllerMensagem = TextEditingController();
  _enviarMensagem() {
    String textoMensagem = _controllerMensagem.text;

    if (textoMensagem.isNotEmpty) {
      Mensagem mensagem = Mensagem();
      mensagem.idUsuario = _idUsuarioLogado;
      mensagem.mensagem = textoMensagem;
      mensagem.urlImagem = "";
      mensagem.tipo = "texto";

      _salvarMensagem(_idUsuarioLogado, _idUsuarioDestinatario, mensagem);
    }
  }

  _salvarMensagem(
      String idRemetente, String idDestinatario, Mensagem msg) async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    FirebaseFirestore db = FirebaseFirestore.instance;

    await db
        .collection("mensagens")
        .doc(idRemetente)
        .collection(idDestinatario)
        .add(msg.toMap());

    _controllerMensagem.clear();
  }

  _enviarFoto() {}

  _recuperarDadosUsuario() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    FirebaseAuth auth = FirebaseAuth.instance;
    final usuarioLogado = auth.currentUser;
    _idUsuarioLogado = usuarioLogado!.uid;

    _idUsuarioDestinatario = widget.contato.idUsuario;
  }

  @override
  void initState() {
    super.initState();

    _recuperarDadosUsuario();
  }

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

    var listView = Expanded(
        child: ListView.builder(
            itemCount: listaMensagens.length,
            itemBuilder: (context, indice) {
              double larguraContainer = MediaQuery.of(context).size.width * 0.8;
              Alignment alinhamento = Alignment.centerRight;
              Color cor = const Color(0xffd2ffa5);

              if (indice % 2 == 0) {
                alinhamento = Alignment.centerLeft;
                cor = Colors.white;
              }

              return Align(
                alignment: alinhamento,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Container(
                    width: larguraContainer,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: cor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: Text(
                      listaMensagens[indice],
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              );
            }));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              maxRadius: 20,
              backgroundColor: Colors.grey,
              backgroundImage:
                  // ignore: unnecessary_null_comparison
                  widget.contato.urlImagem != null
                      ? NetworkImage(widget.contato.urlImagem)
                      : null,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(widget.contato.nome),
            )
          ],
        ),
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
            children: [listView, caixaMensagem],
          ),
        )),
      ),
    );
  }
}
