// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class MensagemGet {
  int idmensagem;
  int idusuario;
  int idloja;
  String titulo;
  String textomensagem;
  int idstatus;
  String created_at;
  String fantasia;
  MensagemGet({
    required this.idmensagem,
    required this.idusuario,
    required this.idloja,
    required this.titulo,
    required this.textomensagem,
    required this.idstatus,
    required this.created_at,
    required this.fantasia,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idmensagem': idmensagem,
      'idusuario': idusuario,
      'idloja': idloja,
      'titulo': titulo,
      'textomensagem': textomensagem,
      'idstatus': idstatus,
      'created_at': created_at,
      'fantasia': fantasia,
    };
  }

  factory MensagemGet.fromMap(Map<String, dynamic> map) {
    return MensagemGet(
      idmensagem: map['idmensagem'] as int,
      idusuario: map['idusuario'] as int,
      idloja: map['idloja'] as int,
      titulo: map['titulo'] as String,
      textomensagem: map['textomensagem'] as String,
      idstatus: map['idstatus'] as int,
      created_at: map['created_at'] as String,
      fantasia: map['fantasia'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MensagemGet.fromJson(String source) =>
      MensagemGet.fromMap(json.decode(source) as Map<String, dynamic>);
}
