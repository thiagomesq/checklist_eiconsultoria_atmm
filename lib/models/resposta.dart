class Resposta {
  final int idQuestao;
  final String questao;
  bool? ok;
  final String data;
  //final String unidade;
  final String veiculo;
  final String localidade;
  String? dscNC;

  Resposta({
    required this.idQuestao,
    required this.questao,
    this.ok,
    //@required this.unidade,
    required this.veiculo,
    required this.data,
    required this.localidade,
    this.dscNC,
  });

  factory Resposta.fromMap(Map data) {
    return Resposta(
      idQuestao: data['idQuestao'],
      data: data['data'] ?? '',
      ok: data['ok'] ?? true,
      questao: data['questao'] ?? '',
      //unidade: data['unidade'] ?? '',
      veiculo: data['veiculo'] ?? '',
      localidade: data['localidade'] ?? '',
      dscNC: data['dscNC'] ?? '',
    );
  }

  void changeOk() {
    this.ok = !this.ok!;
  }
}
