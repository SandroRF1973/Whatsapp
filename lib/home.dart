import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:whatsapp/telas/abacontatos.dart';
import 'package:whatsapp/telas/abaconversas.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> itensMenu = ["Configurações", "Deslogar"];
  // ignore: prefer_final_fields
  String? _emailUsuario = "";

  Future _recuperarDadosUsuario() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    FirebaseAuth auth = FirebaseAuth.instance;

    final usuarioLogado = auth.currentUser;

    setState(() {
      _emailUsuario = usuarioLogado?.email;
    });
  }

  @override
  void initState() {
    super.initState();

    _recuperarDadosUsuario();

    _tabController = TabController(length: 2, vsync: this);
  }

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "Configurações":
        Navigator.pushNamed(context, "/configuracoes");
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;
    }
  }

  _deslogarUsuario() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signOut();

    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, "/login");

    // ignore: use_build_context_synchronously
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => const Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("WhatsApp"),
          bottom: TabBar(
            indicatorWeight: 4,
            labelStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            controller: _tabController,
            indicatorColor: Colors.white,
            // ignore: prefer_const_literals_to_create_immutables
            tabs: [
              const Tab(
                text: "Conversas",
              ),
              const Tab(
                text: "Contatos",
              )
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: _escolhaMenuItem,
              itemBuilder: (context) {
                return itensMenu.map((String item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList();
              },
            )
          ],
        ),
        // ignore: avoid_unnecessary_containers
        // ignore: prefer_const_constructors
        body: TabBarView(
          controller: _tabController,
          children: const [AbaConversas(), AbaContatos()],
        ));
  }
}
