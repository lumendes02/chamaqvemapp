import 'package:chamaqvem/models/pedido.dart';

import 'package:chamaqvem/services/produto_api.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ProdutoListMensagem extends StatefulWidget {
  final int? idusuario;
  final int? idloja;
  final int? idstatus;
  final int? idpedido;

  get cartController => Get.put(cartController());

  const ProdutoListMensagem(
      {this.idusuario, this.idloja, this.idstatus, this.idpedido, Key? key})
      : super(key: key);

  @override
  State<ProdutoListMensagem> createState() => _ProdutoListMensagemState();
}

class _ProdutoListMensagemState extends State<ProdutoListMensagem> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido - ' + widget.idpedido.toString()),
      ),
      body: SafeArea(
          child: FutureBuilder(
        future: getProdutoPedidoUsuario(
            widget.idusuario, widget.idloja, widget.idpedido),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            var response = snapshot.data as List<Pedido>;

            return ListView.builder(
              itemCount: response.length,
              itemBuilder: (context, position) {
                var postItem = response[position];
                var descricao = postItem.descricao;
                var preco = postItem.preco;
                var quantidade = postItem.quantidade;
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
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      'https://cdn.panelinha.com.br/receita/1443495600000-Pizza-de-mucarela-caseira.jpg'),
                                ),
                              ),
                            ),
                            Text(descricao.toUpperCase(),
                                style: Theme.of(context).textTheme.titleLarge),
                            Row(
                              children: [
                                Text("Preço: $preco x $quantidade",
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text("Quantidade: $quantidade",
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
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
}
