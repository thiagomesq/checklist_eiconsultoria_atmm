class Empresa {
  final String nome;

  Empresa({required this.nome});

  factory Empresa.fromMap(Map data) {
    return Empresa(
      nome: data['nome'] ?? '',
    );
  }
}
