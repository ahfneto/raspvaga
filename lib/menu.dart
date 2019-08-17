import 'package:flutter/material.dart';
import './load-vaga.dart';

class Menu {
  monta(context) {
    return new Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Row(
              children: <Widget>[
                     Text('RaspVaga'),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          itemMenu('Lista/Geral',context,0),
          itemMenu('Lista/Sênior',context,1),
          itemMenu('Lista/Detalhe',context,2)
        ],
      ),
    );
  }

  ListTile itemMenu(String text, context, tipo) => ListTile(
        leading: Icon(Icons.line_style),
        trailing: Icon(Icons.arrow_right),
        title: Text(text),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppLoadVaga(tipo)),
          );
        },
      );
}
