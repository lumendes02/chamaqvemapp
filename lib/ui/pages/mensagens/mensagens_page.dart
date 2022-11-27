import 'dart:developer';

import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/models/cardapio.dart';
import 'package:chamaqvem/models/loja.dart';
import 'package:chamaqvem/models/mensagemget.dart';
import 'package:chamaqvem/models/user_type.dart';
import 'package:chamaqvem/services/cardapio_api.dart';
import 'package:chamaqvem/services/loja_api.dart';
import 'package:chamaqvem/services/mensagem_api.dart';
import 'package:chamaqvem/ui/components/button.dart';
import 'package:chamaqvem/ui/pages/cardapio/cardapio_form_page.dart';
import 'package:chamaqvem/ui/pages/loja/loja_form_page.dart';
import 'package:chamaqvem/ui/pages/mensagens/mensagens_pedido_single.dart';
import 'package:chamaqvem/ui/pages/produto/produto_page.dart';
import 'package:chamaqvem/ui/pages/tipo_usuario/tipo_usuario_form_page.dart';
import 'package:chamaqvem/services/tipousuario_api.dart';
import 'package:flutter/material.dart';

class MensagemList extends StatefulWidget {
  final int idusuario;

  const MensagemList({required this.idusuario, Key? key}) : super(key: key);

  @override
  State<MensagemList> createState() => _MensagemListState();
}

class _MensagemListState extends State<MensagemList> {
  @override
  void initState() {
    super.initState();
    //final admin = verificaUsuarioCardapio(widget.idusuario);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suas Mensagens'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
            ),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: SafeArea(
          child: FutureBuilder(
        future: getMensagemUsuario(widget.idusuario),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            var response = snapshot.data as List<MensagemGet>;

            return ListView.builder(
              itemCount: response.length,
              itemBuilder: (context, position) {
                var postItem = response[position];
                var titulo = postItem.titulo;
                var texto = postItem.textomensagem;
                var data = formatadata(postItem.created_at);
                var pedido = postItem.idpedido.toString();
                var loja = postItem.fantasia;
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        if (postItem.idstatus != 3) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ProdutoListMensagem(
                              idusuario: postItem.idusuario,
                              idloja: postItem.idloja,
                              idstatus: postItem.idstatus,
                              idpedido: postItem.idpedido,
                            );
                          }));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Center(
                              child: Text(titulo.toUpperCase(),
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                            ),
                            Center(
                              child: Text('Loja: ' + loja.toUpperCase(),
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              color: postItem.idstatus == 2
                                  ? Colors.grey[400]
                                  : postItem.idstatus == 3
                                      ? Colors.red[400]
                                      : postItem.idstatus == 4
                                          ? Colors.green[300]
                                          : Colors.green[400],
                              child: Center(
                                child: Text(texto),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 2, 2, 0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        color: Colors.white,
                                        child: Text('Pedido: $pedido'),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        color: Colors.white,
                                        child: Text('$data'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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

  formatadata(texto) {
    //2022-11-13 17:56
    String ano = texto.substring(0, 4); //2022
    String mes = texto.substring(5, 7); //11
    String dia = texto.substring(8, 10); //05
    String horaminutos = texto.substring(11, 16); //17:45
    return '$horaminutos - $dia/$mes/$ano';
  }

  Widget nada() {
    return Container();
  }
}
