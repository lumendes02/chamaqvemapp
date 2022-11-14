import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/models/carrinho.dart';
import 'package:chamaqvem/models/loja.dart';
import 'package:chamaqvem/models/pedido.dart';
import 'package:chamaqvem/models/produto.dart';
import 'package:chamaqvem/models/user_type.dart';
import 'package:chamaqvem/services/carrinho_api.dart';
import 'package:chamaqvem/services/loja_api.dart';
import 'package:chamaqvem/services/mensagem_api.dart';
import 'package:chamaqvem/services/produto_api.dart';
import 'package:chamaqvem/ui/components/Util_functions.dart';
import 'package:chamaqvem/ui/components/button.dart';
import 'package:chamaqvem/ui/controllers/cart_controller.dart';
import 'package:chamaqvem/ui/pages/carrinho/carrinho_page.dart';
import 'package:chamaqvem/ui/pages/loja/loja_form_page.dart';
import 'package:chamaqvem/ui/pages/produto/produto_form_page.dart';
import 'package:chamaqvem/ui/pages/tipo_usuario/tipo_usuario_form_page.dart';
import 'package:chamaqvem/services/tipousuario_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ProdutoListUsuario extends StatefulWidget {
  final int? idusuario;
  final int? idloja;
  final int? idstatus;
  final int? idpedido;

  get cartController => Get.put(cartController());

  const ProdutoListUsuario(
      {this.idusuario, this.idloja, this.idstatus, this.idpedido, Key? key})
      : super(key: key);

  @override
  State<ProdutoListUsuario> createState() => _ProdutoListUsuarioState();
}

class _ProdutoListUsuarioState extends State<ProdutoListUsuario> {
  @override
  @override
  Widget build(BuildContext context) {
    bool _showRecusaConfirma = true;
    bool _showFinalizar = false;
    if (widget.idstatus != 2) {
      _showRecusaConfirma = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido - ' + widget.idpedido.toString()),
        actions: <Widget>[],
      ),
      bottomNavigationBar: _showRecusaConfirma
          ? BottomAppBar(
              color: Colors.transparent,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, //Center Row contents horizontally,
                  crossAxisAlignment: CrossAxisAlignment
                      .center, //Center Row contents vertically,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.1,
                        child: TextButton(
                          onPressed: () {
                            recusarItens(widget.idpedido).then((response) {
                              if (response.statusCode == 200) {
                                createMensagem(widget.idusuario, widget.idloja,
                                    int.parse(response.body), 'recusar');
                                EasyLoading.dismiss();
                                ShowSnackBarMSG(context, 'Pedido Recusado');
                                Navigator.pop(context, true);
                              } else {
                                EasyLoading.dismiss();
                                ShowSnackBarMSG(context, 'Erro api');
                              }
                            });
                          },
                          child: const Text(
                            'RECUSAR PEDIDO',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.1,
                        child: TextButton(
                          onPressed: () {
                            confirmarItens(widget.idpedido).then((response) {
                              if (response.statusCode == 200) {
                                createMensagem(widget.idusuario, widget.idloja,
                                    int.parse(response.body), 'confirmar');
                                EasyLoading.dismiss();
                                ShowSnackBarMSG(context, 'Pedido confirmado');
                                Navigator.pop(context, true);
                              } else {
                                EasyLoading.dismiss();
                                ShowSnackBarMSG(context, 'Erro api');
                              }
                            });
                          },
                          child: const Text(
                            'ACEITAR PEDIDO',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : BottomAppBar(
              color: Colors.transparent,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, //Center Row contents horizontally,
                  crossAxisAlignment: CrossAxisAlignment
                      .center, //Center Row contents vertically,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.width * 0.1,
                      child: TextButton(
                        onPressed: () {
                          finalizarItens(widget.idpedido).then((response) {
                            if (response.statusCode == 200) {
                              createMensagem(widget.idusuario, widget.idloja,
                                  int.parse(response.body), 'caminho');
                              EasyLoading.dismiss();
                              ShowSnackBarMSG(context, 'Pedido Finalizado');
                              Navigator.pop(context, true);
                            } else {
                              EasyLoading.dismiss();
                              ShowSnackBarMSG(context, 'Erro api');
                            }
                          });
                        },
                        child: const Text(
                          'FINALIZAR PEDIDO',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                var idproduto = postItem.idproduto;
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

  Widget nada() {
    return Container();
  }
}
