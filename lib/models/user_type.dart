// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class UserType {
  int idtipousuario;
  String cargo;

  UserType({
    required this.idtipousuario,
    required this.cargo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idtipousuario': idtipousuario,
      'cargo': cargo,
    };
  }

  factory UserType.fromMap(Map<String, dynamic> map) {
    return UserType(
      idtipousuario: map['idtipousuario'] as int,
      cargo: map['cargo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserType.fromJson(String source) =>
      UserType.fromMap(json.decode(source) as Map<String, dynamic>);
}

String postToJson(UserType data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
