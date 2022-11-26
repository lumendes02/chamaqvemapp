import 'dart:convert';
import 'package:chamaqvem/enums/button_enum.dart';
import 'package:chamaqvem/models/cardapio.dart';
import 'package:chamaqvem/models/loja.dart';
import 'package:chamaqvem/services/cardapio_api.dart';
import 'package:chamaqvem/services/loja_api.dart';
import 'package:chamaqvem/ui/components/Util_functions.dart';
import 'package:chamaqvem/ui/components/alert_message.dart';
import 'package:chamaqvem/ui/components/button.dart';
import 'package:chamaqvem/ui/components/selectImagens.dart';
import 'package:chamaqvem/ui/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class FormCardapio extends StatefulWidget {
  final Cardapio? cardapio;
  final bool? editar;
  final int idloja;

  const FormCardapio(
      {this.cardapio, this.editar, required this.idloja, Key? key})
      : super(key: key);

  @override
  State<FormCardapio> createState() => _FormCardapioState();
}

class _FormCardapioState extends State<FormCardapio> {
  final _fantasiaController = TextEditingController();

  String? selectedLoja;

  List? data;
  String? selectedImage;
  var _selectedImageIndex = 0;
  final _images = [
    "https://i1.wp.com/mercadoeconsumo.com.br/wp-content/uploads/2019/04/Que-comida-saud%C3%A1vel-que-nada-brasileiro-gosta-de-fast-food.jpg",
    "https://img.itdg.com.br/tdg/images/blog/uploads/2022/07/5-itens-necessarios-para-se-tornar-um-pizzaiolo-neste-Dia-da-Pizza.jpg?mode=crop&width={:width=%3E150,%20:height=%3E130}",
    "https://mezzani.com.br/wp-content/uploads/2019/12/Raviolone-story.jpg",
  ];

  Future GetAllLojas() async {
    EasyLoading.show(status: 'Carregando');
    final response =
        await http.get(Uri.parse("http://lucasmendesdev.com.br/api/loja"));
    var jsonBody = response.body;
    var jsonData = json.decode(jsonBody);

    setState(() {
      data = jsonData;
      EasyLoading.dismiss();
    });
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
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.width * 0.1,
      child: ElevatedButton(
        onPressed: () {
          String fantasia = _fantasiaController.text.toString().trim();
          int idloja = widget.idloja;
          if (fantasia.isEmpty) {
            _msg(context, 'Atenção', 'Verifique dados do formulario.');
            return;
          }
          setState(() {
            Cardapio cardapio = Cardapio(
                idcardapio: 0,
                idloja: idloja,
                fantasia: fantasia,
                imagem: selectedImage!);
            createCardapio(cardapio).then((response) {
              if (response.statusCode == 200) {
                ShowSnackBarMSG(context, 'Cardapio criado');
                Navigator.pop(context, true);
              } else {
                _msg(context, 'Atenção', response.body);
              }
            });
          });
        },
        child: const Text('Criar Cardapio'),
      ),
    );
  }

  Widget _createButtonUpdate() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.width * 0.1,
      child: ElevatedButton(
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
                fantasia: fantasia,
                imagem: selectedImage!);
            updateCardapio(cardapio).then((response) {
              if (response.statusCode == 200) {
                ShowSnackBarMSG(context, 'Cardapio atualizado');
                Navigator.pop(context, true);
              } else {
                _msg(context, 'Atenção', 'Erro API.');
              }
            });
          });
        },
        child: const Text('Editar Cardapio'),
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
