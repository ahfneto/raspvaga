import 'dart:async';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import './lista-rasp.dart';

class HttpRaspVaga {
  Future<String> read(String url) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return '';
    }
  }

  Future<String> readVagasHtml(String url) async {
    return await read(url).then((p) => decodeVaga(p));
  }

  Future<String> decodeVaga(String body) {
    var data = parse(body)
        .documentElement
        .querySelector("article[class='vaga']")
        .querySelectorAll("div[class='texto']")
        .first;

    return Future.delayed(
        Duration(seconds: 1), () => data != null ? data.text : "");
  }

  Future<List<ListaRasp>> readListVagasHtml(String url, int pg) async {
    return await read(url).then((p) => p == null
        ? new Future.sync(() => new List<ListaRasp>())
        : decodeListVaga(p, pg));
  }

  Future<List<ListaRasp>> decodeListVaga(String body, int pg) {
    var list = new List<ListaRasp>();
      print("pagina="+pg.toString());
    var data = parse(body)
        .documentElement
        .querySelector("div[id='todasVagas']");

    var li = data.querySelectorAll("li[class]");

    for (var it in li.toList()) {
      
      var a = it.querySelector("a[class]");
      var item = new ListaRasp();
      if (a != null) {
        item.pg = pg;
        item.idVaga = a.attributes.values.elementAt(3);
        item.title = a.attributes.values.elementAt(2);
        item.url =
            "https://www.vagas.com.br" + a.attributes.values.elementAt(5);
      }

      var content = it.querySelector("p");
      if (content != null) {
        item.content = content.text;
      }

      var local = it.querySelector("span[class='vaga-local']");
      if (local != null) {
        item.location = local.text.trim();
      }

      var exp = it.querySelector("span[class='icon-relogio-24 data-publicacao']");
      if (exp != null) {
        item.expire = exp.text.trim();
      }

      var state = it.querySelector("span[class='nivelVaga']");
      if (state != null) {
        item.state = state.text.trim();
      }

      var emp = it.querySelector("span[class='emprVaga']");
      if (emp != null) {
        item.emp = emp.text.trim();
      }

      list.add(item);
    }
    //print('${pg} - list.length=' + list.length.toString());

    return Future.delayed(Duration(seconds: 1), () => list);
  }
}
