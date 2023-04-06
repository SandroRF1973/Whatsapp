import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/model/conversa.dart';
import 'package:whatsapp/model/mensagem.dart';
import 'package:whatsapp/model/usuario.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class Mensagens extends StatefulWidget {
  Usuario contato;

  Mensagens(this.contato);

  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  late bool _subindoImagem = false;
  late String _idUsuarioLogado;
  late String _idUsuarioDestinatario;
  FirebaseFirestore db = FirebaseFirestore.instance;

  final TextEditingController _controllerMensagem = TextEditingController();

  _enviarMensagem() {
    String textoMensagem = _controllerMensagem.text;

    if (textoMensagem.isNotEmpty) {
      Mensagem mensagem = Mensagem();
      mensagem.idUsuario = _idUsuarioLogado;
      mensagem.mensagem = textoMensagem;
      mensagem.urlImagem = "";
      mensagem.tipo = "texto";

      //Salvar mensagem para o remetente
      _salvarMensagem(_idUsuarioLogado, _idUsuarioDestinatario, mensagem);

      //Salvar mensagem para o destinatário
      _salvarMensagem(_idUsuarioDestinatario, _idUsuarioLogado, mensagem);

      //Salvar conversa
      _salvarConversa(mensagem);
    }
  }

  _salvarConversa(Mensagem msg) {
    //Salvar conversa remetente
    Conversa cRemetente = Conversa();
    cRemetente.idRemetente = _idUsuarioLogado;
    cRemetente.idDestinatario = _idUsuarioDestinatario;
    cRemetente.mensagem = msg.mensagem;
    cRemetente.nome = widget.contato.nome;
    cRemetente.caminhoFoto = widget.contato.urlImagem;
    cRemetente.tipoMensagem = msg.tipo;
    cRemetente.salvar();

    //Salvar conversa destinatário
    Conversa cDestinatario = Conversa();
    cDestinatario.idRemetente = _idUsuarioDestinatario;
    cDestinatario.idDestinatario = _idUsuarioLogado;
    cDestinatario.mensagem = msg.mensagem;
    cDestinatario.nome = widget.contato.nome;
    cDestinatario.caminhoFoto = widget.contato.urlImagem;
    cDestinatario.tipoMensagem = msg.tipo;
    cDestinatario.salvar();
  }

  _salvarMensagem(
      String idRemetente, String idDestinatario, Mensagem msg) async {
    await db
        .collection("mensagens")
        .doc(idRemetente)
        .collection(idDestinatario)
        .add(msg.toMap());

    _controllerMensagem.clear();
  }

  _enviarFoto() async {
    late File imagemSelecionada;

    PickedFile? pickedFile =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    _subindoImagem = true;
    String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    final pastaRaiz = storage.ref();
    final arquivo = pastaRaiz
        .child("mensagens")
        .child(_idUsuarioLogado)
        .child("$nomeImagem.jpg");

    imagemSelecionada = File(pickedFile!.path);

    UploadTask task = arquivo.putFile(imagemSelecionada);

    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      if (snapshot.state == TaskState.running) {
        // double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        setState(() {
          _subindoImagem = true;
        });
      } else if (snapshot.state == TaskState.success) {
        setState(() {
          _subindoImagem = false;
        });
      }
    });

    task.then((TaskSnapshot snapshot) {
      _recuperarUrlImagem(snapshot);
    });
  }

  _recuperarUrlImagem(TaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

    Mensagem mensagem = Mensagem();
    mensagem.idUsuario = _idUsuarioLogado;
    mensagem.mensagem = "";
    mensagem.urlImagem = url;
    mensagem.tipo = "imagem";

    //Salvar mensagem para o remetente
    _salvarMensagem(_idUsuarioLogado, _idUsuarioDestinatario, mensagem);

    //Salvar mensagem para o destinatário
    _salvarMensagem(_idUsuarioDestinatario, _idUsuarioLogado, mensagem);
  }

  _recuperarDadosUsuario() async {
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
                  prefixIcon: _subindoImagem
                      ? const CircularProgressIndicator()
                      : IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: () {
                            _enviarFoto;
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

    var stream = StreamBuilder(
      stream: db
          .collection("mensagens")
          .doc(_idUsuarioLogado)
          .collection(_idUsuarioDestinatario)
          .snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: const [
                  Text("Carregando mensagens"),
                  CircularProgressIndicator()
                ],
              ),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot<Map<String, dynamic>>? querySnapshot = snapshot.data;

            if (snapshot.hasError) {
              return const Expanded(
                child: Text("Erro ao carregar os dados!"),
              );
            } else {
              return Expanded(
                  child: ListView.builder(
                      itemCount: querySnapshot?.docs.length,
                      itemBuilder: (context, indice) {
                        List<DocumentSnapshot> mensagens =
                            querySnapshot!.docs.toList();
                        DocumentSnapshot item = mensagens[indice];

                        double larguraContainer =
                            MediaQuery.of(context).size.width * 0.8;
                        Alignment alinhamento = Alignment.centerRight;
                        Color cor = const Color(0xffd2ffa5);

                        if (_idUsuarioLogado != item["idUsuario"]) {
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              child: item["tipo"] == "texto"
                                  ? Text(
                                      item["mensagem"],
                                      style: const TextStyle(fontSize: 18),
                                    )
                                  : Image.network(item["urlImagem"]),
                            ),
                          ),
                        );
                      }));
            }
        }
      },
    );

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
            children: [stream, caixaMensagem],
          ),
        )),
      ),
    );
  }
}
