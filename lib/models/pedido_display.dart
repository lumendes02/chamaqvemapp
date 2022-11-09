// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class Pedidodisplay {
  int idusuario;
  String nome;
  int idstatus;
  String quantidade;

  Pedidodisplay({
    required this.idusuario,
    required this.nome,
    required this.idstatus,
    required this.quantidade,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idusuario': idusuario,
      'nome': nome,
      'idstatus': idstatus,
      'quantidade': quantidade,
    };
  }

  factory Pedidodisplay.fromMap(Map<String, dynamic> map) {
    return Pedidodisplay(
      idusuario: map['idusuario'] as int,
      nome: map['nome'] as String,
      idstatus: map['idstatus'] as int,
      quantidade: map['quantidade'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pedidodisplay.fromJson(String source) =>
      Pedidodisplay.fromMap(json.decode(source) as Map<String, dynamic>);
}
