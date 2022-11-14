import 'dart:convert';

import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/models/mensagem.dart';
import 'package:chamaqvem/models/mensagemget.dart';
import 'package:http/http.dart' as http;

Future<http.Response> createMensagem(
    idusuario, idloja, int idpedido, acao) async {
  Mensagem mensagem = Mensagem(
      idmensagem: 0,
      idusuario: 0,
      idloja: 0,
      titulo: '',
      textomensagem: '',
      idstatus: 0,
      idpedido: 0);
  if (acao == 'ativar') {
    mensagem = Mensagem(
        idmensagem: 0,
        idusuario: idusuario,
        idloja: idloja,
        titulo: 'Seu pedido foi enviado!',
        textomensagem: 'Aguardando confirmação do lojeiro...',
        idstatus: 2,
        idpedido: idpedido);
  } else if (acao == 'recusar') {
    mensagem = Mensagem(
        idmensagem: 0,
        idusuario: idusuario,
        idloja: idloja,
        titulo: 'Seu pedido foi recusado.',
        textomensagem: 'Infelizmente o lojeiro recusou seu pedido.',
        idstatus: 3,
        idpedido: idpedido);
  } else if (acao == 'confirmar') {
    mensagem = Mensagem(
        idmensagem: 0,
        idusuario: idusuario,
        idloja: idloja,
        titulo: 'Seu pedido foi aceito!',
        textomensagem: 'Aguardando finalizar para fazer entrega',
        idstatus: 4,
        idpedido: idpedido);
  } else if (acao == 'caminho') {
    mensagem = Mensagem(
        idmensagem: 0,
        idusuario: idusuario,
        idloja: idloja,
        titulo: 'Seu pedido esta a caminho!',
        textomensagem: 'Obrigado pela preferencia :D',
        idstatus: 5,
        idpedido: idpedido);
  }

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
