import 'package:flutter/material.dart';
import './load-vaga.dart';

class Menu extends Drawer {
  monta(context) {
    return new Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('RaspVaga'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.list),
            trailing: Icon(Icons.arrow_right),
            title: Text('Lista'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppLoadVaga(0)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.line_style),
            trailing: Icon(Icons.arrow_right),
            title: Text('Lista/Detalhe'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppLoadVaga(1)),
              );
            },
          ),
        ],
      ),
    );
  }
}
