class Unidade {
  final String nome;

  Unidade({required this.nome});

  factory Unidade.fromMap(Map data) {
    return Unidade(
      nome: data['nome'] ?? '',
    );
  }
}
