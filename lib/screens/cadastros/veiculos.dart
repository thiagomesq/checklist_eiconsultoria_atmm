import 'package:checklist_eiconsultoria_atmm/models/veiculo.dart';
import 'package:flutter/material.dart';
import 'package:checklist_eiconsultoria_atmm/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.Dart';

class VeiculosScreen extends StatefulWidget {
  @override
  _VeiculosScreenState createState() => _VeiculosScreenState();
}

class _VeiculosScreenState extends State<VeiculosScreen> {
  int _rowsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Consumer<List<Veiculo>>(
      builder: (context, veiculoList, child) {
        return Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(left: 0.5),
                controller: ScrollController(),
                child: PaginatedDataTable(
                  header: Center(
                    child: Text(
                      'Relação de veículos cadastrados',
                      style: TextStyle(
                        color: eiConsultoriaGreen,
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                  source: VeiculoDataTableSource(
                    veiculoList: veiculoList,
                    context: context,
                  ),
                  columns: headerVeiculoTable,
                  availableRowsPerPage: paginationSelectableRowCount,
                  onRowsPerPageChanged: (r) {
                    setState(() {
                      _rowsPerPage = r!;
                    });
                  },
                  horizontalMargin: 1.0,
                  rowsPerPage: _rowsPerPage,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class VeiculoDataTableSource extends DataTableSource {
  List<Veiculo> veiculoList;
  BuildContext context;

  VeiculoDataTableSource({required this.veiculoList, required this.context});

  @override
  DataRow getRow(int index) {
    Veiculo veiculo = veiculoList[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text(
          veiculo.empresa!,
        )),
        DataCell(Text(
          veiculo.placa!,
        )),
        DataCell(Text(
          veiculo.tipo!,
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => veiculoList.length;

  @override
  int get selectedRowCount => 0;
}
