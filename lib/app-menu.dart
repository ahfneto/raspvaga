import 'package:flutter/material.dart';
import './menu.dart';

class AppMenu extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    final title = 'RaspVaga - Menu';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
        title: Text(title),
        ),
        
        drawer: new Menu().monta(context),     
        body: Center( child: Text("RaspVaga")),
      ),
    );
  }
}