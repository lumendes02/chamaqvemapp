import 'dart:convert';

import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/models/user_type.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

Future<List<UserType>> getUserType() async {
  final response = await http.get(Uri.parse("$baseUrl/tipousuario"));
  final List<dynamic> responseMap = jsonDecode(response.body);
  return responseMap.map<UserType>((resp) => UserType.fromMap(resp)).toList();
}

Future<http.Response> createUserType(UserType userType) async {
  EasyLoading.show(status: 'Carregando');
  final response = await http
      .post(Uri.parse("$baseUrl/tipousuario"), body: {"cargo": userType.cargo});
  EasyLoading.dismiss();
  return response;
}

Future<http.Response> updateUserType(UserType userType) async {
  EasyLoading.show(status: 'Carregando');
  final id = userType.idtipousuario.toString();
  final response = await http.put(Uri.parse("$baseUrl/tipousuario/$id"),
      body: {"cargo": userType.cargo});
  EasyLoading.dismiss();
  return response;
}

Future<http.Response> deleteUserType(int idtipousuario) async {
  EasyLoading.show(status: 'Carregando');
  final id = idtipousuario.toString();
  final response = await http.delete(Uri.parse("$baseUrl/tipousuario/$id"));
  EasyLoading.dismiss();
  return response;
}
