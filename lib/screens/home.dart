import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
                color: Colors.red,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
