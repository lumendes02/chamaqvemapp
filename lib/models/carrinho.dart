// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class Carrinho {
  int idcarrinho;
  int idusuario;
  int idloja;
  int idproduto;
  String preco;
  int idstatus;
  int quantidade;
  String descricao;
  Carrinho({
    required this.idcarrinho,
    required this.idusuario,
    required this.idloja,
    required this.idproduto,
    required this.preco,
    required this.idstatus,
    required this.quantidade,
    required this.descricao,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idcarrinho': idcarrinho,
      'idusuario': idusuario,
      'idloja': idloja,
      'idproduto': idproduto,
      'preco': preco,
      'idstatus': idstatus,
      'quantidade': quantidade,
      'descricao': descricao,
    };
  }

  factory Carrinho.fromMap(Map<String, dynamic> map) {
    return Carrinho(
      idcarrinho: map['idcarrinho'] as int,
      idusuario: map['idusuario'] as int,
      idloja: map['idloja'] as int,
      idproduto: map['idproduto'] as int,
      preco: map['preco'] as String,
      idstatus: map['idstatus'] as int,
      quantidade: map['quantidade'] as int,
      descricao: map['descricao'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Carrinho.fromJson(String source) =>
      Carrinho.fromMap(json.decode(source) as Map<String, dynamic>);
}
