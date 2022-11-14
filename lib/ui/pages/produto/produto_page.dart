import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/models/carrinho.dart';
import 'package:chamaqvem/models/produto.dart';
import 'package:chamaqvem/services/carrinho_api.dart';
import 'package:chamaqvem/services/produto_api.dart';
import 'package:chamaqvem/ui/components/Util_functions.dart';
import 'package:chamaqvem/ui/pages/carrinho/carrinho_page.dart';
import 'package:chamaqvem/ui/pages/produto/produto_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ProdutoList extends StatefulWidget {
  final int idcardapio;
  final int? idusuario;
  final int? idloja;
  get cartController => Get.put(cartController());

  const ProdutoList(
      {required this.idcardapio, this.idusuario, this.idloja, Key? key})
      : super(key: key);

  @override
  State<ProdutoList> createState() => _ProdutoListState();
}

class _ProdutoListState extends State<ProdutoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: <Widget>[
          _createButtonCarrinho(),
          box.read('user') == widget.idusuario
              ? _createButtonInserir()
              : nada(),
        ],
      ),
      body: SafeArea(
          child: FutureBuilder(
        future: getProdutoCardapio(widget.idcardapio),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            var response = snapshot.data as List<Produto>;

            return ListView.builder(
              itemCount: response.length,
              itemBuilder: (context, position) {
                var postItem = response[position];
                var idproduto = postItem.idproduto;
                var descricao = postItem.descricao;
                var preco = postItem.preco;
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    child: InkWell(
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
                            Text(descricao.toUpperCase(),
                                style: Theme.of(context).textTheme.titleLarge),
                            Row(
                              children: [
                                Text("Preço: $preco",
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                                IconButton(
                                    onPressed: () {
                                      EasyLoading.show(status: 'Carregando');
                                      Carrinho produto = Carrinho(
                                          idcarrinho: 0,
                                          idloja: widget.idloja!,
                                          idproduto: postItem.idproduto,
                                          idusuario: box.read('user')!,
                                          idstatus: 1,
                                          preco: postItem.preco,
                                          quantidade: 1,
                                          descricao: '',
                                          imagem: postItem.imagem);
                                      createItemCarrinho(produto)
                                          .then((response) {
                                        if (response.statusCode == 200) {
                                          EasyLoading.dismiss();
                                          ShowSnackBarMSG(context,
                                              'Adicionado ao carrinho');
                                        } else {
                                          EasyLoading.dismiss();
                                          ShowSnackBarMSG(context, 'Erro api');
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.add_circle)),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                box.read('user_type') == 1
                                    ? _createButtonEditar(postItem)
                                    : nada(),
                                box.read('user_type') == 1
                                    ? _createButtonDeletar(idproduto)
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

  Widget nada() {
    return Container();
  }

  Widget _createButtonEditar(postItem) {
    return IconButton(
      icon: const Icon(Icons.edit),
      tooltip: 'Editar',
      onPressed: () async {
        bool? refresh =
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
          return FormProduto(
            produto: postItem,
            editar: true,
            idcardapio: widget.idcardapio!,
          );
        }));
        if (refresh == true) {
          setState(() {});
        }
      },
    );
  }

  Widget _createButtonDeletar(idproduto) {
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
                      deleteProduto(idproduto).then((response) {
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
          },
        );
      },
    );
  }

  Widget _createButtonInserir() {
    return GestureDetector(
      onTap: () async {
        bool? refresh =
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
          return FormProduto(
            idcardapio: widget.idcardapio!,
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

  Widget _createButtonCarrinho() {
    return GestureDetector(
      onTap: () async {
        bool? refresh =
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CarrinhoList(
            idloja: widget.idloja!,
            idusuario: box.read('user')!,
          );
        }));
        if (refresh == true) {
          setState(() {});
        }
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
