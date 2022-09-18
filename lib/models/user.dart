// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class User {
  int idusuario;
  String nome;
  String login;
  String email;
  String cpf;
  String telefone;
  int idtipousuario;
  String senha;
  User({
    required this.idusuario,
    required this.nome,
    required this.login,
    required this.email,
    required this.cpf,
    required this.telefone,
    required this.idtipousuario,
    required this.senha,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idusuario': idusuario,
      'nome': nome,
      'login': login,
      'email': email,
      'cpf': cpf,
      'telefone': telefone,
      'idtipousuario': idtipousuario,
      'senha': senha,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      idusuario: map['idusuario'] as int,
      nome: map['nome'] as String,
      login: map['login'] as String,
      email: map['email'] as String,
      cpf: map['cpf'] as String,
      telefone: map['telefone'] as String,
      idtipousuario: map['idtipousuario'] as int,
      senha: map['senha'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
