import 'dart:convert';

import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/models/cardapio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

Future<List<Cardapio>> getCardapio() async {
  final response = await http.get(Uri.parse("$baseUrl/cardapio"));
  final List<dynamic> responseMap = jsonDecode(response.body);
  return responseMap.map<Cardapio>((resp) => Cardapio.fromMap(resp)).toList();
}

Future<List<Cardapio>> getCardapioLoja(idloja) async {
  final id = idloja.toString();
  final response = await http.get(Uri.parse("$baseUrl/cardapioloja/$id"));
  final List<dynamic> responseMap = jsonDecode(response.body);
  return responseMap.map<Cardapio>((resp) => Cardapio.fromMap(resp)).toList();
}

Future<http.Response> createCardapio(Cardapio cardapio) async {
  EasyLoading.show(status: 'Carregando');
  var body = cardapio.toJson();

  final response = await http.post(
    Uri.parse("$baseUrl/cardapio"),
    headers: {"Content-Type": "application/json"},
    body: body,
  );
  EasyLoading.dismiss();
  return response;
}

Future<http.Response> updateCardapio(Cardapio cardapio) async {
  EasyLoading.show(status: 'Carregando');
  final id = cardapio.idcardapio.toString();
  var body = cardapio.toJson();

  final response = await http.put(
    Uri.parse("$baseUrl/cardapio/$id"),
    headers: {"Content-Type": "application/json"},
    body: body,
  );
  EasyLoading.dismiss();
  return response;
}

Future<http.Response> deleteCardapio(int idcardapioparam) async {
  EasyLoading.show(status: 'Carregando');
  final idcardapio = idcardapioparam.toString();
  final response =
      await http.delete(Uri.parse("$baseUrl/cardapio/$idcardapio"));
  EasyLoading.dismiss();
  return response;
}

Future<int> verificaUsuarioCardapio(int idusuario) async {
  final id = idusuario.toString();
  final response = await http.get(Uri.parse("$baseUrl/cardapioverifica/$id"));
  if (response.statusCode == 201) {
    return 1;
  }
  return 0;
}
