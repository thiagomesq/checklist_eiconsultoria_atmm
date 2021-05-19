import 'package:checklist_eiconsultoria_atmm/models/checklist_data.dart';
import 'package:checklist_eiconsultoria_atmm/models/empresa.dart';
import 'package:checklist_eiconsultoria_atmm/models/usuario_eiconsultoria.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../eiconsultoria_tab_bar.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmaSenhaController = TextEditingController();
  static final String _empresaDefault = 'Selecione a empresa';
  String selectedEmpresa = _empresaDefault;
  String? _senha;
  double forcaSenha = 0.0;

  Widget getMsgSignup(
    BuildContext context,
    Animation<double> a1,
    String resultado,
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
        title: Text('Login'),
        content: Text(resultado),
        titleTextStyle: TextStyle(color: Colors.white),
        contentTextStyle: TextStyle(color: Colors.white),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EiconsultoriaTabBar(),
                ),
              );
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
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    double width = MediaQuery.of(context).size.width;
    final ChecklistData checklistData = ChecklistData();
    return Consumer<List<Empresa>>(
      builder: (context, empresaList, child) {
        List<DropdownMenuItem<String>> empresaItems =
            List<DropdownMenuItem<String>>.empty(growable: true);
        empresaItems.add(
          DropdownMenuItem<String>(
            child: Text(_empresaDefault),
            value: _empresaDefault,
          ),
        );
        empresaItems.add(
          DropdownMenuItem<String>(
            child: Text('Veracel'),
            value: 'Veracel',
          ),
        );
        for (Empresa empresa in empresaList) {
          empresaItems.add(
            DropdownMenuItem<String>(
              child: Text(empresa.nome),
              value: empresa.nome,
            ),
          );
        }
        return Scaffold(
          body: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.12),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: nomeController,
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          suffixIcon: Icon(
                            Icons.account_circle_rounded,
                            color: eiConsultoriaSilver,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: eiConsultoriaGreen,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: eiConsultoriaBlue,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: eiConsultoriaRed,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: eiConsultoriaBlue,
                            ),
                          ),
                          errorStyle: TextStyle(color: eiConsultoriaRed),
                          isDense: true,
                          fillColor: eiConsultoriaLightGreen,
                          focusColor: eiConsultoriaGreen,
                          labelStyle: TextStyle(color: eiConsultoriaBlue),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Obrigatório!';
                          }
                          return null;
                        },
                        onChanged: (value) {},
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          suffixIcon: Icon(
                            Icons.alternate_email,
                            color: eiConsultoriaSilver,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: eiConsultoriaGreen,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: eiConsultoriaBlue,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: eiConsultoriaRed,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: eiConsultoriaBlue,
                            ),
                          ),
                          errorStyle: TextStyle(color: eiConsultoriaRed),
                          isDense: true,
                          fillColor: eiConsultoriaLightGreen,
                          focusColor: eiConsultoriaGreen,
                          labelStyle: TextStyle(color: eiConsultoriaBlue),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Obrigatório!';
                          }
                          if (!EmailValidator.validate(value)) {
                            return 'E-mail inválido!';
                          }
                          return null;
                        },
                        onChanged: (value) {},
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: senhaController,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          suffixIcon: Icon(
                            Icons.lock_outline,
                            color: eiConsultoriaSilver,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: eiConsultoriaGreen,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: eiConsultoriaBlue,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: eiConsultoriaRed,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: eiConsultoriaBlue,
                            ),
                          ),
                          errorStyle: TextStyle(color: eiConsultoriaRed),
                          isDense: true,
                          fillColor: eiConsultoriaLightGreen,
                          focusColor: eiConsultoriaGreen,
                          labelStyle: TextStyle(color: eiConsultoriaBlue),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Obrigatório';
                          }
                          if (forcaSenha <= 0.69) {
                            return 'Senha fraca!';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _senha = value;
                          });
                        },
                        obscureText: true,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    FlutterPasswordStrength(
                      password: _senha,
                      height: 20.0,
                      radius: 30.0,
                      backgroundColor: eiConsultoriaSilver,
                      strengthCallback: (value) {
                        print(value);
                        forcaSenha = value;
                      },
                    ),
                    SizedBox(
                      height: 22.0,
                      child: Text(
                        'Força da senha',
                        style: TextStyle(
                          color: eiConsultoriaBlue,
                        ),
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: confirmaSenhaController,
                        decoration: InputDecoration(
                          labelText: 'Confirmar Senha',
                          suffixIcon: Icon(
                            Icons.lock_outline,
                            color: eiConsultoriaSilver,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: eiConsultoriaGreen,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: eiConsultoriaBlue,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: eiConsultoriaRed,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: eiConsultoriaBlue,
                            ),
                          ),
                          errorStyle: TextStyle(color: eiConsultoriaRed),
                          isDense: true,
                          fillColor: eiConsultoriaLightGreen,
                          focusColor: eiConsultoriaGreen,
                          labelStyle: TextStyle(color: eiConsultoriaBlue),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Obrigatório!';
                          }
                          if (value != senhaController.text) {
                            return 'Senhas não conferem!';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Flexible(
                      child: DropdownButtonFormField<String>(
                        value: selectedEmpresa,
                        items: empresaItems,
                        onChanged: (value) {
                          setState(() {
                            selectedEmpresa = value!;
                          });
                        },
                        onSaved: (value) {
                          setState(() {
                            selectedEmpresa = _empresaDefault;
                          });
                        },
                        validator: (value) {
                          return value == _empresaDefault
                              ? 'Selecione uma empresa válida.'
                              : null;
                        },
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Empresa',
                          labelStyle: TextStyle(color: eiConsultoriaBlue),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: eiConsultoriaGreen,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: eiConsultoriaBlue,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: eiConsultoriaRed,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: eiConsultoriaBlue,
                            ),
                          ),
                          errorStyle: TextStyle(color: eiConsultoriaRed),
                          isDense: true,
                          fillColor: eiConsultoriaLightGreen,
                          focusColor: eiConsultoriaGreen,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            UsuarioEIConsultoria usuario = UsuarioEIConsultoria(
                              empresa: selectedEmpresa,
                              email: emailController.text,
                              nome: nomeController.text,
                              isEmailVerificado: false,
                            );
                            String resultado = await checklistData
                                .createUsuario(usuario, _senha!);
                            showGeneralDialog(
                              context: context,
                              barrierColor:
                                  eiConsultoriaLightGreen.withOpacity(0.5),
                              transitionBuilder: (context, a1, a2, widget) {
                                return getMsgSignup(context, a1, resultado);
                              },
                              transitionDuration: Duration(
                                seconds: 1,
                              ),
                              barrierDismissible: true,
                              barrierLabel: '',
                              pageBuilder: (context, a1, a2) {
                                return getMsgSignup(context, a1, resultado);
                              },
                            );
                          }
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Cadastrar',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 9.0,
                          primary: eiConsultoriaBlue,
                          padding: EdgeInsets.symmetric(
                            vertical: 15.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
