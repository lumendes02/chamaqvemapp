import 'dart:developer';

import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/models/cardapio.dart';
import 'package:chamaqvem/models/carrinho.dart';
import 'package:chamaqvem/models/loja.dart';
import 'package:chamaqvem/models/user_type.dart';
import 'package:chamaqvem/services/cardapio_api.dart';
import 'package:chamaqvem/services/carrinho_api.dart';
import 'package:chamaqvem/services/loja_api.dart';
import 'package:chamaqvem/ui/components/Util_functions.dart';
import 'package:chamaqvem/ui/components/button.dart';
import 'package:chamaqvem/ui/pages/cardapio/cardapio_form_page.dart';
import 'package:chamaqvem/ui/pages/loja/loja_form_page.dart';
import 'package:chamaqvem/ui/pages/produto/produto_page.dart';
import 'package:chamaqvem/ui/pages/tipo_usuario/tipo_usuario_form_page.dart';
import 'package:chamaqvem/services/tipousuario_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CarrinhoList extends StatefulWidget {
  final int idloja;
  final int idusuario;

  const CarrinhoList({required this.idloja, required this.idusuario, Key? key})
      : super(key: key);

  @override
  State<CarrinhoList> createState() => _CarrinhoListState();
}

class _CarrinhoListState extends State<CarrinhoList> {
  @override
  void initState() {
    super.initState();
    //final admin = verificaUsuarioCardapio(widget.idusuario);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, //Center Row contents horizontally,
            crossAxisAlignment:
                CrossAxisAlignment.center, //Center Row contents vertically,
            children: [
              SizedBox(
                height: 45,
                width: 360,
                child: TextButton(
                  onPressed: () {
                    ativarItens(widget.idusuario, widget.idloja)
                        .then((response) {
                      if (response.statusCode == 200) {
                        EasyLoading.dismiss();
                        ShowSnackBarMSG(context, 'Pedido feito');
                        Navigator.pop(context, true);
                      } else {
                        EasyLoading.dismiss();
                        ShowSnackBarMSG(context, 'Erro api');
                      }
                    });
                  },
                  child: Text(
                    'FAZER PEDIDO',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.purple),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: SafeArea(
          child: FutureBuilder(
        future: getItensCarrinhoUsuario(widget.idusuario, widget.idloja),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            var response = snapshot.data as List<Carrinho>;

            return ListView.builder(
              itemCount: response.length,
              itemBuilder: (context, position) {
                var postItem = response[position];
                var fantasia = postItem.descricao;
                var preco = postItem.preco;
                var quantidade = postItem.quantidade;
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    child: InkWell(
                      onTap: () async {},
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            'https://i1.wp.com/mercadoeconsumo.com.br/wp-content/uploads/2019/04/Que-comida-saud%C3%A1vel-que-nada-brasileiro-gosta-de-fast-food.jpg'),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 16),
                                        child: Text(fantasia.toUpperCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge),
                                      ),
                                      Text('Preço: $preco',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 8, 0, 0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center, //Center Row contents horizontally,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center, //Center Row contents vertically,
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: IconButton(
                                                  color: Colors.red,
                                                  onPressed: () {
                                                    EasyLoading.show(
                                                        status: 'Carregando');
                                                    Carrinho produto = Carrinho(
                                                        idcarrinho:
                                                            postItem.idcarrinho,
                                                        idloja: widget.idloja,
                                                        idproduto:
                                                            postItem.idproduto,
                                                        idusuario:
                                                            widget.idusuario,
                                                        idstatus: 1,
                                                        preco: postItem.preco,
                                                        quantidade: postItem
                                                                .quantidade -
                                                            1,
                                                        descricao: '');
                                                    updateQuantidade(produto)
                                                        .then((response) {
                                                      if (response.statusCode ==
                                                          200) {
                                                        EasyLoading.dismiss();
                                                        ShowSnackBarMSG(
                                                            context, 'pronto');
                                                        setState(() {});
                                                      } else {
                                                        EasyLoading.dismiss();
                                                        ShowSnackBarMSG(context,
                                                            'Erro api');
                                                      }
                                                    });
                                                  },
                                                  icon:
                                                      Icon(Icons.remove_circle),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                    'Quant: $quantidade',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: IconButton(
                                                  color: Colors.green,
                                                  onPressed: () {
                                                    EasyLoading.show(
                                                        status: 'Carregando');
                                                    Carrinho produto = Carrinho(
                                                        idcarrinho:
                                                            postItem.idcarrinho,
                                                        idloja: widget.idloja,
                                                        idproduto:
                                                            postItem.idproduto,
                                                        idusuario:
                                                            widget.idusuario,
                                                        idstatus: 1,
                                                        preco: postItem.preco,
                                                        quantidade: postItem
                                                                .quantidade +
                                                            1,
                                                        descricao: '');
                                                    updateQuantidade(produto)
                                                        .then((response) {
                                                      if (response.statusCode ==
                                                          200) {
                                                        EasyLoading.dismiss();
                                                        ShowSnackBarMSG(
                                                            context, 'pronto');
                                                        setState(() {});
                                                      } else {
                                                        EasyLoading.dismiss();
                                                        ShowSnackBarMSG(context,
                                                            'Erro api');
                                                      }
                                                    });
                                                  },
                                                  icon: Icon(Icons.add_circle),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
          return FormCardapio();
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
