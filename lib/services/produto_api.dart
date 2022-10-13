import 'dart:convert';

import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/models/produto.dart';
import 'package:http/http.dart' as http;

Future<List<Produto>> getProduto() async {
  final response = await http.get(Uri.parse("$baseUrl/produto"));
  final List<dynamic> responseMap = jsonDecode(response.body);
  return responseMap.map<Produto>((resp) => Produto.fromMap(resp)).toList();
}

Future<List<Produto>> getProdutoCardapio(idcardapio) async {
  final id = idcardapio.toString();
  final response = await http.get(Uri.parse("$baseUrl/produtocardapio/$id"));
  final List<dynamic> responseMap = jsonDecode(response.body);
  return responseMap.map<Produto>((resp) => Produto.fromMap(resp)).toList();
}

Future<http.Response> createProduto(Produto produto) async {
  var body = produto.toJson();

  final response = await http.post(
    Uri.parse("$baseUrl/produto"),
    headers: {"Content-Type": "application/json"},
    body: body,
  );
  return response;
}

Future<http.Response> updateProduto(Produto produto) async {
  final id = produto.idproduto.toString();
  var body = produto.toJson();

  final response = await http.put(
    Uri.parse("$baseUrl/produto/$id"),
    headers: {"Content-Type": "application/json"},
    body: body,
  );
  return response;
}

Future<http.Response> deleteProduto(int idprodutoparam) async {
  final idloja = idprodutoparam.toString();
  final response = await http.delete(Uri.parse("$baseUrl/produto/$idloja"));
  return response;
}
