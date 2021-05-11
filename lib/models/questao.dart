class Questao {
  final int id;
  final String nome;
  final List<String> para;

  Questao({required this.id, required this.nome, required this.para});

  factory Questao.fromMap(Map data) {
    return Questao(
      id: data['id'],
      nome: data['nome'],
      para: List.from(data['para']),
    );
  }
}
