import 'dart:convert';
import 'package:chamaqvem/enums/button_enum.dart';
import 'package:chamaqvem/models/user.dart';
import 'package:chamaqvem/services/usuario_api.dart';
import 'package:chamaqvem/ui/components/Util_functions.dart';
import 'package:chamaqvem/ui/components/alert_message.dart';
import 'package:chamaqvem/ui/components/button.dart';
import 'package:chamaqvem/ui/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;

class FormPerfil extends StatefulWidget {
  final User? usuario;
  final bool? editar;
  final bool _isApiProcess = false;

  const FormPerfil({this.usuario, this.editar, Key? key}) : super(key: key);

  @override
  State<FormPerfil> createState() => _FormPerfilState();
}

class _FormPerfilState extends State<FormPerfil> {
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
    EasyLoading.show(status: 'Carregando');
    final response =
        await http.get(Uri.parse("http://localhost:8000/api/tipousuario"));
    var jsonBody = response.body;
    var jsonData = json.decode(jsonBody);

    setState(() {
      data = jsonData;
      EasyLoading.dismiss();
    });

    print(jsonData);
  }

  @override
  void initState() {
    super.initState();
    GetAllCargos();
    if (widget.editar == true) {
      _nomeController.text = widget.usuario!.nome;
      _loginController.text = widget.usuario!.login;
      _emailController.text = widget.usuario!.email;
      _cpfController.text = widget.usuario!.cpf;
      _telefoneController.text = widget.usuario!.telefone;
      _senhaController.text = widget.usuario!.senha;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Conta"),
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
        setState(() {
          User user = User(
              idusuario: widget.usuario!.idusuario,
              nome: nome,
              login: login,
              email: email,
              cpf: cpf,
              telefone: telefone,
              idtipousuario: 0,
              senha: 'senha');
          updateUser(user).then((response) {
            if (response.statusCode == 200) {
              ShowSnackBarMSG(context, 'Usuario editado');
              Navigator.pop(context, true);
            } else {
              _msg(context, 'Atenção', response.body);
            }
          });
        });
      },
      child: const Text('Editar Perfil'),
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
