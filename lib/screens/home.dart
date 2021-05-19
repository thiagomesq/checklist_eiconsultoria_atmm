import 'package:checklist_eiconsultoria_atmm/models/usuario_eiconsultoria.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';

import '../constants.dart';

class HomeScreen extends StatelessWidget {
  final UsuarioEIConsultoria usuario;

  HomeScreen({required this.usuario});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Hero(
      tag: 'logo',
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Center(
                child: Text(
                  'Bem vindo, ${usuario.nome}',
                  style: TextStyle(
                    fontSize: 37.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Image.asset(
              'images/logo_ei.png',
              filterQuality: FilterQuality.high,
              width: 250.0,
              height: 250.0,
            ),
            SizedBox(
              height: 7.0,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                'EI Consultoria',
                style: TextStyle(
                  fontSize: 30.0,
                  color: eiConsultoriaRed,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
