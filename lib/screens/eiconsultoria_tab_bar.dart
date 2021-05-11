import 'package:checklist_eiconsultoria_atmm/screens/home.dart';
import 'package:checklist_eiconsultoria_atmm/screens/relatorios/relatorio_diario_inspecoes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:checklist_eiconsultoria_atmm/screens/cadastros/veiculos.dart';
import 'package:checklist_eiconsultoria_atmm/screens/relatorios/relatorio_diario_nao_conformidades.dart';
import 'package:checklist_eiconsultoria_atmm/constants.dart';

class EiconsultoriaTabBar extends StatefulWidget {
  @override
  _EiconsultoriaTabBarState createState() => _EiconsultoriaTabBarState();
}

class _EiconsultoriaTabBarState extends State<EiconsultoriaTabBar> {
  late int _telaAtual;
  late String titulo;

  void _mudarTelaAtual(int tela) {
    setState(() {
      _telaAtual = tela;
      switch (tela) {
        case 0:
          titulo = 'Transporte de Madeira - MG';
          break;
        case 2:
          titulo = 'Cadastro de Veículos e Equipamentos';
          break;
        case 3:
          titulo = 'Relatório Diário de Não Conformidades';
          break;
        case 4:
          titulo = 'Relatório Diário de Inspeções';
          break;
      }
    });
    Navigator.of(context).pop();
  }

  Widget _pegarTela(int tela) {
    switch (tela) {
      case 0:
        return HomeScreen();
      case 2:
        return VeiculosScreen();
      case 3:
        return NaoConformidadeScreen();
      case 4:
        return RelatorioDiarioInspecoesScreen();
    }
    return Container();
  }

  @override
  void initState() {
    super.initState();
    _telaAtual = 0;
    titulo = 'Transporte de Madeira - MG';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: eiConsultoriaGreen,
        centerTitle: true,
        title: Text(
          titulo,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: eiConsultoriaGreen,
              ),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                  ),
                ),
              ),
            ),
            TextButton(
              child: ListTile(
                leading: Icon(Icons.home),
                title: Text('Tela Inicial'),
                selected: _telaAtual == 0,
                onTap: () {
                  _mudarTelaAtual(0);
                },
              ),
              onPressed: () {},
            ),
            Divider(
              color: eiConsultoriaSilver,
            ),
            ListTile(
              leading: Text(
                'Cadastros',
                style: TextStyle(
                  color: Colors.black45,
                ),
              ),
            ),
            TextButton(
              child: ListTile(
                leading: Icon(Icons.local_shipping),
                title: Text('Veículos e Equipamentos'),
                selected: _telaAtual == 2,
                onTap: () {
                  _mudarTelaAtual(2);
                },
              ),
              onPressed: () {},
            ),
            Divider(
              color: eiConsultoriaSilver,
            ),
            ListTile(
              leading: Text(
                'Relatórios',
                style: TextStyle(
                  color: Colors.black45,
                ),
              ),
            ),
            TextButton(
              child: ListTile(
                leading: Icon(Icons.assessment),
                title: Text('Relatório Diário de Inspeções'),
                selected: _telaAtual == 4,
                onTap: () {
                  _mudarTelaAtual(4);
                },
              ),
              onPressed: () {},
            ),
            TextButton(
              child: ListTile(
                leading: Icon(Icons.assessment),
                title: Text('Relatório Diário de Não Conformidades'),
                selected: _telaAtual == 3,
                onTap: () {
                  _mudarTelaAtual(3);
                },
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: _pegarTela(_telaAtual),
    );
  }
}
