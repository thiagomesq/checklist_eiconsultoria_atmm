import 'dart:async';

import 'package:checklist_eiconsultoria_atmm/models/empresa.dart';
import 'package:checklist_eiconsultoria_atmm/models/localidade.dart';
import 'package:checklist_eiconsultoria_atmm/models/questao.dart';
import 'package:checklist_eiconsultoria_atmm/models/resposta.dart';
//import 'package:checklist_eiconsultoria_atmm/models/unidade.dart';
import 'package:checklist_eiconsultoria_atmm/models/veiculo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChecklistData {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Empresa>> getEmpresas() {
    return _firestore.collection('empresas').orderBy('nome').snapshots().map(
        (event) => event.docs.map((e) => Empresa.fromMap(e.data())).toList());
  }

  Stream<List<Localidade>> getLocalidades() {
    return _firestore.collection('localidades').orderBy('nome').snapshots().map(
          (event) =>
              event.docs.map((e) => Localidade.fromMap(e.data())).toList(),
        );
  }

  FutureOr<Iterable<Localidade>> getLocalidadesFiltrada(String nome) {
    return _firestore.collection('localidades').orderBy('nome').get().then(
          (value) => value.docs
              .map((e) => Localidade.fromMap(e.data()))
              .toList()
              .where(
                (element) =>
                    element.nome.toLowerCase().startsWith(nome.toLowerCase()),
              )
              .toList(),
        );
  }

  Stream<List<Questao>> getQuestoes() {
    return _firestore
        .collection('questoes')
        .orderBy('id')
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        return Questao.fromMap(e.data());
      }).toList();
    });
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
    return _firestore
        .collection('veiculos')
        .orderBy('empresa')
        .orderBy('placa')
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Veiculo.fromMap(e.data())).toList());
  }

  FutureOr<Iterable<Veiculo>> getVeiculosFiltrados(String placa) {
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

  void addVeiculo(
    String newPlaca,
    int newAno,
    String newTipo,
    String newEmpresa,
    bool isLaudo,
  ) {
    var addVeiculoData = Map<String, dynamic>();
    addVeiculoData['placa'] = newPlaca;
    addVeiculoData['ano'] = newAno;
    addVeiculoData['tipo'] = newTipo;
    addVeiculoData['empresa'] = newEmpresa;
    addVeiculoData['laudo'] = isLaudo;
    addVeiculoData['usuario'] = 'EIConsultoria Checklist';
    _firestore.collection('veiculos').doc().set(addVeiculoData);
  }

  void deleteVeiculo(Veiculo veiculo) {
    _firestore
        .collection('veiculos')
        .where('placa', isEqualTo: veiculo.placa)
        .get()
        .then((value) {
      value.docs.forEach((e) {
        e.reference.delete();
      });
    });
  }

  void gerarRespostas(
    List<Questao> questaoValidaList,
    String data,
    String localidade,
    String veiculo,
  ) {
    questaoValidaList.forEach((e) {
      var addRespostaData = Map<String, dynamic>();
      addRespostaData['idQuestao'] = e.id;
      addRespostaData['questao'] = e.nome;
      addRespostaData['veiculo'] = veiculo;
      addRespostaData['data'] = data;
      addRespostaData['localidade'] = localidade;
      addRespostaData['ok'] = true;
      addRespostaData['dscNC'] = '';
      addRespostaData['usuario'] = 'EIConsultoria Checklist';
      _firestore
          .collection('respostas')
          .where('idQuestao', isEqualTo: e.id)
          .where('data', isEqualTo: data)
          .where('veiculo', isEqualTo: veiculo)
          .where('localidade', isEqualTo: localidade)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          _firestore.collection('respostas').doc().set(addRespostaData);
        }
      });
    });
  }

  void updateResposta(Resposta resposta) {
    _firestore
        .collection('respostas')
        .where('idQuestao', isEqualTo: resposta.idQuestao)
        .where('data', isEqualTo: resposta.data)
        .where('veiculo', isEqualTo: resposta.veiculo)
        .where('localidade', isEqualTo: resposta.localidade)
        .get()
        .then((value) {
      value.docs.forEach((e) {
        var addRespostaData = Map<String, dynamic>();
        addRespostaData['idQuestao'] = resposta.idQuestao;
        addRespostaData['questao'] = resposta.questao;
        addRespostaData['veiculo'] = resposta.veiculo;
        addRespostaData['data'] = resposta.data;
        addRespostaData['localidade'] = resposta.localidade;
        addRespostaData['ok'] = resposta.ok;
        addRespostaData['dscNC'] = resposta.dscNC;
        addRespostaData['usuario'] = 'EIConsultoria Checklist';
        e.reference.set(addRespostaData);
      });
    });
  }

  void upadateDscNC(String dscNCOld, String dscNCNew) {
    _firestore
        .collection('respostas')
        .where('dscNC', isEqualTo: dscNCOld)
        .get()
        .then((value) => value.docs.forEach((e) {
              var addRespostaData = e.data();
              addRespostaData['dscNC'] = dscNCNew;
              addRespostaData['usuario'] = 'EIConsultoria Checklist';
              e.reference.set(addRespostaData);
            }));
  }

  void deleteRespostas(String veiculo, String data, String localidade) {
    _firestore
        .collection('respostas')
        .where('veiculo', isEqualTo: veiculo)
        .where('data', isEqualTo: data)
        .where('localidade', isEqualTo: localidade)
        .get()
        .then((value) {
      value.docs.forEach((e) {
        e.reference.delete();
      });
    });
  }

  void updateRespostas(String data, String localidade) {
    _firestore
        .collection('respostas')
        .where('data', isEqualTo: data)
        .where('localidade', isEqualTo: localidade)
        .get()
        .then((value) {
      value.docs.forEach((e) {
        var addRespostaData = e.data();
        addRespostaData['data'] = '06/05/2021';
        addRespostaData['usuario'] = 'EIConsultoria Checklist';
        e.reference.set(addRespostaData);
      });
    });
  }
}
