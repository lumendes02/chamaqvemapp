import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/models/carrinho.dart';
import 'package:chamaqvem/models/pedido_display.dart';
import 'package:chamaqvem/models/user.dart';
import 'package:chamaqvem/services/cardapio_api.dart';
import 'package:chamaqvem/services/carrinho_api.dart';
import 'package:chamaqvem/services/mensagem_api.dart';
import 'package:chamaqvem/services/usuario_api.dart';
import 'package:chamaqvem/ui/components/Util_functions.dart';
import 'package:chamaqvem/ui/components/corcard.dart';
import 'package:chamaqvem/ui/pages/cardapio/cardapio_form_page.dart';
import 'package:chamaqvem/ui/pages/pedido/pedido_single.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UsuarioPedidosList extends StatefulWidget {
  final int idloja;

  const UsuarioPedidosList({required this.idloja, Key? key}) : super(key: key);

  @override
  State<UsuarioPedidosList> createState() => _UsuarioPedidosListState();
}

class _UsuarioPedidosListState extends State<UsuarioPedidosList> {
  @override
  void initState() {
    super.initState();
    //final admin = verificaUsuarioCardapio(widget.idusuario);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
      ),
      body: SafeArea(
          child: FutureBuilder(
        future: getUserPedidosAtivos(widget.idloja),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            var response = snapshot.data as List<Pedidodisplay>;

            return ListView.builder(
              itemCount: response.length,
              itemBuilder: (context, position) {
                var postItem = response[position];
                var fantasia = postItem.nome;
                var itens = postItem.quantidade;
                var cor = postItem.idstatus;

                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    color: cor == 2
                        ? Colors.green[300]
                        : cor == 4
                            ? Colors.green
                            : Colors.red,
                    child: InkWell(
                      onTap: () async {
                        bool? refresh = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ProdutoListUsuario(
                            idusuario: postItem.idusuario,
                            idloja: widget.idloja,
                            idstatus: postItem.idstatus,
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
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    height: 75,
                                    width: 75,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.contain,
                                        image: NetworkImage(
                                            'https://cdn.icon-icons.com/icons2/933/PNG/512/user-shape_icon-icons.com_72487.png'),
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
                                      Text('Itens: $itens',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
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
