// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class Pedido {
  int idproduto;
  int idcardapio;
  String descricao;
  String preco;
  String desconto;
  int idcarrinho;
  int idusuario;
  int idloja;
  int idstatus;
  int quantidade;
  Pedido({
    required this.idproduto,
    required this.idcardapio,
    required this.descricao,
    required this.preco,
    required this.desconto,
    required this.idcarrinho,
    required this.idusuario,
    required this.idloja,
    required this.idstatus,
    required this.quantidade,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idproduto': idproduto,
      'idcardapio': idcardapio,
      'descricao': descricao,
      'preco': preco,
      'desconto': desconto,
      'idcarrinho': idcarrinho,
      'idusuario': idusuario,
      'idloja': idloja,
      'idstatus': idstatus,
      'quantidade': quantidade,
    };
  }

  factory Pedido.fromMap(Map<String, dynamic> map) {
    return Pedido(
      idproduto: map['idproduto'] as int,
      idcardapio: map['idcardapio'] as int,
      descricao: map['descricao'] as String,
      preco: map['preco'] as String,
      desconto: map['desconto'] as String,
      idcarrinho: map['idcarrinho'] as int,
      idusuario: map['idusuario'] as int,
      idloja: map['idloja'] as int,
      idstatus: map['idstatus'] as int,
      quantidade: map['quantidade'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pedido.fromJson(String source) =>
      Pedido.fromMap(json.decode(source) as Map<String, dynamic>);
}
