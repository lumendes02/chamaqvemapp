import 'dart:convert';
import 'package:chamaqvem/enums/button_enum.dart';
import 'package:chamaqvem/models/loja.dart';
import 'package:chamaqvem/services/loja_api.dart';
import 'package:chamaqvem/ui/components/alert_message.dart';
import 'package:chamaqvem/ui/components/button.dart';
import 'package:chamaqvem/ui/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FormLoja extends StatefulWidget {
  final Loja? loja;
  final bool? editar;

  const FormLoja({this.loja, this.editar, Key? key}) : super(key: key);

  @override
  State<FormLoja> createState() => _FormLojaState();
}

class _FormLojaState extends State<FormLoja> {
  final _fantasiaController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _cepController = TextEditingController();

  String? selectedCidade;

  List? data;

  Future GetAllCargos() async {
    final response =
        await http.get(Uri.parse("http://localhost:8000/api/cidade"));
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
    if (widget.editar == true) {
      _fantasiaController.text = widget.loja!.fantasia;
      _enderecoController.text = widget.loja!.endereco;
      _cnpjController.text = widget.loja!.cnpj;
      _cepController.text = widget.loja!.cep;
      selectedCidade = widget.loja!.idcidade.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulario Loja"),
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
                                  value: selectedCidade,
                                  iconSize: 30,
                                  icon: (null),
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                  hint: Text('Cidade'),
                                  items: data?.map(
                                    (list) {
                                      return DropdownMenuItem(
                                        child: Text(list['fantasia']),
                                        value: list['idcidade'].toString(),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCidade = value as String;
                                    });
                                  },
                                ),
                              ),
                            ),
                          )),
                    ),
                    TextFieldTxt(
                        controller: _fantasiaController, text: 'Fantasia'),
                    TextFieldTxt(
                        controller: _enderecoController, text: 'Endereco'),
                    TextFieldTxt(controller: _cnpjController, text: 'CNPJ'),
                    TextFieldTxt(controller: _cepController, text: 'CEP'),
                    widget.loja?.idloja == null
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
        String endereco = _enderecoController.text.toString().trim();
        String cnpj = _cnpjController.text.toString().trim();
        String cep = _cepController.text.toString().trim();
        int idcidade = int.parse(selectedCidade!);
        if (fantasia.isEmpty ||
            endereco.isEmpty ||
            cnpj.isEmpty ||
            cep.isEmpty) {
          _msg(context, 'Atenção', 'Verifique dados do formulario.');
          return;
        }
        setState(() {
          Loja loja = Loja(
              idloja: 0,
              idusuario: 1,
              idcidade: idcidade,
              fantasia: fantasia,
              endereco: endereco,
              cnpj: cnpj,
              cep: cep);
          createLoja(loja).then((response) {
            if (response.statusCode == 200) {
              Navigator.pop(context, true);
            } else {
              _msg(context, 'Atenção', response.body);
            }
          });
        });
      },
      child: const Text('Criar Loja'),
    );
  }

  Widget _createButtonUpdate() {
    return ElevatedButton(
      onPressed: () {
        String fantasia = _fantasiaController.text.toString().trim();
        String endereco = _enderecoController.text.toString().trim();
        String cnpj = _cnpjController.text.toString().trim();
        String cep = _cepController.text.toString().trim();
        int idcidade = int.parse(selectedCidade!);
        if (fantasia.isEmpty ||
            endereco.isEmpty ||
            cnpj.isEmpty ||
            cep.isEmpty) {
          _msg(context, 'Atenção', 'Verifique dados do formulario.');
          return;
        }
        setState(() {
          Loja loja = Loja(
              idloja: widget.loja!.idloja,
              idusuario: 1,
              idcidade: idcidade,
              fantasia: fantasia,
              endereco: endereco,
              cnpj: cnpj,
              cep: cep);

          updateLoja(loja).then((response) {
            if (response.statusCode == 200) {
              Navigator.pop(context, true);
            } else {
              _msg(context, 'Atenção', 'Erro API.');
            }
          });
        });
      },
      child: const Text('Editar Loja'),
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
