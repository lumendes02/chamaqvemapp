import 'dart:ffi';
import 'package:chamaqvem/enums/button_enum.dart';
import 'package:chamaqvem/models/user_type.dart';
import 'package:chamaqvem/services/api.dart';
import 'package:chamaqvem/ui/components/alert_message.dart';
import 'package:chamaqvem/ui/components/button.dart';
import 'package:chamaqvem/ui/components/text_field.dart';
import 'package:flutter/material.dart';

class FormUserType extends StatefulWidget {
  final int? idtipousuario;
  final String? cargo;
  final bool _isApiProcess = false;

  const FormUserType({this.idtipousuario, this.cargo, Key? key})
      : super(key: key);

  @override
  State<FormUserType> createState() => _FormUserTypeState();
}

class _FormUserTypeState extends State<FormUserType> {
  final _cargoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.cargo != null) {
      _cargoController.text = widget.cargo!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulario Tipo Usuario"),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    TextFieldTxt(controller: _cargoController, text: 'Cargo'),
                    widget.idtipousuario == null
                        ? _createButtonSubmit()
                        : _createButtonUpdate()
                  ],
                ),
              ],
            )),
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
}
