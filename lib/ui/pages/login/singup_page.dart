import 'dart:convert';
import 'dart:ffi';
import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/enums/button_enum.dart';
import 'package:chamaqvem/models/user.dart';
import 'package:chamaqvem/models/user_type.dart';
import 'package:chamaqvem/services/tipousuario_api.dart';
import 'package:chamaqvem/services/usuario_api.dart';
import 'package:chamaqvem/ui/components/alert_message.dart';
import 'package:chamaqvem/ui/components/button.dart';
import 'package:chamaqvem/ui/components/masked_textfield.dart';
import 'package:chamaqvem/ui/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  String? selectedCargo;

  List? data;

  Future GetAllCargos() async {
    final response =
        await http.get(Uri.parse("http://localhost:8000/api/tipousuario"));
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
    GetAllCargos();
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
                          controller: _cpfController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              hintText: "CPF", border: OutlineInputBorder()),
                          inputFormatters: [cpfFormater],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _telefoneController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              hintText: "Telefone",
                              border: OutlineInputBorder()),
                          inputFormatters: [celularFormater],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: DecoratedBox(
                            decoration: BoxDecoration(
                              //background color of dropdown button
                              border: Border.all(
                                  color: Colors.black38,
                                  width: 1), //border of dropdown button
                              borderRadius: BorderRadius.circular(
                                  5), //border raiuds of dropdown button
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(0.0),
                              child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: selectedCargo,
                                    iconSize: 30,
                                    icon: (null),
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                    ),
                                    hint: Text('Cargo'),
                                    items: data?.map(
                                      (list) {
                                        return DropdownMenuItem(
                                          child: Text(list['cargo']),
                                          value:
                                              list['idtipousuario'].toString(),
                                        );
                                      },
                                    ).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCargo = value as String?;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            )),
                      ),
                      TextFieldTxt(controller: _senhaController, text: 'Senha'),
                      _createButtonSubmit()
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  replace(String string) {
    string = string.replaceAll('.', '');
    string = string.replaceAll('-', '');
    string = string.replaceAll('(', '');
    string = string.replaceAll(')', '');
    string = string.replaceAll('.', '');
    string = string.replaceAll(' ', '');
    return string;
  }

  Widget _createButtonSubmit() {
    return ElevatedButton(
      onPressed: () {
        String nome = _nomeController.text.toString().trim();
        String login = _loginController.text.toString().trim();
        String email = _emailController.text.toString().trim();
        String cpf = replace(_cpfController.text.toString().trim());
        String telefone = replace(_telefoneController.text.toString().trim());
        String idtipousuario = selectedCargo!;
        String senha = _senhaController.text.toString().trim();
        setState(() {
          User user = User(
              idusuario: 0,
              nome: nome,
              login: login,
              email: email,
              cpf: cpf,
              telefone: telefone,
              idtipousuario: idtipousuario,
              senha: senha);
          createUser(user).then((response) {
            if (response.statusCode == 201) {
              Navigator.pop(context, true);
            } else {
              _msg(context, 'Atenção', response.body);
            }
          });
        });
      },
      child: const Text('Criar Cargo'),
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
}
