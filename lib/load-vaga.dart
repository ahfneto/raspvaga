import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher.dart';
import './lista-rasp.dart';
import './http-raspvaga.dart';
import './menu.dart';
import './detalhe-vaga.dart';
import 'dart:async';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

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
        body: this.criarBody(this.tipo),
      ),
    );
  }

  Future<List<ListaRasp>> fetchList(List<String> filter) async {
    List<ListaRasp> list = new List<ListaRasp>();
    if (listCache == null) {
      final vagas = new HttpRaspVaga();

      for (var i = 1; i < 5; i++) {
        list.addAll(await vagas.readListVagasHtml(
            "https://www.vagas.com.br/vagas-em-%20?a[]=24&ordenar_por=mais_recentes&pagina=${i}",
            i));
      }
      listCache = list;
    } else {
      list = listCache;
    }
    return list = list.where((p) => !filter.contains(p.state)).toList();
  }

  criarBody(int tipo) {
    return FutureBuilder<List<ListaRasp>>(
      future: fetchList(tipo == 1
          ? [
              'Auxiliar/Operacional',
              'Estágio',
              'Júnior/Trainee',
              'Pleno',
              'Técnico'
            ]
          : []),
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
                      EdgeInsets.only(left: 80, right: 20, top: 30, bottom: 30),
                  child: Text("Lendo..."),
                ),
                CircularProgressIndicator(),
              ],
            ));
            break;
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              switch (tipo) {
                case 0:
                case 1:
                  return createListView(context, snapshot, filter: true);
                  break;
                case 2:
                  return createListViewDetail(context, snapshot);
                default:
                  return null;
                  break;
              }
        }
      },
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot,
      {bool filter = false}) {
    List<ListaRasp> values = snapshot.data;

    return new ListView.builder(
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        var data = values[index].location + ' - ' + values[index].emp;
        return Card(
          child: InkWell(
            child: ListTile(
                title: Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      textFlex(values[index].title),
                      text(values[index].expire, cor: Colors.orange)
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      textFlex(data, cor: Colors.black45),
                      text(values[index].state, cor: Colors.black54)
                    ]),
              ],
            )),
            onTap: () async {
              new WebViewMy().nav(context, values[index].url);
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
              child: text(values[index].title),
              onTap: () async {
                new WebViewMy().nav(context, values[index].url);
              },
            ),
            subtitle: InkWell(
              child:
                  Text(values[index].content, style: TextStyle(fontSize: 12.0)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetalheVaga(values[index].url)),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Text text(String text,
          {double size = 15.0, cor = Colors.blue, font = 'Roboto'}) =>
      new Text(text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: size, fontFamily: font, color: cor));

  Flexible textFlex(String text,
          {double size = 15.0, cor = Colors.blue, font = 'Roboto'}) =>
      new Flexible(
        child: Text(text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: size, fontFamily: font, color: cor)),
      );
}

class WebViewMy {
  Future<Object> nav(context, url) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new MaterialApp(
                  routes: {
                    "/": (_) => new WebviewScaffold(
                          url: url,
                          withJavascript: true,
                          appBar: new AppBar(
                            title: Row(
                              children: <Widget>[
                                new IconButton(
                                    icon: new Icon(Icons.arrow_back),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                                new Text("Detalhe Vaga"),
                              ],
                            ),
                          ),
                          withZoom: true,
                          withLocalStorage: true,
                          hidden: true,
                          initialChild: Container(
                            color: Colors.white30,
                            child: Center(
                              child: Dialog(child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 80,
                                        right: 20,
                                        top: 30,
                                        bottom: 30),
                                    child: Text("Lendo..."),
                                  ),
                                 CircularProgressIndicator(),
                                ],
                              )),
                            ),
                          ),
                        ),
                  },
                )));
  }
}
