import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import './lista-rasp.dart';
import './http-raspvaga.dart';
import './menu.dart';
import './detalhe-vaga.dart';
import 'dart:async';

List<ListaRasp> listCache;

class AppLoadVaga extends StatelessWidget {
  final int tipo;
  AppLoadVaga(this.tipo);
  
  @override
  Widget build(BuildContext context) {
    final title = 'RaspVaga';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
         drawer: new Menu().monta(context),  
        body: this._criarBody(this.tipo),
      ),
    );
  }

  Future<List<ListaRasp>> fetchList() async {
    List<ListaRasp> list = new List<ListaRasp>();
    if(listCache==null){
      final vagas = new HttpRaspVaga();

      for (var i = 0; i < 5; i++) {
        list.addAll(await vagas.readListVagasHtml(
            "https://www.vagas.com.br/vagas-em-%20?a[]=24&ordenar_por=mais_recentes&pagina=${i}",
            i));
      }
      listCache = list;
    }else{
      list = listCache;
    }
    return list;
  }
  
  _criarBody(int tipo) {
    return FutureBuilder<List<ListaRasp>>(
      future: fetchList(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Dialog(
                child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 80, right: 10, top: 15, bottom: 15),
                  child: Text("Loading..."),
                ),
                CircularProgressIndicator(),
              ],
            ));  
            break;
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return tipo==1 ? createListViewDetail(context, snapshot) : createListView(context, snapshot);
        }
      },
    );
  }

 Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<ListaRasp> values = snapshot.data;
    return new ListView.builder(
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: InkWell(
            child:  ListTile(
              title: Container(
                child: Text(
                    "(${index == null ? 0 : index + 1})(${values[index].idVaga}) " +
                        values[index].title,
                    style: TextStyle(fontSize: 14.0, color: Colors.blue)),
              ),
            ),
              onTap: () async {
                if (await canLaunch(values[index].url)) {
                  await launch(values[index].url);
                }
              },
          ),
        );
      },
    );
  }
  
  Widget createListViewDetail(BuildContext context, AsyncSnapshot snapshot) {
    List<ListaRasp> values = snapshot.data;
    return new ListView.builder(
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            title: InkWell(
              child: Container(
                child: Text(
                    "(${index == null ? 0 : index + 1})(${values[index].idVaga}) " +
                        values[index].title,
                    style: TextStyle(fontSize: 14.0, color: Colors.blue)),
              ),
              onTap: () async {
                if (await canLaunch(values[index].url)) {
                  await launch(values[index].url);
                }
              },
            ),
            subtitle: InkWell(
              child: Text(
                  "(${values[index].content.length})" + values[index].content,
                  style: TextStyle(fontSize: 12.0)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute( builder: (context) => DetalheVaga(values[index].url)),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
