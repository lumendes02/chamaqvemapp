// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class Pedidodisplay {
  int idusuario;
  String nome;
  int idstatus;
  String quantidade;
  int idpedido;

  Pedidodisplay({
    required this.idusuario,
    required this.nome,
    required this.idstatus,
    required this.quantidade,
    required this.idpedido,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idusuario': idusuario,
      'nome': nome,
      'idstatus': idstatus,
      'quantidade': quantidade,
      'idpedido': idpedido,
    };
  }

  factory Pedidodisplay.fromMap(Map<String, dynamic> map) {
    return Pedidodisplay(
      idusuario: map['idusuario'] as int,
      nome: map['nome'] as String,
      idstatus: map['idstatus'] as int,
      quantidade: map['quantidade'] as String,
      idpedido: map['idpedido'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pedidodisplay.fromJson(String source) =>
      Pedidodisplay.fromMap(json.decode(source) as Map<String, dynamic>);
}
