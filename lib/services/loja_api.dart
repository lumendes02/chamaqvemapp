import 'dart:convert';

import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/models/loja.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

Future<List<Loja>> getLoja() async {
  final response = await http.get(Uri.parse("$baseUrl/loja"));
  final List<dynamic> responseMap = jsonDecode(response.body);
  return responseMap.map<Loja>((resp) => Loja.fromMap(resp)).toList();
}

Future<List<Loja>> getLojaEspecificousuario(idloja) async {
  final id = idloja.toString();
  final response = await http.get(Uri.parse("$baseUrl/loja/usuario/$id"));
  final List<dynamic> responseMap = jsonDecode(response.body);
  return responseMap.map<Loja>((resp) => Loja.fromMap(resp)).toList();
}

Future<List<Loja>> getLojaEspecifico(idusuario) async {
  final id = idusuario.toString();
  final response = await http.get(Uri.parse("$baseUrl/loja/$id"));
  final List<dynamic> responseMap = jsonDecode(response.body);
  return responseMap.map<Loja>((resp) => Loja.fromMap(resp)).toList();
}

Future<http.Response> createLoja(Loja loja) async {
  EasyLoading.show(status: 'Carregando');
  var body = loja.toJson();

  final response = await http.post(
    Uri.parse("$baseUrl/loja"),
    headers: {"Content-Type": "application/json"},
    body: body,
  );
  EasyLoading.dismiss();
  return response;
}

Future<http.Response> updateLoja(Loja loja) async {
  EasyLoading.show(status: 'Carregando');
  final id = loja.idloja.toString();
  var body = loja.toJson();

  final response = await http.put(
    Uri.parse("$baseUrl/loja/$id"),
    headers: {"Content-Type": "application/json"},
    body: body,
  );
  EasyLoading.dismiss();
  return response;
}

Future<http.Response> deleteLoja(int idlojaparam) async {
  EasyLoading.show(status: 'Carregando');
  final idloja = idlojaparam.toString();
  final response = await http.delete(Uri.parse("$baseUrl/loja/$idloja"));
  EasyLoading.dismiss();
  return response;
}
