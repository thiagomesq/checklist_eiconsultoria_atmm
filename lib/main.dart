import 'package:checklist_eiconsultoria_atmm/models/empresa.dart';
import 'package:checklist_eiconsultoria_atmm/models/localidade.dart';
import 'package:checklist_eiconsultoria_atmm/models/questao.dart';
import 'package:checklist_eiconsultoria_atmm/models/veiculo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:checklist_eiconsultoria_atmm/screens/eiconsultoria_tab_bar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:checklist_eiconsultoria_atmm/models/checklist_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ChecklistData checklistData = ChecklistData();
    return MultiProvider(
      providers: [
        StreamProvider.value(
          value: checklistData.getEmpresas(),
          initialData: List<Empresa>.empty(growable: true),
        ),
        StreamProvider.value(
          value: checklistData.getLocalidades(),
          initialData: List<Localidade>.empty(growable: true),
        ),
        StreamProvider.value(
          value: checklistData.getQuestoes(),
          initialData: List<Questao>.empty(growable: true),
        ),
        StreamProvider.value(
          value: checklistData.getVeiculos(),
          initialData: List<Veiculo>.empty(growable: true),
        ),
        //StreamProvider(create: (context) => checklistData.getUnidades()),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [const Locale('pt', 'BR')],
        home: EiconsultoriaTabBar(),
      ),
    );
  }
}
