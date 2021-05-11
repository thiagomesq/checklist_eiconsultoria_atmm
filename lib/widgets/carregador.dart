import 'package:flutter/material.dart';

import '../constants.dart';

class Carregador extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: eiConsultoriaLightGreen,
        valueColor: AlwaysStoppedAnimation<Color>(
          eiConsultoriaGreen,
        ),
      ),
    );
  }
}
