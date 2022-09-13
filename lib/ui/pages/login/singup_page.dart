import 'dart:convert';
import 'dart:ffi';
import 'package:chamaqvem/enums/button_enum.dart';
import 'package:chamaqvem/models/user_type.dart';
import 'package:chamaqvem/services/api.dart';
import 'package:chamaqvem/ui/components/alert_message.dart';
import 'package:chamaqvem/ui/components/button.dart';
import 'package:chamaqvem/ui/components/masked_textfield.dart';
import 'package:chamaqvem/ui/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;

class Singup extends StatefulWidget {
  final int? idtipousuario;
  final String? cargo;
  final bool _isApiProcess = false;

  const Singup({this.idtipousuario, this.cargo, Key? key}) : super(key: key);

  @override
  State<Singup> createState() => _SingupState();
}

class _SingupState extends State<Singup> {
  final _nomeController = TextEditingController();
  final _loginController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cargoController = TextEditingController();
  final _senhaController = TextEditingController();


  final cpfFormater = MaskTextInputFormatter(mask: '###.###.###-##');
  final celularFormater = MaskTextInputFormatter(mask: '(##) #####-####');

  @override
  void initState() {
    super.initState();
    List dropList;
    _dropApi();
    if (widget.cargo != null) {
      _cargoController.text = widget.cargo!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crie sua conta"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      TextFieldTxt(controller: _nomeController, text: 'Nome'),
                      TextFieldTxt(controller: _loginController, text: 'Login'),
                      TextFieldTxt(controller: _emailController, text: 'Email'),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              hintText: "CPF", border: OutlineInputBorder()),
                          inputFormatters: [cpfFormater],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              hintText: "Telefone",
                              border: OutlineInputBorder()),
                          inputFormatters: [celularFormater],
                        ),
                      ),
                      DropdownButton(items: dropList, onChanged: onChanged)
                      TextFieldTxt(controller: _cargoController, text: 'Cargo'),
                      TextFieldTxt(controller: _senhaController, text: 'Senha'),
                      widget.idtipousuario == null
                          ? _createButtonSubmit()
                          : _createButtonUpdate()
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _createButtonSubmit() {
    return ElevatedButton(
      onPressed: () {
        String cargo = _cargoController.text.toString().trim();
        if (cargo.isEmpty) {
          _msg(context, 'Atenção', 'Digite o nome do cargo.');
          return;
        }
        setState(() {
          UserType userType = UserType(idtipousuario: 0, cargo: cargo);
          print(postToJson(userType));
          createUserType(userType).then((response) {
            if (response.statusCode == 200) {
              Navigator.pop(context, true);
            } else {
              _msg(context, 'Atenção', 'Erro API.');
            }
          });
        });
      },
      child: const Text('Criar Cargo'),
    );
  }

  Widget _createButtonUpdate() {
    return ElevatedButton(
      onPressed: () {
        String cargo = _cargoController.text.toString().trim();
        if (cargo.isEmpty) {
          _msg(context, 'Atenção', 'Digite o nome do cargo.');
          return;
        }
        setState(() {
          UserType userType =
              UserType(idtipousuario: widget.idtipousuario!, cargo: cargo);
          updateUserType(userType).then((response) {
            if (response.statusCode == 200) {
              Navigator.pop(context, true);
            } else {
              _msg(context, 'Atenção', 'Erro API.');
            }
          });
        });
      },
      child: const Text('Editar Cargo'),
    );
  }

  void _msg(context, String title, String text) {
    AlertMessage().show(context: context, title: title, text: text, button: [
      Button(
          text: 'OK',
          type: ButtonEnum.text,
          click: () {
            Navigator.pop(context);
          }),
    ]);
  }

  void drop(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropValue = selectedValue;
      });
    }
  }

  String baseUrl = "http://localhost:8000/api";
  Future<List<UserType>> _dropApi() async {
    await http.get(Uri.parse("$baseUrl/tipousuario")).then((response) {
      var data = json.decode(response.body);

      setState(() {
        List dropList = data;
      });
    });
  }
}
