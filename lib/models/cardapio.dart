// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class Cardapio {
  int idcardapio;
  int idloja;
  String fantasia;
  String imagem;
  Cardapio({
    required this.idcardapio,
    required this.idloja,
    required this.fantasia,
    required this.imagem,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idcardapio': idcardapio,
      'idloja': idloja,
      'fantasia': fantasia,
      'imagem': imagem,
    };
  }

  factory Cardapio.fromMap(Map<String, dynamic> map) {
    return Cardapio(
      idcardapio: map['idcardapio'] as int,
      idloja: map['idloja'] as int,
      fantasia: map['fantasia'] as String,
      imagem: map['imagem'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cardapio.fromJson(String source) =>
      Cardapio.fromMap(json.decode(source) as Map<String, dynamic>);
}
