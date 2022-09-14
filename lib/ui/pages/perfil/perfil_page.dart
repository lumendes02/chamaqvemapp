import 'dart:convert';

import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Perfil extends StatefulWidget {
  const Perfil({Key? key}) : super(key: key);

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  var data;

  Future getUserParam(id) async {
    final String idstring = id.toString();
    final response = await http
        .get(Uri.parse("http://localhost:8000/api/usuario/$idstring"));
    var jsonBody = response.body;
    var jsonData = json.decode(jsonBody);

    setState(() {
      data = jsonData;
    });

    print(jsonData);
  }

  @override
  void initState() {
    super.initState();
    getUserParam(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: Center(
        child: Column(
          children: 
        ),
      ),
    );
  }
}
