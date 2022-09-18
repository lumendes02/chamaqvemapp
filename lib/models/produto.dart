// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class Produto {
  int idproduto;
  int idcardapio;
  String descricao;
  String preco;
  String desconto;
  Produto({
    required this.idproduto,
    required this.idcardapio,
    required this.descricao,
    required this.preco,
    required this.desconto,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idproduto': idproduto,
      'idcardapio': idcardapio,
      'descricao': descricao,
      'preco': preco,
      'desconto': desconto,
    };
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      idproduto: map['idproduto'] as int,
      idcardapio: map['idcardapio'] as int,
      descricao: map['descricao'] as String,
      preco: map['preco'] as String,
      desconto: map['desconto'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Produto.fromJson(String source) =>
      Produto.fromMap(json.decode(source) as Map<String, dynamic>);
}
