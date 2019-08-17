import 'package:flutter/material.dart';
import './http-raspvaga.dart';

class DetalheVaga extends StatelessWidget {
  final String url;
  DetalheVaga(this.url);

  Future<String> getURL() async {
    String result;
    result = await new HttpRaspVaga().readVagasHtml(this.url);
    return result == null ? "" : result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('RaspVaga - Detalhe da vaga'),
          actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.add),
              onPressed: () {
                //print("Add button clicked");
                Navigator.pop(context);
              })
        ],
        ),
        
        // drawer: new Menu().monta(context),  
        body: FutureBuilder<String>(
            future: this.getURL(),
            builder: (context, snapshot) {
               return new Material(
                 child: new Container(
                   child: new SingleChildScrollView(
                     child:  
                          Text(snapshot.connectionState == ConnectionState.done  ? snapshot.hasError ? "erro..." : snapshot.data : "Loading...", textDirection: TextDirection.ltr)
                    )
                  )
                );
            }
        )
      );
    }
}
 