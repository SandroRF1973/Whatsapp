class Usuario {
  String? _nome;
  String? _email;
  String? _senha;
  String? _urlImagem;

  Usuario();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"nome": nome, "email": email};

    return map;
  }

  String get nome => _nome ?? "";

  set nome(String value) {
    _nome = value;
  }

  String get email => _email ?? "";

  set email(String value) {
    _email = value;
  }

  String get senha => _senha ?? "";

  set senha(String value) {
    _senha = value;
  }

  String get urlImagem => _urlImagem ?? "";

  set urlImagem(String value) {
    _urlImagem = value;
  }
}
