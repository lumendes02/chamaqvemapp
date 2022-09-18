import 'dart:convert';

import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/models/loja.dart';
import 'package:http/http.dart' as http;

Future<List<Loja>> getLoja() async {
  final response = await http.get(Uri.parse("$baseUrl/loja"));
  final List<dynamic> responseMap = jsonDecode(response.body);
  return responseMap.map<Loja>((resp) => Loja.fromMap(resp)).toList();
}

Future<http.Response> createLoja(Loja loja) async {
  var body = loja.toJson();

  final response = await http.post(
    Uri.parse("$baseUrl/loja"),
    headers: {"Content-Type": "application/json"},
    body: body,
  );
  return response;
}

Future<http.Response> updateLoja(Loja loja) async {
  final id = loja.idloja.toString();
  var body = loja.toJson();

  final response = await http.put(
    Uri.parse("$baseUrl/loja/$id"),
    headers: {"Content-Type": "application/json"},
    body: body,
  );
  return response;
}

Future<http.Response> deleteLoja(int idlojaparam) async {
  final idloja = idlojaparam.toString();
  final response = await http.delete(Uri.parse("$baseUrl/loja/$idloja"));
  return response;
}
