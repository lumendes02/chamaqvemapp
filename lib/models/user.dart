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
  String idtipousuario;
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
}
