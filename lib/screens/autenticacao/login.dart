import 'package:checklist_eiconsultoria_atmm/models/checklist_data.dart';
import 'package:checklist_eiconsultoria_atmm/screens/autenticacao/signup.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';
import '../eiconsultoria_tab_bar.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    double width = MediaQuery.of(context).size.width;
    final ChecklistData checklistData = ChecklistData();
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'logo',
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'images/logo_ei.png',
                        filterQuality: FilterQuality.high,
                        width: 150.0,
                        height: 150.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 33.0),
                        child: Text(
                          'EI Consultoria',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: eiConsultoriaRed,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
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
                    return value == '' ? 'Obrigatório!' : null;
                  },
                  onChanged: (value) {},
                  obscureText: true,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Flexible(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String resultado = await checklistData.logIn(
                        emailController.text,
                        senhaController.text,
                      );
                      if (resultado == '') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EiconsultoriaTabBar(),
                          ),
                        );
                      }
                    }
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Entrar',
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
              SizedBox(
                height: 10.0,
              ),
              Flexible(
                child: ElevatedButton(
                  onPressed: () {},
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Esqueceu a senha?',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 9.0,
                    primary: eiConsultoriaSilver,
                    padding: EdgeInsets.symmetric(
                      vertical: 15.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Flexible(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
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
                    primary: eiConsultoriaGreen,
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
    );
  }
}
