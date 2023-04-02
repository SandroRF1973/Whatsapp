import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Configuracoes extends StatefulWidget {
  const Configuracoes({super.key});

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  final TextEditingController _controllerNome = TextEditingController();
  late File _imagem;

  Future _recuperarImagem(String origemImagem) async {
    late File imagemSelecionada;
    switch (origemImagem) {
      case "camera":
        imagemSelecionada =
            // ignore: invalid_use_of_visible_for_testing_member
            (await ImagePicker.platform.pickImage(source: ImageSource.camera))
                as File;
        break;
      case "galeria":
        imagemSelecionada =
            // ignore: invalid_use_of_visible_for_testing_member
            (await ImagePicker.platform.pickImage(source: ImageSource.gallery))
                as File;
        break;
    }

    setState(() {
      _imagem = imagemSelecionada;
    });
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
                // ignore: prefer_const_constructors
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  backgroundImage: const NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/whatsapp-projeto-64d68.appspot.com/o/perfil%2Fperfil5.jpg?alt=media&token=0e62bfde-f7a0-4d7a-9410-733d6618a548"),
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
                      // _validarCampos();
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
