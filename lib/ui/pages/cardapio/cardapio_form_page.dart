import 'dart:convert';
import 'package:chamaqvem/enums/button_enum.dart';
import 'package:chamaqvem/models/cardapio.dart';
import 'package:chamaqvem/models/loja.dart';
import 'package:chamaqvem/services/cardapio_api.dart';
import 'package:chamaqvem/services/loja_api.dart';
import 'package:chamaqvem/ui/components/alert_message.dart';
import 'package:chamaqvem/ui/components/button.dart';
import 'package:chamaqvem/ui/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FormCardapio extends StatefulWidget {
  final Cardapio? cardapio;
  final bool? editar;

  const FormCardapio({this.cardapio, this.editar, Key? key}) : super(key: key);

  @override
  State<FormCardapio> createState() => _FormCardapioState();
}

class _FormCardapioState extends State<FormCardapio> {
  final _fantasiaController = TextEditingController();

  String? selectedLoja;

  List? data;

  Future GetAllLojas() async {
    final response =
        await http.get(Uri.parse("http://localhost:8000/api/loja"));
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
    GetAllLojas();
    if (widget.editar == true) {
      _fantasiaController.text = widget.cardapio!.fantasia;
      selectedLoja = widget.cardapio!.idloja.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulario Cardapio"),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
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
                                  value: selectedLoja,
                                  iconSize: 30,
                                  icon: (null),
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                  hint: Text('Loja'),
                                  items: data?.map(
                                    (list) {
                                      return DropdownMenuItem(
                                        child: Text(list['fantasia']),
                                        value: list['idloja'].toString(),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedLoja = value as String;
                                    });
                                  },
                                ),
                              ),
                            ),
                          )),
                    ),
                    TextFieldTxt(
                        controller: _fantasiaController, text: 'Fantasia'),
                    widget.cardapio?.idcardapio == null
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
        String fantasia = _fantasiaController.text.toString().trim();
        int idloja = int.parse(selectedLoja!);
        if (fantasia.isEmpty) {
          _msg(context, 'Atenção', 'Verifique dados do formulario.');
          return;
        }
        setState(() {
          Cardapio cardapio =
              Cardapio(idcardapio: 0, idloja: idloja, fantasia: fantasia);
          createCardapio(cardapio).then((response) {
            if (response.statusCode == 200) {
              Navigator.pop(context, true);
            } else {
              _msg(context, 'Atenção', response.body);
            }
          });
        });
      },
      child: const Text('Criar Cardapio'),
    );
  }

  Widget _createButtonUpdate() {
    return ElevatedButton(
      onPressed: () {
        String fantasia = _fantasiaController.text.toString().trim();
        int idloja = int.parse(selectedLoja!);
        if (fantasia.isEmpty) {
          _msg(context, 'Atenção', 'Verifique dados do formulario.');
          return;
        }
        setState(() {
          Cardapio cardapio = Cardapio(
              idcardapio: widget.cardapio!.idcardapio,
              idloja: idloja,
              fantasia: fantasia);
          updateCardapio(cardapio).then((response) {
            if (response.statusCode == 200) {
              Navigator.pop(context, true);
            } else {
              _msg(context, 'Atenção', 'Erro API.');
            }
          });
        });
      },
      child: const Text('Editar Cardapio'),
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
