import 'package:checklist_eiconsultoria_atmm/models/checklist_data.dart';
import 'package:checklist_eiconsultoria_atmm/models/resposta.dart';
import 'package:checklist_eiconsultoria_atmm/models/veiculo.dart';
import 'package:checklist_eiconsultoria_atmm/widgets/carregador.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.Dart';

import '../../constants.dart';

class RelatorioDiarioInspecoesScreen extends StatefulWidget {
  @override
  _RelatorioDiarioInspecoesScreenState createState() =>
      _RelatorioDiarioInspecoesScreenState();
}

class _RelatorioDiarioInspecoesScreenState
    extends State<RelatorioDiarioInspecoesScreen> {
  int _rowsPerPage = 5;
  String data = '';
  DateTime hoje = DateTime.now();
  List<Resposta> respostas = List<Resposta>.empty(growable: true);
  List<String> dscNCList = List<String>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    int dia = hoje.day;
    int mes = hoje.month;
    int ano = hoje.year;
    String diaString;
    String mesString;
    dia >= 10 ? diaString = dia.toString() : diaString = '0' + dia.toString();
    mes >= 10 ? mesString = mes.toString() : mesString = '0' + mes.toString();
    data = '$diaString/$mesString/$ano';
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final ChecklistData checklistData = ChecklistData();
    return Consumer<List<Veiculo>>(
      builder: (context, veiculoList, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            data == ''
                ? Expanded(
                    child: CalendarDatePicker(
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
                        });
                      },
                    ),
                  )
                : Expanded(
                    child: StreamBuilder<List<Resposta>>(
                      stream: checklistData.getRespostasPorData(
                        data: data,
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Carregador();
                        }
                        respostas = snapshot.data!;
                        if (respostas.isEmpty && data.isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    data = '';
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
                              Expanded(
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 100.0),
                                  child: Center(
                                    child: Text(
                                      'Não há inserções nesta data!',
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
                        } else if (respostas.isNotEmpty) {
                          List<List<DataCell>> veiculosInseridosList =
                              List<List<DataCell>>.empty(growable: true);
                          List<List<String>> veiculosInseridosListPDF =
                              List<List<String>>.empty(growable: true);
                          String v = respostas.first.veiculo;
                          int ncs = 0;
                          dscNCList = List<String>.empty(growable: true);
                          Veiculo veiculo;
                          String localidade = respostas.first.localidade;
                          for (Resposta resposta in respostas) {
                            if (resposta.veiculo == v) {
                              if (!resposta.ok! &&
                                  resposta.idQuestao != 58 &&
                                  resposta.dscNC!.toLowerCase() != 'na') {
                                ncs++;
                                if (!dscNCList.contains(resposta.dscNC)) {
                                  dscNCList.add(resposta.dscNC!);
                                }
                              }
                            } else {
                              veiculo = veiculoList.firstWhere(
                                (element) => element.placa == v,
                              );
                              veiculosInseridosListPDF.add(<String>[
                                v,
                                veiculo.empresa!,
                                '$ncs',
                                localidade,
                              ]);
                              veiculosInseridosList.add(<DataCell>[
                                DataCell(Text(v)),
                                DataCell(Text(veiculo.empresa!)),
                                DataCell(Text('$ncs')),
                                DataCell(Text(localidade)),
                                ncs > 0
                                    ? DataCell(
                                        TextButton(
                                          onPressed: () {},
                                          child: Text('NC\'s'),
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                Colors.yellow.shade700,
                                          ),
                                        ),
                                      )
                                    : DataCell(Text('')),
                              ]);
                              v = resposta.veiculo;
                              localidade = resposta.localidade;
                              ncs = 0;
                            }
                          }
                          veiculo = veiculoList.firstWhere(
                            (element) => element.placa == v,
                          );
                          veiculosInseridosListPDF.add(<String>[
                            v,
                            veiculo.empresa!,
                            '$ncs',
                            localidade,
                          ]);
                          veiculosInseridosList.add(<DataCell>[
                            DataCell(Text(v)),
                            DataCell(Text(veiculo.empresa!)),
                            DataCell(Text('$ncs')),
                            DataCell(Text(localidade)),
                            ncs > 0
                                ? DataCell(
                                    TextButton(
                                      onPressed: () {},
                                      child: Text('NC\'s'),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.yellow.shade700,
                                      ),
                                    ),
                                  )
                                : DataCell(Text('')),
                          ]);
                          veiculosInseridosListPDF
                              .sort((a, b) => a[1].compareTo(b[1]));
                          veiculosInseridosList.sort((a, b) => a[1]
                              .child
                              .toString()
                              .compareTo(b[1].child.toString()));
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: SingleChildScrollView(
                                  controller: ScrollController(),
                                  child: PaginatedDataTable(
                                    header: Center(
                                      child: Text(
                                        'Relação de veículos inspecionados - $data',
                                        style: TextStyle(
                                          color: eiConsultoriaGreen,
                                          fontSize: 17.0,
                                        ),
                                      ),
                                    ),
                                    source:
                                        _RelatorioDiarioInspecoesDataTableSource(
                                      veiculosInspecionadosList:
                                          veiculosInseridosList,
                                      context: context,
                                    ),
                                    columns: headerVeiculosInseridosTable,
                                    availableRowsPerPage:
                                        paginationSelectableRowCount,
                                    onRowsPerPageChanged: (r) {
                                      setState(() {
                                        _rowsPerPage = r!;
                                      });
                                    },
                                    rowsPerPage: _rowsPerPage,
                                    actions: <Widget>[
                                      TextButton(
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
                                        ),
                                      ),
                                      /*TextButton(
                                        onPressed: () async {
                                          Pdf pdf = Pdf();
                                          bool salvou = await pdf
                                              .relatorioDiarioInspecoes(
                                                  veiculosInseridosListPDF);
                                          if (salvou) {
                                            showGeneralDialog(
                                              barrierColor:
                                                  eiConsultoriaLightGreen
                                                      .withOpacity(0.5),
                                              transitionBuilder:
                                                  (context, a1, a2, widget) {
                                                final curvedValue = Curves
                                                        .easeInOutBack
                                                        .transform(a1.value) -
                                                    1.0;
                                                return Transform(
                                                  transform:
                                                      Matrix4.translationValues(
                                                          0.0,
                                                          curvedValue * 200,
                                                          0.0),
                                                  child: Opacity(
                                                    opacity: a1.value,
                                                    child: AlertDialog(
                                                      backgroundColor:
                                                          eiConsultoriaGreen,
                                                      shape: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.0)),
                                                      title: Text('Salvar PDF'),
                                                      content: Text(
                                                        'Arquivo salvo com sucesso.',
                                                      ),
                                                      titleTextStyle: TextStyle(
                                                          color: Colors.white),
                                                      contentTextStyle:
                                                          TextStyle(
                                                              color:
                                                                  Colors.white),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text('OK'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          style: TextButton
                                                              .styleFrom(
                                                            primary:
                                                                Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              transitionDuration: Duration(
                                                seconds: 1,
                                              ),
                                              barrierDismissible: true,
                                              barrierLabel: '',
                                              context: context,
                                              pageBuilder: (context, a1, a2) {
                                                final curvedValue = Curves
                                                        .easeInOutBack
                                                        .transform(a1.value) -
                                                    1.0;
                                                return Transform(
                                                  transform:
                                                      Matrix4.translationValues(
                                                          0.0,
                                                          curvedValue * 200,
                                                          0.0),
                                                  child: Opacity(
                                                    opacity: a1.value,
                                                    child: AlertDialog(
                                                      backgroundColor:
                                                          eiConsultoriaGreen,
                                                      shape: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.0)),
                                                      title: Text('Salvar PDF'),
                                                      content: Text(
                                                        'Arquivo salvo com sucesso.',
                                                      ),
                                                      titleTextStyle: TextStyle(
                                                          color: Colors.white),
                                                      contentTextStyle:
                                                          TextStyle(
                                                              color:
                                                                  Colors.white),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text('OK'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          style: TextButton
                                                              .styleFrom(
                                                            primary:
                                                                Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: Icon(
                                          Icons.picture_as_pdf_rounded,
                                          color: Colors.white,
                                        ),
                                        style: TextButton.styleFrom(
                                          backgroundColor: eiConsultoriaGreen,
                                        ),
                                      ),*/
                                    ],
                                  ),
                                ),
                              ),
                              if (dscNCList.isNotEmpty)
                                Expanded(
                                  flex: 3,
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      String dscNC = dscNCList[index];
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 5.0),
                                        child: TextButton(
                                          onPressed: () {},
                                          child: ListTile(
                                            title: Text(
                                              dscNC,
                                              style: TextStyle(
                                                  color: eiConsultoriaBlue),
                                            ),
                                          ),
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                eiConsultoriaLightGreen,
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: dscNCList.length,
                                  ),
                                ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
          ],
        );
      },
    );
  }
}

class _RelatorioDiarioInspecoesDataTableSource extends DataTableSource {
  List<List<DataCell>> veiculosInspecionadosList;
  BuildContext context;

  _RelatorioDiarioInspecoesDataTableSource(
      {required this.veiculosInspecionadosList, required this.context});

  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
      index: index,
      cells: veiculosInspecionadosList[index],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => veiculosInspecionadosList.length;

  @override
  int get selectedRowCount => 0;
}
