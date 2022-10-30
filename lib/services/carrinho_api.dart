import 'dart:convert';

import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/models/cardapio.dart';
import 'package:chamaqvem/models/carrinho.dart';
import 'package:chamaqvem/models/user.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

Future<List<Carrinho>> getItensCarrinhoUsuario(idusuario, idloja) async {
  final idusuariop = idusuario.toString();
  final idlojap = idloja.toString();
  final response =
      await http.get(Uri.parse("$baseUrl/carrinho/$idusuariop/$idlojap"));
  final List<dynamic> responseMap = jsonDecode(response.body);
  return responseMap.map<Carrinho>((resp) => Carrinho.fromMap(resp)).toList();
}

Future<http.Response> createItemCarrinho(Carrinho carrinho) async {
  final quantidade = await verificaIgual(carrinho);
  carrinho.quantidade = quantidade + 1;
  if (carrinho.quantidade == 1) {
    var body = carrinho.toJson();
    final response = await http.post(
      Uri.parse("$baseUrl/carrinho"),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    return response;
  } else {
    return updateQuantidade(carrinho);
  }
}

Future<http.Response> updateQuantidade(Carrinho carrinho) async {
  var body = carrinho.toJson();
  if (carrinho.quantidade != 0) {
    final response = await http.put(
      Uri.parse("$baseUrl/carrinho/"),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    return response;
  } else {
    return deleteItemCarrinho(carrinho.idcarrinho);
  }
}

Future<http.Response> deleteItemCarrinho(int idcarrinho) async {
  var id = idcarrinho;
  final response = await http.delete(Uri.parse("$baseUrl/carrinho/$id"),
      headers: {"Content-Type": "application/json"});
  EasyLoading.dismiss();
  return response;
}

Future<http.Response> ativarItens(idusuario, idloja) async {
  EasyLoading.show(status: 'Carregando');
  final response = await http.put(
      Uri.parse("$baseUrl/carrinho/$idusuario/$idloja"),
      headers: {"Content-Type": "application/json"});
  EasyLoading.dismiss();
  return response;
}

Future<int> verificaIgual(Carrinho carrinho) async {
  final idusuariop = carrinho.idusuario.toString();
  final idlojap = carrinho.idloja.toString();
  final idprodutop = carrinho.idproduto.toString();
  final response = await http
      .get(Uri.parse("$baseUrl/carrinho/$idusuariop/$idlojap/$idprodutop"));
  final responseMap = jsonDecode(response.body);
  return responseMap;
}

Future<List<User>> getUsuariosPedido(idloja) async {
  final idlojap = idloja.toString();
  final response = await http.get(Uri.parse("$baseUrl/carrinholoja/$idlojap"));
  final List<dynamic> responseMap = jsonDecode(response.body);
  return responseMap.map<User>((resp) => User.fromMap(resp)).toList();
}
