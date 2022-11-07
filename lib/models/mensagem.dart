// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class Mensagem {
  int idmensagem;
  int idusuario;
  int idloja;
  String titulo;
  String textomensagem;
  int idstatus;
  Mensagem({
    required this.idmensagem,
    required this.idusuario,
    required this.idloja,
    required this.titulo,
    required this.textomensagem,
    required this.idstatus,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idmensagem': idmensagem,
      'idusuario': idusuario,
      'idloja': idloja,
      'titulo': titulo,
      'textomensagem': textomensagem,
      'idstatus': idstatus,
    };
  }

  factory Mensagem.fromMap(Map<String, dynamic> map) {
    return Mensagem(
      idmensagem: map['idmensagem'] as int,
      idusuario: map['idusuario'] as int,
      idloja: map['idloja'] as int,
      titulo: map['titulo'] as String,
      textomensagem: map['textomensagem'] as String,
      idstatus: map['idstatus'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Mensagem.fromJson(String source) =>
      Mensagem.fromMap(json.decode(source) as Map<String, dynamic>);
}
