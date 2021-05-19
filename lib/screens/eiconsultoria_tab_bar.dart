import 'package:checklist_eiconsultoria_atmm/models/checklist_data.dart';
import 'package:checklist_eiconsultoria_atmm/models/usuario_eiconsultoria.dart';
import 'package:checklist_eiconsultoria_atmm/screens/home.dart';
import 'package:checklist_eiconsultoria_atmm/screens/relatorios/relatorio_diario_inspecoes.dart';
import 'package:checklist_eiconsultoria_atmm/widgets/carregador.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:checklist_eiconsultoria_atmm/screens/autenticacao/login.dart';
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
  UsuarioEIConsultoria? usuario;

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
        return HomeScreen(usuario: usuario!);
      case 2:
        return VeiculosScreen();
      case 3:
        return NaoConformidadeScreen();
      case 4:
        return RelatorioDiarioInspecoesScreen();
    }
    return LoginScreen();
  }

  Widget getMsgVerificaEmail(
    BuildContext context,
    Animation<double> a1,
  ) {
    final ChecklistData checklistData = ChecklistData();
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
        title: Text('Login'),
        content: Text(''),
        titleTextStyle: TextStyle(color: Colors.white),
        contentTextStyle: TextStyle(color: Colors.white),
        actions: <Widget>[
          TextButton(
            child: Text('Não'),
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
          ),
          TextButton(
            child: Text('Sim'),
            onPressed: () {
              checklistData.reenviarEmail();
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
  void initState() {
    super.initState();
    _telaAtual = 0;
    titulo = 'Transporte de Madeira - MG';
  }

  @override
  Widget build(BuildContext context) {
    final ChecklistData checklistData = ChecklistData();
    return StreamBuilder<List<UsuarioEIConsultoria>>(
      stream: checklistData.getUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Carregador();
        }
        usuario = snapshot.data!.isNotEmpty ? snapshot.data!.first : null;
        checklistData.carregaUsuario(usuario);
        return Scaffold(
          extendBody: true,
          appBar: usuario == null || !usuario!.isEmailVerificado
              ? null
              : AppBar(
                  backgroundColor: eiConsultoriaGreen,
                  centerTitle: true,
                  title: Text(
                    titulo,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
          drawer: usuario == null || !usuario!.isEmailVerificado
              ? null
              : Drawer(
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
                      Divider(
                        color: eiConsultoriaSilver,
                      ),
                      ListTile(
                        leading: Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                      ),
                      TextButton(
                        child: ListTile(
                          leading: Icon(Icons.exit_to_app_rounded),
                          title: Text('Logout'),
                          onTap: () async {
                            ChecklistData checklistData = ChecklistData();
                            await checklistData.logOut();
                            Navigator.push(
                              this.context,
                              MaterialPageRoute(
                                builder: (context) => EiconsultoriaTabBar(),
                              ),
                            );
                          },
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
          body: usuario == null || !usuario!.isEmailVerificado
              ? LoginScreen()
              : _pegarTela(_telaAtual),
        );
      },
    );
  }
}
