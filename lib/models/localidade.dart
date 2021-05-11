class Localidade {
  final String nome;

  Localidade({required this.nome});

  factory Localidade.fromMap(Map data) {
    return Localidade(
      nome: data['nome'] ?? '',
    );
  }
}
