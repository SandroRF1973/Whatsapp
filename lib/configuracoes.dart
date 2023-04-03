import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Configuracoes extends StatefulWidget {
  const Configuracoes({super.key});

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  final TextEditingController _controllerNome = TextEditingController();
  late File _imagem;
  late String _idUsuarioLogado;
  // ignore: prefer_final_fields, unused_field
  bool _subindoImagem = false;
  String? _urlImagemRecuperada;

  Future _recuperarImagem(String origemImagem) async {
    late File imagemSelecionada;
    switch (origemImagem) {
      case "camera":
        // imagemSelecionada =
        //     // ignore: invalid_use_of_visible_for_testing_member
        //     (await ImagePicker.platform.pickImage(source: ImageSource.camera))
        //         as File;

        PickedFile? pickedFile =
            // ignore: invalid_use_of_visible_for_testing_member
            await ImagePicker.platform.pickImage(source: ImageSource.camera);

        if (pickedFile != null) {
          imagemSelecionada = File(pickedFile.path);
          // final directory = await getApplicationDocumentsDirectory();
          // final newImagePath =
          //     '${directory.path}/${pickedFile.path.split('/').last}';
          // await imagemSelecionada.copy(newImagePath);
          // imagemSelecionada = File(newImagePath);
        }

        break;
      case "galeria":
        //imagemSelecionada =
        // ignore: invalid_use_of_visible_for_testing_member
        // (await ImagePicker.platform.pickImage(source: ImageSource.gallery))
        //     as File;

        PickedFile? pickedFile =
            // ignore: invalid_use_of_visible_for_testing_member
            await ImagePicker.platform.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          imagemSelecionada = File(pickedFile.path);
          // final directory = await getApplicationDocumentsDirectory();
          // final newImagePath =
          //     '${directory.path}/${pickedFile.path.split('/').last}';
          // await imagemSelecionada.copy(newImagePath);
          // imagemSelecionada = File(newImagePath);
        }

        break;
    }

    setState(() {
      _imagem = imagemSelecionada;
      // ignore: unnecessary_null_comparison
      if (_imagem != null) {
        _subindoImagem = true;
        _uploadImagem();
      }
    });
  }

  Future _uploadImagem() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    final pastaRaiz = storage.ref();
    final arquivo = pastaRaiz.child("perfil").child("$_idUsuarioLogado.jpg");

    UploadTask task = arquivo.putFile(_imagem);
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
    _atualizarUrlImagemFirestore(url);

    setState(() {
      _urlImagemRecuperada = url;
    });
  }

  _atualizarNomeFirestore() async {
    String nome = _controllerNome.text;

    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> dadosAtualizar = {"nome": nome};

    db.collection("usuarios").doc(_idUsuarioLogado).update(dadosAtualizar);
  }

  _atualizarUrlImagemFirestore(String url) async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> dadosAtualizar = {"urlImagem": url};

    db.collection("usuarios").doc(_idUsuarioLogado).update(dadosAtualizar);
  }

  _recuperarDadosUsuario() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    FirebaseAuth auth = FirebaseAuth.instance;
    final usuarioLogado = auth.currentUser;
    _idUsuarioLogado = usuarioLogado!.uid;

    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentSnapshot snapshot =
        await db.collection("usuarios").doc(_idUsuarioLogado).get();

    // Map<String, dynamic> dados = snapshot.data as  Map<String, dynamic>;
    // Map<String, dynamic> dados = snapshot.data;
    Map<String, dynamic> dados = snapshot.data() as Map<String, dynamic>;
    _controllerNome.text = dados["nome"];

    if (dados["urlImagem"] != null) {
      // ignore: avoid_print
      print("Print da imagem : ${dados["urlImagem"]}");

      setState(() {
        _urlImagemRecuperada = dados["urlImagem"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: _subindoImagem
                      ? const CircularProgressIndicator()
                      : Container(),
                ),

                // ignore: prefer_const_constructors
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  backgroundImage: _urlImagemRecuperada != null
                      ? NetworkImage(_urlImagemRecuperada!)
                      : null,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: const Text("Câmera"),
                      onPressed: () {
                        _recuperarImagem("camera");
                      },
                    ),
                    TextButton(
                      child: const Text("Galeria"),
                      onPressed: () {
                        _recuperarImagem("galeria");
                      },
                    ),
                  ],
                ),
                // ignore: prefer_const_constructors
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(fontSize: 20),
                    // onChanged: (texto) {
                    //   _atualizarNomeFirestore(texto);
                    // },
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32))),
                    child: const Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      _atualizarNomeFirestore();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
