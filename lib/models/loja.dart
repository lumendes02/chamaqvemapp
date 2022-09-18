// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class Loja {
  int idloja;
  int idusuario;
  int idcidade;
  String fantasia;
  String endereco;
  String cnpj;
  String cep;
  Loja({
    required this.idloja,
    required this.idusuario,
    required this.idcidade,
    required this.fantasia,
    required this.endereco,
    required this.cnpj,
    required this.cep,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idloja': idloja,
      'idusuario': idusuario,
      'idcidade': idcidade,
      'fantasia': fantasia,
      'endereco': endereco,
      'cnpj': cnpj,
      'cep': cep,
    };
  }

  factory Loja.fromMap(Map<String, dynamic> map) {
    return Loja(
      idloja: map['idloja'] as int,
      idusuario: map['idusuario'] as int,
      idcidade: map['idcidade'] as int,
      fantasia: map['fantasia'] as String,
      endereco: map['endereco'] as String,
      cnpj: map['cnpj'] as String,
      cep: map['cep'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Loja.fromJson(String source) =>
      Loja.fromMap(json.decode(source) as Map<String, dynamic>);
}

String postToJson(Loja data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
