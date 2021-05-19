class UsuarioEIConsultoria {
  final String nome;
  final String email;
  final String empresa;
  final bool isEmailVerificado;

  UsuarioEIConsultoria({
    required this.nome,
    required this.email,
    required this.empresa,
    required this.isEmailVerificado,
  });

  factory UsuarioEIConsultoria.fromMap(Map data) {
    return UsuarioEIConsultoria(
      nome: data['nome'] ?? '',
      email: data['email'] ?? '',
      empresa: data['empresa'] ?? '',
      isEmailVerificado: data['isEmailVerificado'] ?? false,
    );
  }
}
