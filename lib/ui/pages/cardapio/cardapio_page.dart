import 'dart:developer';

import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/models/cardapio.dart';
import 'package:chamaqvem/models/loja.dart';
import 'package:chamaqvem/models/user_type.dart';
import 'package:chamaqvem/services/cardapio_api.dart';
import 'package:chamaqvem/services/loja_api.dart';
import 'package:chamaqvem/ui/components/button.dart';
import 'package:chamaqvem/ui/pages/cardapio/cardapio_form_page.dart';
import 'package:chamaqvem/ui/pages/loja/loja_form_page.dart';
import 'package:chamaqvem/ui/pages/produto/produto_page.dart';
import 'package:chamaqvem/ui/pages/tipo_usuario/tipo_usuario_form_page.dart';
import 'package:chamaqvem/services/tipousuario_api.dart';
import 'package:flutter/material.dart';

class CardapioList extends StatefulWidget {
  final int idloja;
  final int idusuario;

  const CardapioList({required this.idloja, required this.idusuario, Key? key})
      : super(key: key);

  @override
  State<CardapioList> createState() => _CardapioListState();
}

class _CardapioListState extends State<CardapioList> {
  @override
  void initState() {
    super.initState();
    //final admin = verificaUsuarioCardapio(widget.idusuario);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cardapios'),
        actions: <Widget>[
          box.read('user') == widget.idusuario
              ? _createButtonInserir()
              : nada(),
        ],
      ),
      body: SafeArea(
          child: FutureBuilder(
        future: getCardapioLoja(widget.idloja),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            var response = snapshot.data as List<Cardapio>;

            return ListView.builder(
              itemCount: response.length,
              itemBuilder: (context, position) {
                var postItem = response[position];
                var idloja = postItem.idloja;
                var fantasia = postItem.fantasia;
                var idcardapio = postItem.idcardapio;
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    child: InkWell(
                      onTap: () async {
                        bool? refresh = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ProdutoList(
                            idcardapio: idcardapio,
                            idusuario: widget.idusuario,
                            idloja: widget.idloja,
                          );
                        }));
                        if (refresh == true) {
                          setState(() {});
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(postItem.imagem),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(fantasia.toUpperCase(),
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                box.read('user') == widget.idusuario
                                    ? _createButtonEditar(postItem)
                                    : nada(),
                                box.read('user') == widget.idusuario
                                    ? _createButtonDeletar(idcardapio)
                                    : nada()
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )),
    );
  }

  Widget _createButtonEditar(postItem) {
    return IconButton(
      icon: const Icon(Icons.edit),
      tooltip: 'Editar',
      onPressed: () async {
        bool? refresh =
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
          return FormCardapio(
            cardapio: postItem,
            editar: true,
            idloja: widget.idloja,
          );
        }));
        if (refresh == true) {
          setState(() {});
        }
      },
    );
  }

  Widget _createButtonDeletar(idcardapio) {
    return IconButton(
      color: Colors.red,
      icon: const Icon(Icons.delete),
      tooltip: 'Excluir',
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Deseja excluir?"),
                content: const Text("Você perdera o dado para sempre."),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        deleteCardapio(idcardapio).then((response) {
                          Navigator.pop(context);
                          setState(() {});
                        });
                      },
                      child: const Text("Sim")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Não")),
                ],
              );
            });
      },
    );
  }

  Widget _createButtonInserir() {
    return GestureDetector(
      onTap: () async {
        bool? refresh =
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
          return FormCardapio(
            idloja: widget.idloja,
          );
        }));
        if (refresh == true) {
          setState(() {});
        }
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget nada() {
    return Container();
  }
}
