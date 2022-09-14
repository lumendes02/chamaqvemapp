import 'dart:convert';

import 'package:chamaqvem/models/user.dart';
import 'package:http/http.dart' as http;

String baseUrl = "http://localhost:8000/api";

Future<http.Response> createUser(User user) async {
  final response = await http.post(
    Uri.parse("$baseUrl/cadastro"),
    body: {
      "nome": user.nome,
      "login": user.login,
      "email": user.email,
      "cpf": user.cpf,
      "telefone": user.telefone,
      "idtipousuario": user.idtipousuario,
      "senha": user.senha
    },
  );
  return response;
}
