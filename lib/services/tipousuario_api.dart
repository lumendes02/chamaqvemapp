import 'dart:convert';

import 'package:chamaqvem/models/user_type.dart';
import 'package:http/http.dart' as http;

String baseUrl = "http://localhost:8000/api";

Future<List<UserType>> getUserType() async {
  final response = await http.get(Uri.parse("$baseUrl/tipousuario"));
  final List<dynamic> responseMap = jsonDecode(response.body);
  return responseMap.map<UserType>((resp) => UserType.fromMap(resp)).toList();
}

Future<http.Response> createUserType(UserType userType) async {
  final response = await http
      .post(Uri.parse("$baseUrl/tipousuario"), body: {"cargo": userType.cargo});
  return response;
}

Future<http.Response> updateUserType(UserType userType) async {
  final id = userType.idtipousuario.toString();
  final response = await http.put(Uri.parse("$baseUrl/tipousuario/$id"),
      body: {"cargo": userType.cargo});
  return response;
}

Future<http.Response> deleteUserType(int idtipousuario) async {
  final id = idtipousuario.toString();
  final response = await http.delete(Uri.parse("$baseUrl/tipousuario/$id"));
  return response;
}
