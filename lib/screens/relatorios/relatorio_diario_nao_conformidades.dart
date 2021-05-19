import 'package:checklist_eiconsultoria_atmm/models/checklist_data.dart';
import 'package:checklist_eiconsultoria_atmm/models/resposta.dart';
import 'package:checklist_eiconsultoria_atmm/models/veiculo.dart';
import 'package:checklist_eiconsultoria_atmm/widgets/carregador.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';

import '../../constants.dart';

class NaoConformidadeScreen extends StatefulWidget {
  final String data;

  NaoConformidadeScreen({this.data = ''});

  @override
  _NaoConformidadeScreenState createState() => _NaoConformidadeScreenState();
}

class _NaoConformidadeScreenState extends State<NaoConformidadeScreen> {
  int _rowsPerPage = 5;
  late String data;
  late String veiculo;
  DateTime hoje = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.data.isEmpty) {
      int dia = hoje.day;
      int mes = hoje.month;
      int ano = hoje.year;
      String diaString;
      String mesString;
      dia >= 10 ? diaString = dia.toString() : diaString = '0' + dia.toString();
      mes >= 10 ? mesString = mes.toString() : mesString = '0' + mes.toString();
      data = '$diaString/$mesString/$ano';
    } else {
      data = widget.data;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    final ChecklistData checklistData = ChecklistData();
    return data.isEmpty
        ? CalendarDatePicker(
            firstDate: hoje.subtract(Duration(days: 365)),
            lastDate: hoje,
            initialDate: hoje,
            onDateChanged: (date) {
              setState(() {
                int dia = date.day;
                int mes = date.month;
                int ano = date.year;
                String diaString;
                String mesString;
                dia >= 10
                    ? diaString = dia.toString()
                    : diaString = '0' + dia.toString();
                mes >= 10
                    ? mesString = mes.toString()
                    : mesString = '0' + mes.toString();
                data = '$diaString/$mesString/$ano';
                veiculo = '';
              });
            },
          )
        : StreamBuilder<List<Resposta>>(
            stream: checklistData.getRespostasNaoConformidade(
              data: data,
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Carregador();
              }
              List<Resposta> respostas = snapshot.data!;
              return StreamBuilder<List<Veiculo>>(
                stream: checklistData.getVeiculosPorRespostas(respostas),
                builder: (context, snp) {
                  if (!snp.hasData) {
                    return Carregador();
                  }
                  List<Veiculo> veiculos = snp.data!;
                  double width = MediaQuery.of(context).size.width;
                  if (respostas.isEmpty || veiculos.isEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.84,
                            right: width * 0.01,
                          ),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                data = '';
                                respostas = <Resposta>[];
                              });
                            },
                            child: Text(
                              'Fechar',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 100.0),
                            child: Center(
                              child: Text(
                                'Não há não conformidades nesta data!',
                                style: TextStyle(
                                  color: eiConsultoriaSilver,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    respostas = respostas
                        .where((e) => veiculos
                            .any((element) => element.placa == e.veiculo))
                        .toList();
                    List<List<DataCell>> naoConformidadeList =
                        List<List<DataCell>>.empty(growable: true);
                    List<Widget> naoConformidadeTable =
                        List<Widget>.empty(growable: true);
                    naoConformidadeTable.add(Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.84,
                        right: width * 0.01,
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            data = '';
                            respostas = <Resposta>[];
                          });
                        },
                        child: Text(
                          'Fechar',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                        ),
                      ),
                    ));
                    veiculo = respostas.first.veiculo;
                    int i = 0;
                    String empresa = veiculos[i].empresa!;
                    for (Resposta resposta in respostas) {
                      if (veiculo == resposta.veiculo) {
                        String questao =
                            '${resposta.idQuestao.toString()} - ${resposta.questao}';
                        int numLinhas = 1;
                        if (questao.length >= 50 && questao.length < 100) {
                          questao =
                              '${questao.substring(0, 50)}\n${questao.substring(50)}';
                          numLinhas = 2;
                        } else if (questao.length >= 100 &&
                            questao.length < 150) {
                          questao =
                              '${questao.substring(0, 50)}\n${questao.substring(50, 100)}\n${questao.substring(100)}';
                          numLinhas = 3;
                        } else if (questao.length >= 150 &&
                            questao.length < 200) {
                          questao =
                              '${questao.substring(0, 50)}\n${questao.substring(50, 100)}\n${questao.substring(100, 150)}\n${questao.substring(150)}';
                          numLinhas = 4;
                        }
                        String dscNC = resposta.dscNC!;
                        int numLinhasDscNC = 1;
                        if (dscNC.length >= 40 && dscNC.length < 80) {
                          dscNC =
                              '${dscNC.substring(0, 40)}\n${dscNC.substring(40)}';
                          numLinhasDscNC = 2;
                        } else if (dscNC.length >= 80 && dscNC.length < 120) {
                          dscNC =
                              '${dscNC.substring(0, 40)}\n${dscNC.substring(40, 80)}\n${dscNC.substring(80)}';
                          numLinhasDscNC = 3;
                        }
                        naoConformidadeList.add(<DataCell>[
                          DataCell(
                            Text(
                              questao,
                              maxLines: numLinhas,
                            ),
                          ),
                          DataCell(
                            Text(
                              dscNC,
                              maxLines: numLinhasDscNC,
                            ),
                          ),
                        ]);
                      } else {
                        naoConformidadeTable.add(
                          PaginatedDataTable(
                            header: Center(
                              child: Text(
                                'Relação de não conformidades - $veiculo - $empresa - $data',
                                style: TextStyle(
                                  color: eiConsultoriaGreen,
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            source: NaoConformidadeDataTableSource(
                              naoConformidadeList: naoConformidadeList,
                              context: context,
                            ),
                            columns: headerNaoConformidadeTable,
                            availableRowsPerPage: paginationSelectableRowCount,
                            onRowsPerPageChanged: (r) {
                              setState(() {
                                _rowsPerPage = r!;
                              });
                            },
                            rowsPerPage: _rowsPerPage,
                          ),
                        );
                        veiculo = resposta.veiculo;
                        i++;
                        empresa = veiculos[i].empresa!;
                        naoConformidadeList =
                            List<List<DataCell>>.empty(growable: true);
                        String questao =
                            '${resposta.idQuestao.toString()} - ${resposta.questao}';
                        int numLinhas = 1;
                        if (questao.length >= 50 && questao.length < 100) {
                          questao =
                              '${questao.substring(0, 50)}\n${questao.substring(50)}';
                          numLinhas = 2;
                        } else if (questao.length >= 100 &&
                            questao.length < 150) {
                          questao =
                              '${questao.substring(0, 50)}\n${questao.substring(50, 100)}\n${questao.substring(100)}';
                          numLinhas = 3;
                        } else if (questao.length >= 150 &&
                            questao.length < 200) {
                          questao =
                              '${questao.substring(0, 50)}\n${questao.substring(50, 100)}\n${questao.substring(100, 150)}\n${questao.substring(150)}';
                          numLinhas = 4;
                        }
                        String dscNC = resposta.dscNC!;
                        int numLinhasDscNC = 1;
                        if (dscNC.length >= 40 && dscNC.length < 80) {
                          dscNC =
                              '${dscNC.substring(0, 40)}\n${dscNC.substring(40)}';
                          numLinhasDscNC = 2;
                        } else if (dscNC.length >= 80 && dscNC.length < 120) {
                          dscNC =
                              '${dscNC.substring(0, 40)}\n${dscNC.substring(40, 80)}\n${dscNC.substring(80)}';
                          numLinhasDscNC = 3;
                        }
                        naoConformidadeList.add(<DataCell>[
                          DataCell(
                            Text(
                              questao,
                              maxLines: numLinhas,
                            ),
                          ),
                          DataCell(
                            Text(
                              dscNC,
                              maxLines: numLinhasDscNC,
                            ),
                          ),
                        ]);
                      }
                    }
                    naoConformidadeTable.add(
                      PaginatedDataTable(
                        header: Center(
                          child: Text(
                            'Relação de não conformidades - $veiculo - $empresa - $data',
                            style: TextStyle(
                              color: eiConsultoriaGreen,
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                        source: NaoConformidadeDataTableSource(
                          naoConformidadeList: naoConformidadeList,
                          context: context,
                        ),
                        columns: headerNaoConformidadeTable,
                        availableRowsPerPage: paginationSelectableRowCount,
                        onRowsPerPageChanged: (r) {
                          setState(() {
                            _rowsPerPage = r!;
                          });
                        },
                        rowsPerPage: _rowsPerPage,
                      ),
                    );
                    return ListView(
                      controller: ScrollController(),
                      children: naoConformidadeTable,
                    );
                  }
                },
              );
            },
          );
  }
}

class NaoConformidadeDataTableSource extends DataTableSource {
  List<List<DataCell>> naoConformidadeList;
  BuildContext context;

  NaoConformidadeDataTableSource({
    required this.naoConformidadeList,
    required this.context,
  });

  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
      index: index,
      cells: naoConformidadeList[index],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => naoConformidadeList.length;

  @override
  int get selectedRowCount => 0;
}
