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
  DateTime diaEscolhido = DateTime.now();
  List<Resposta> respostas = List<Resposta>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    int dia = diaEscolhido.day;
    int mes = diaEscolhido.month;
    int ano = diaEscolhido.year;
    String diaString;
    String mesString;
    dia >= 10 ? diaString = dia.toString() : diaString = '0' + dia.toString();
    mes >= 10 ? mesString = mes.toString() : mesString = '0' + mes.toString();
    data = '$diaString/$mesString/$ano';
  }

  Widget semDados() {
    double width = MediaQuery.of(context).size.width;
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
                diaEscolhido = DateTime.utc(
                  int.parse(data.substring(6)),
                  int.parse(data.substring(3, 5)),
                  int.parse(data.substring(0, 2)),
                );
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
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 100.0),
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
  }

  Widget getMsgDscNcs(
    BuildContext context,
    Animation<double> a1,
    List<Widget> dscNCList,
    String veiculo,
  ) {
    final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
    return Transform(
      transform: Matrix4.translationValues(
        0.0,
        curvedValue * 200,
        0.0,
      ),
      child: AlertDialog(
        backgroundColor: eiConsultoriaGreen,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Text('Não conformidades do veículo - $veiculo'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: dscNCList,
        ),
        titleTextStyle: TextStyle(color: Colors.white),
        contentTextStyle: TextStyle(color: Colors.white),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
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
                      firstDate: DateTime.now().subtract(Duration(days: 365)),
                      lastDate: DateTime.now(),
                      initialDate: diaEscolhido,
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
                        respostas = respostas
                            .where((e) =>
                                veiculoList.any((e2) => e2.placa == e.veiculo))
                            .toList();
                        if (respostas.isEmpty && data.isNotEmpty) {
                          return semDados();
                        } else if (respostas.isNotEmpty) {
                          List<List<DataCell>> veiculosInseridosList =
                              List<List<DataCell>>.empty(growable: true);
                          List<List<String>> veiculosInseridosListPDF =
                              List<List<String>>.empty(growable: true);
                          String v = respostas.first.veiculo;
                          int ncs = 0;
                          Veiculo veiculo;
                          String localidade = respostas.first.localidade;
                          List<Widget> dscNCList =
                              List<Widget>.empty(growable: true);
                          for (Resposta resposta in respostas) {
                            if (resposta.veiculo == v) {
                              if (!resposta.ok! &&
                                  resposta.idQuestao != 58 &&
                                  resposta.dscNC!.toLowerCase() != 'na') {
                                ncs++;
                                dscNCList.add(Text(resposta.dscNC!));
                              }
                            } else {
                              veiculo = veiculoList.firstWhere(
                                (element) => element.placa == v,
                                orElse: () => Veiculo(),
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
                                          onPressed: () {
                                            /*showGeneralDialog(
                                              context: context,
                                              barrierColor:
                                                  eiConsultoriaLightGreen
                                                      .withOpacity(0.5),
                                              transitionBuilder:
                                                  (context, a1, a2, widget) {
                                                return getMsgDscNcs(
                                                  context,
                                                  a1,
                                                  dscNCList,
                                                  v,
                                                );
                                              },
                                              transitionDuration: Duration(
                                                seconds: 1,
                                              ),
                                              barrierDismissible: true,
                                              barrierLabel: '',
                                              pageBuilder: (context, a1, a2) {
                                                return getMsgDscNcs(
                                                  context,
                                                  a1,
                                                  dscNCList,
                                                  v,
                                                );
                                              },
                                            );*/
                                          },
                                          child: Text('NC\'s'),
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                Colors.yellow.shade700,
                                          ),
                                        ),
                                      )
                                    : DataCell(
                                        TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            'Ok',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          style: TextButton.styleFrom(
                                            backgroundColor: eiConsultoriaGreen,
                                          ),
                                        ),
                                      ),
                              ]);
                              dscNCList.clear();
                              v = resposta.veiculo;
                              localidade = resposta.localidade;
                              ncs = 0;
                            }
                          }
                          veiculo = veiculoList.firstWhere(
                            (element) => element.placa == v,
                            orElse: () => Veiculo(),
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
                                      onPressed: () {
                                        /*showGeneralDialog(
                                          context: context,
                                          barrierColor: eiConsultoriaLightGreen
                                              .withOpacity(0.5),
                                          transitionBuilder:
                                              (context, a1, a2, widget) {
                                            return getMsgDscNcs(
                                              context,
                                              a1,
                                              dscNCList,
                                              v,
                                            );
                                          },
                                          transitionDuration: Duration(
                                            seconds: 1,
                                          ),
                                          barrierDismissible: true,
                                          barrierLabel: '',
                                          pageBuilder: (context, a1, a2) {
                                            return getMsgDscNcs(
                                              context,
                                              a1,
                                              dscNCList,
                                              v,
                                            );
                                          },
                                        );*/
                                      },
                                      child: Text('NC\'s'),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.yellow.shade700,
                                      ),
                                    ),
                                  )
                                : DataCell(
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'OK',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor: eiConsultoriaGreen,
                                      ),
                                    ),
                                  ),
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
                                            diaEscolhido = DateTime.utc(
                                              int.parse(data.substring(6)),
                                              int.parse(data.substring(3, 5)),
                                              int.parse(data.substring(0, 2)),
                                            );
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
