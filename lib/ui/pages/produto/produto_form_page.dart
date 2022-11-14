import 'dart:convert';
import 'package:chamaqvem/enums/button_enum.dart';
import 'package:chamaqvem/models/produto.dart';
import 'package:chamaqvem/services/produto_api.dart';
import 'package:chamaqvem/ui/components/Util_functions.dart';
import 'package:chamaqvem/ui/components/alert_message.dart';
import 'package:chamaqvem/ui/components/button.dart';
import 'package:chamaqvem/ui/components/selectImagens.dart';
import 'package:chamaqvem/ui/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class FormProduto extends StatefulWidget {
  final Produto? produto;
  final bool? editar;
  final int idcardapio;

  const FormProduto(
      {this.produto, this.editar, required this.idcardapio, Key? key})
      : super(key: key);

  @override
  State<FormProduto> createState() => _FormProdutoState();
}

class _FormProdutoState extends State<FormProduto> {
  final _descricaoController = TextEditingController();
  final _precoController = TextEditingController();
  final _descontoController = TextEditingController();

  String? selectedCardapio;

  String? selectedImage;

  List? data;

  var _selectedImageIndex = 0;
  final _images = [
    "https://receitinhas.com.br/wp-content/uploads/2022/09/230446.jpg",
    "https://www.aovivodebrasilia.com.br/wp-content/uploads/2020/09/pizza.jpg",
    "https://img.freepik.com/fotos-gratis/bife-de-frango-coberto-com-gergelim-branco-ervilhas-tomates-brocolis-e-abobora-em-um-prato-branco_1150-24770.jpg?w=2000",
    "https://images5.alphacoders.com/407/407550.jpg",
  ];

  Future GetAllCardapio() async {
    EasyLoading.show(status: 'Carregando');
    final response =
        await http.get(Uri.parse("http://localhost:8000/api/cardapio"));
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
                    TextFieldTxt(
                        controller: _descricaoController, text: 'Descricao'),
                    TextFieldTxt(controller: _precoController, text: 'Preco'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 14),
                      child: Row(
                        children: [
                          for (int i = 0; i < _images.length; i++)
                            SelectableImage(
                              isSelected: _selectedImageIndex == i,
                              onTap: (selectedImageIndex) {
                                setState(() {
                                  _selectedImageIndex = i;
                                  selectedImage = _images[i];
                                });
                              },
                              imageAsset: _images[i],
                            ),
                        ],
                      ),
                    ),
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
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.width * 0.1,
      child: ElevatedButton(
        onPressed: () {
          String descricao = _descricaoController.text.toString().trim();
          String preco = _precoController.text.toString().trim();

          if (descricao.isEmpty || preco.isEmpty) {
            _msg(context, 'Atenção', 'Verifique dados do formulario.');
            return;
          }
          setState(() {
            Produto produto = Produto(
                idproduto: 0,
                idcardapio: widget.idcardapio,
                descricao: descricao,
                preco: preco,
                desconto: '0',
                imagem: selectedImage!);
            createProduto(produto).then((response) {
              if (response.statusCode == 200) {
                ShowSnackBarMSG(context, 'Produto criado');
                Navigator.pop(context, true);
              } else {
                _msg(context, 'Atenção', response.body);
              }
            });
          });
        },
        child: const Text('Criar Produto'),
      ),
    );
  }

  Widget _createButtonUpdate() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.width * 0.1,
      child: ElevatedButton(
        onPressed: () {
          String descricao = _descricaoController.text.toString().trim();
          String preco = _precoController.text.toString().trim();

          if (descricao.isEmpty || preco.isEmpty) {
            _msg(context, 'Atenção', 'Verifique dados do formulario.');
            return;
          }
          setState(() {
            Produto produto = Produto(
                idproduto: widget.produto!.idproduto,
                idcardapio: widget.idcardapio,
                descricao: descricao,
                preco: preco,
                desconto: '0',
                imagem: selectedImage!);
            updateProduto(produto).then((response) {
              if (response.statusCode == 200) {
                ShowSnackBarMSG(context, 'Produto editado');
                Navigator.pop(context, true);
              } else {
                _msg(context, 'Atenção', 'Erro API.');
              }
            });
          });
        },
        child: const Text('Editar Produto'),
      ),
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
