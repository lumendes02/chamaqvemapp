import 'dart:convert';

import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/models/user.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

Future<User> getUser(int idparam) async {
  final response = await http.get(
    Uri.parse("$baseUrl/usuario/$idparam"),
  );
  final data = User.fromJson(response.body);
  return data;
}

Future<http.Response> createUser(User user) async {
  EasyLoading.show(status: 'Carregando');
  var body = user.toJson();
  final response = await http.post(
    Uri.parse("$baseUrl/cadastro"),
    headers: {"Content-Type": "application/json"},
    body: body,
  );
  EasyLoading.dismiss();
  return response;
}

Future<http.Response> updateUser(User user) async {
  EasyLoading.show(status: 'Carregando');
  final id = user.idusuario.toString();
  var body = user.toJson();
  final response = await http.put(
    Uri.parse("$baseUrl/usuario/$id"),
    headers: {"Content-Type": "application/json"},
    body: body,
  );
  EasyLoading.dismiss();
  return response;
}

Future<http.Response> desativarUser(int iduser) async {
  EasyLoading.show(status: 'Carregando');
  final id = iduser.toString();
  final response = await http.delete(Uri.parse("$baseUrl/tipousuario/$id"));
  EasyLoading.dismiss();
  return response;
}
