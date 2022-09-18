import 'dart:convert';
import 'package:chamaqvem/enums/button_enum.dart';
import 'package:chamaqvem/models/loja.dart';
import 'package:chamaqvem/models/produto.dart';
import 'package:chamaqvem/services/loja_api.dart';
import 'package:chamaqvem/services/produto_api.dart';
import 'package:chamaqvem/ui/components/alert_message.dart';
import 'package:chamaqvem/ui/components/button.dart';
import 'package:chamaqvem/ui/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FormProduto extends StatefulWidget {
  final Produto? produto;
  final bool? editar;

  const FormProduto({this.produto, this.editar, Key? key}) : super(key: key);

  @override
  State<FormProduto> createState() => _FormProdutoState();
}

class _FormProdutoState extends State<FormProduto> {
  final _descricaoController = TextEditingController();
  final _precoController = TextEditingController();
  final _descontoController = TextEditingController();

  String? selectedCardapio;

  List? data;

  Future GetAllCardapio() async {
    final response =
        await http.get(Uri.parse("http://localhost:8000/api/cardapio"));
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
    GetAllCardapio();
    if (widget.editar == true) {
      selectedCardapio = widget.produto!.idcardapio.toString();
      _descricaoController.text = widget.produto!.descricao;
      _precoController.text = widget.produto!.preco;
      _descontoController.text = widget.produto!.desconto;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulario Produto"),
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
                                  value: selectedCardapio,
                                  iconSize: 30,
                                  icon: (null),
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                  hint: Text('Cardapio'),
                                  items: data?.map(
                                    (list) {
                                      return DropdownMenuItem(
                                        child: Text(list['fantasia']),
                                        value: list['idcardapio'].toString(),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCardapio = value as String;
                                    });
                                  },
                                ),
                              ),
                            ),
                          )),
                    ),
                    TextFieldTxt(
                        controller: _descricaoController, text: 'Descricao'),
                    TextFieldTxt(controller: _precoController, text: 'Preco'),
                    TextFieldTxt(
                        controller: _descontoController, text: 'Desconto'),
                    widget.produto?.idproduto == null
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
        String descricao = _descricaoController.text.toString().trim();
        String preco = _precoController.text.toString().trim();
        String desconto = _descontoController.text.toString().trim();
        int idcardapio = int.parse(selectedCardapio!);
        if (descricao.isEmpty || preco.isEmpty || desconto.isEmpty) {
          _msg(context, 'Atenção', 'Verifique dados do formulario.');
          return;
        }
        setState(() {
          Produto produto = Produto(
              idproduto: 0,
              idcardapio: idcardapio,
              descricao: descricao,
              preco: preco,
              desconto: desconto);
          createProduto(produto).then((response) {
            if (response.statusCode == 200) {
              Navigator.pop(context, true);
            } else {
              _msg(context, 'Atenção', response.body);
            }
          });
        });
      },
      child: const Text('Criar Produto'),
    );
  }

  Widget _createButtonUpdate() {
    return ElevatedButton(
      onPressed: () {
        String descricao = _descricaoController.text.toString().trim();
        String preco = _precoController.text.toString().trim();
        String desconto = _descontoController.text.toString().trim();
        int idcardapio = int.parse(selectedCardapio!);
        if (descricao.isEmpty || preco.isEmpty || desconto.isEmpty) {
          _msg(context, 'Atenção', 'Verifique dados do formulario.');
          return;
        }
        setState(() {
          Produto produto = Produto(
              idproduto: widget.produto!.idproduto,
              idcardapio: idcardapio,
              descricao: descricao,
              preco: preco,
              desconto: desconto);
          updateProduto(produto).then((response) {
            if (response.statusCode == 200) {
              Navigator.pop(context, true);
            } else {
              _msg(context, 'Atenção', 'Erro API.');
            }
          });
        });
      },
      child: const Text('Editar Produto'),
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
