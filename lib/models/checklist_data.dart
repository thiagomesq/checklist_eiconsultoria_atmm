import 'dart:async';

import 'package:checklist_eiconsultoria_atmm/models/empresa.dart';
import 'package:checklist_eiconsultoria_atmm/models/resposta.dart';
import 'package:checklist_eiconsultoria_atmm/models/usuario_eiconsultoria.dart';
//import 'package:checklist_eiconsultoria_atmm/models/unidade.dart';
import 'package:checklist_eiconsultoria_atmm/models/veiculo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChecklistData {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static User? _user;
  static UsuarioEIConsultoria? _usuario;

  void carregaUser() {
    _auth.authStateChanges().listen((event) {
      _user = event;
    });
    _user = _auth.currentUser;
  }

  void carregaUsuario(UsuarioEIConsultoria? usuario) {
    _usuario = usuario;
  }

  Stream<List<Empresa>> getEmpresas() {
    return _firestore.collection('empresas').orderBy('nome').snapshots().map(
        (event) => event.docs.map((e) => Empresa.fromMap(e.data())).toList());
  }

  Stream<List<Resposta>> getRespostas(
      {required String data,
      required String veiculo,
      required String localidade}) {
    return _firestore
        .collection('respostas')
        .where('data', isEqualTo: data)
        .where('veiculo', isEqualTo: veiculo)
        .where('localidade', isEqualTo: localidade)
        .orderBy('idQuestao')
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Resposta.fromMap(e.data())).toList());
  }

  Stream<List<Resposta>> getRespostasNaoConformidade({
    required String data,
  }) {
    return _firestore
        .collection('respostas')
        .where('data', isEqualTo: data)
        .where('ok', isEqualTo: false)
        .orderBy('veiculo')
        .orderBy('idQuestao')
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Resposta.fromMap(e.data())).toList());
  }

  Stream<List<Resposta>> getRespostasPorData({required String data}) {
    return _firestore
        .collection('respostas')
        .where('data', isEqualTo: data)
        .orderBy('veiculo')
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Resposta.fromMap(e.data())).toList());
  }

//  Stream<List<Unidade>> getUnidades() {
//    return _firestore.collection('unidades').orderBy('nome').snapshots().map(
//        (event) =>
//            event.documents.map((e) => Unidade.fromMap(e.data)).toList());
//  }

  Stream<List<Veiculo>> getVeiculos() {
    if (_usuario != null && _usuario!.empresa != 'Veracel') {
      return _firestore
          .collection('veiculos')
          .where('empresa', isEqualTo: _usuario!.empresa)
          .orderBy('placa')
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Veiculo.fromMap(e.data())).toList());
    }
    return _firestore
        .collection('veiculos')
        .orderBy('empresa')
        .orderBy('placa')
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Veiculo.fromMap(e.data())).toList());
  }

  FutureOr<Iterable<Veiculo>> getVeiculosFiltrados(String placa) {
    if (_usuario != null && _usuario!.empresa != 'Veracel') {
      return _firestore
          .collection('veiculos')
          .where('empresa', isEqualTo: _usuario!.empresa)
          .orderBy('placa')
          .get()
          .then(
            (value) => value.docs
                .map((e) => Veiculo.fromMap(e.data()))
                .toList()
                .where(
                  (element) => element.placa!
                      .toLowerCase()
                      .startsWith(placa.toLowerCase()),
                )
                .toList(),
          );
    }
    return _firestore
        .collection('veiculos')
        .orderBy('empresa')
        .orderBy('placa')
        .get()
        .then(
          (value) => value.docs
              .map((e) => Veiculo.fromMap(e.data()))
              .toList()
              .where(
                (element) => element.placa!
                    .toLowerCase()
                    .startsWith(placa.toLowerCase()),
              )
              .toList(),
        );
  }

  Stream<List<Veiculo>> getVeiculosPorRespostas(List<Resposta> respostas) {
    if (_usuario != null && _usuario!.empresa != 'Veracel') {
      return _firestore
          .collection('veiculos')
          .where('empresa', isEqualTo: _usuario!.empresa)
          .orderBy('placa')
          .snapshots()
          .map((event) => event.docs
              .map((e) => Veiculo.fromMap(e.data()))
              .toList()
              .where((veiculo) => respostas
                  .any((resposta) => veiculo.placa == resposta.veiculo))
              .toList());
    }
    return _firestore.collection('veiculos').orderBy('placa').snapshots().map(
        (event) => event.docs
            .map((e) => Veiculo.fromMap(e.data()))
            .toList()
            .where((veiculo) =>
                respostas.any((resposta) => veiculo.placa == resposta.veiculo))
            .toList());
  }

  Stream<List<UsuarioEIConsultoria>> getUser() {
    try {
      if (_user == null) {
        return Stream.value(List<UsuarioEIConsultoria>.empty());
      }
      _firestore
          .collection('usuarios')
          .where('email', isEqualTo: _user!.email)
          .get()
          .then((value) {
        value.docs.forEach((e) {
          var usuario = e.data();
          usuario['isEmailVerificado'] = _user!.emailVerified;
          e.reference.set(usuario);
        });
      });
      return _firestore
          .collection('usuarios')
          .where('email', isEqualTo: _user!.email)
          .snapshots()
          .map((event) => event.docs
              .map((e) => UsuarioEIConsultoria.fromMap(e.data()))
              .toList());
    } catch (e) {
      return Stream.value(List<UsuarioEIConsultoria>.empty());
    }
  }

  Future<String> logIn(String email, String senha) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _user = userCredential.user;
      if (!_user!.emailVerified) {
        return Future.value(
          'Favor verificar seu e-mail para ter acesso ao sistema.',
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return Future.value('Senha incorreta.');
      } else if (e.code == 'user-not-found') {
        return Future.value('Usuário não encontrado.');
      }
    }
    if (_user == null) {
      return Future.value(
        'Não foi logar, favor tentar novamente em instantes.',
      );
    }
    return Future.value('');
  }

  Future<String> createUsuario(
    UsuarioEIConsultoria usuario,
    String senha,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: senha,
      );
      User user = userCredential.user!;
      await user.updateDisplayName(usuario.nome);
      await user.sendEmailVerification();
      var addUsuarioData = Map<String, dynamic>();
      addUsuarioData['nome'] = usuario.nome;
      addUsuarioData['email'] = usuario.email;
      addUsuarioData['empresa'] = usuario.empresa;
      addUsuarioData['isEmailVerificado'] = usuario.isEmailVerificado;
      _firestore.collection('usuarios').doc().set(addUsuarioData);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'A senha fornecida é muito fraca.';
      } else if (e.code == 'email-already-in-use') {
        return 'Já existe um usuário cadastrado com esse e-mail.';
      }
    } catch (e) {
      return 'Houve um erro inexperado, tente novamente em instantes.';
    }
    return 'Usuário cadastrado com sucesso. Foi enviada uma mensagem para o e-mail fornecido, favor verificar para concluir o cadastro.';
  }

  void reenviarEmail() async {
    await _user!.sendEmailVerification();
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }
}
