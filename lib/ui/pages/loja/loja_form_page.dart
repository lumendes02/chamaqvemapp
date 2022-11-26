import 'dart:convert';
import 'dart:math';
import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/enums/button_enum.dart';
import 'package:chamaqvem/models/loja.dart';
import 'package:chamaqvem/services/loja_api.dart';
import 'package:chamaqvem/services/usuario_api.dart';
import 'package:chamaqvem/ui/components/Util_functions.dart';
import 'package:chamaqvem/ui/components/alert_message.dart';
import 'package:chamaqvem/ui/components/button.dart';
import 'package:chamaqvem/ui/components/selectImagens.dart';
import 'package:chamaqvem/ui/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  String? selectedImage;

  List? data;

  var _selectedImageIndex = 0;
  final _images = [
    "https://www.bellacapri.com.br/wp-content/uploads/2021/02/JAL-2.jpg",
    "https://media-cdn.tripadvisor.com/media/photo-s/10/7f/41/79/loja-centro.jpg",
    "https://guiafranquiasdesucesso.com/wp-content/uploads/2016/07/franquia-lanchao-e-cia.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/f/f7/Abu_Nawas_Beach_restaurant_-_Flickr_-_Al_Jazeera_English_%281%29.jpg",
  ];

  Future GetAllCargos() async {
    EasyLoading.show(status: 'Carregando');
    final response =
        await http.get(Uri.parse("http://lucasmendesdev.com.br/api/cidade"));
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
                    TextFieldTxt(
                        controller: _fantasiaController, text: 'Fantasia'),
                    TextFieldTxt(
                        controller: _enderecoController, text: 'Endereco'),
                    TextFieldTxt(controller: _cnpjController, text: 'CNPJ'),
                    TextFieldTxt(controller: _cepController, text: 'CEP'),
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
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.width * 0.1,
      child: ElevatedButton(
        onPressed: () {
          String fantasia = _fantasiaController.text.toString().trim();
          String endereco = _enderecoController.text.toString().trim();
          String cnpj = _cnpjController.text.toString().trim();
          String cep = _cepController.text.toString().trim();

          if (fantasia.isEmpty ||
              endereco.isEmpty ||
              cnpj.isEmpty ||
              cep.isEmpty) {
            _msg(context, 'Atenção', 'Verifique dados do formulario.');
            return;
          }
          Loja loja = Loja(
              idloja: 0,
              idusuario: box.read('user'),
              idcidade: 1,
              fantasia: fantasia,
              endereco: endereco,
              cnpj: cnpj,
              cep: cep,
              imagem: selectedImage!);
          setState(() {
            createLoja(loja).then((response) {
              if (response.statusCode == 200) {
                mudaLojeiroUser(box.read('user')).then((response) {
                  if (response.statusCode == 200) {
                    ShowSnackBarMSG(context, 'Loja criada');
                    Navigator.pop(context, true);
                  } else {
                    ShowSnackBarMSG(context, 'error');
                  }
                });
              } else {
                EasyLoading.dismiss();
                _msg(context, 'Atenção', response.body);
              }
            });
          });
        },
        child: const Text('Criar Loja'),
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
                idcidade: 1,
                fantasia: fantasia,
                endereco: endereco,
                cnpj: cnpj,
                cep: cep,
                imagem: selectedImage!);

            updateLoja(loja).then((response) {
              if (response.statusCode == 200) {
                ShowSnackBarMSG(context, 'Loja editada');
                Navigator.pop(context, true);
              } else {
                _msg(context, 'Atenção', 'Erro API.');
              }
            });
          });
        },
        child: const Text('Editar Loja'),
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
