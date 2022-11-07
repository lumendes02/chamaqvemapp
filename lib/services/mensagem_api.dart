import 'dart:convert';

import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/models/mensagem.dart';
import 'package:chamaqvem/models/mensagemget.dart';
import 'package:chamaqvem/models/pedido.dart';
import 'package:chamaqvem/models/produto.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

Future<http.Response> createMensagem(idusuario, idloja) async {
  Mensagem mensagem = Mensagem(
      idmensagem: 0,
      idusuario: idusuario,
      idloja: idloja,
      titulo: 'Seu produto foi enviado!',
      textomensagem: 'Aguardando confirmação do lojeiro...',
      idstatus: 2);
  var body = mensagem.toJson();

  final response = await http.post(
    Uri.parse("$baseUrl/mensagem"),
    headers: {"Content-Type": "application/json"},
    body: body,
  );
  return response;
}

Future<List<MensagemGet>> getMensagemUsuario(idusuario) async {
  final idusuariop = idusuario.toString();
  final response = await http.get(Uri.parse("$baseUrl/mensagem/$idusuariop"));
  final List<dynamic> responseMap = jsonDecode(response.body);
  return responseMap
      .map<MensagemGet>((resp) => MensagemGet.fromMap(resp))
      .toList();
}
