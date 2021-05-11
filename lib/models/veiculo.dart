class Veiculo {
  final int? id;
  final String? placa;
  final int? ano;
  final String? tipo;
  final String? empresa;
  final bool? laudo;

  Veiculo({
    this.id,
    this.ano,
    this.empresa,
    this.placa,
    this.tipo,
    this.laudo,
  });

  factory Veiculo.fromMap(Map data) {
    return Veiculo(
      id: data['id'],
      ano: data['ano'] ?? '',
      empresa: data['empresa'] ?? '',
      placa: data['placa'] ?? '',
      tipo: data['tipo'] ?? '',
      laudo: data['laudo'] ?? false,
    );
  }
}
