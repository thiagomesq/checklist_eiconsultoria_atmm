import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'checklist_data.dart';

class Pdf {
  ChecklistData _checklistData = ChecklistData();

  Future<bool> relatorioDiarioInspecoes(
      List<List<String>> veiculosInseridosListPDF) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          List<pw.TableRow> linhas = [
            pw.TableRow(
              children: [
                pw.Center(
                  child: pw.Text(
                    'Veículo',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Center(
                  child: pw.Text(
                    'Empresa',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Center(
                  child: pw.Text(
                    'NC\'s',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Center(
                  child: pw.Text(
                    'Localidade',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ];
          for (List<String> dados in veiculosInseridosListPDF) {
            linhas.add(
              pw.TableRow(
                children: [
                  pw.Center(
                    child: pw.Text(
                      dados[0],
                    ),
                  ),
                  pw.Text(
                    ' ${dados[1]}',
                  ),
                  pw.Center(
                    child: pw.Text(
                      dados[2],
                    ),
                  ),
                  pw.Text(
                    ' ${dados[3]}',
                  ),
                ],
              ),
            );
          }
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Center(
                child: pw.Text(
                  'Relatório Diário de Inspeções',
                  style: pw.TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              pw.SizedBox(height: 15.0),
              pw.Center(
                child: pw.Table(
                  children: linhas,
                  border: pw.TableBorder.all(),
                ),
              ),
            ],
          );
        },
      ),
    );

    String name = 'relatorio_diario_de_inspecoes.pdf';
    print(name);
    File file = File("${Directory.systemTemp.path}/$name");
    file = await file.writeAsBytes(await pdf.save());

    return Future.value(false);
  }
}
