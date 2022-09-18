import 'dart:convert';

import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/models/user.dart';
import 'package:http/http.dart' as http;

Future<User> getUser(int idparam) async {
  final response = await http.get(
    Uri.parse("$baseUrl/usuario/$idparam"),
  );
  final data = User.fromJson(response.body);
  return data;
}

Future<http.Response> createUser(User user) async {
  var body = user.toJson();
  final response = await http.post(
    Uri.parse("$baseUrl/cadastro"),
    headers: {"Content-Type": "application/json"},
    body: body,
  );
  return response;
}

Future<http.Response> desativarUser(int iduser) async {
  final id = iduser.toString();
  final response = await http.delete(Uri.parse("$baseUrl/tipousuario/$id"));
  return response;
}
