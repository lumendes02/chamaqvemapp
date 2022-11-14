import 'package:chamaqvem/models/pedido_display.dart';
import 'package:chamaqvem/services/usuario_api.dart';
import 'package:chamaqvem/ui/pages/pedido/pedido_single.dart';
import 'package:flutter/material.dart';

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
                var fantasia = postItem.nome.toUpperCase();
                var itens = postItem.quantidade;
                var cor = postItem.idstatus;
                var pedido = postItem.idpedido.toString();

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
                            idpedido: postItem.idpedido,
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
                                        child: Text('Cliente - $fantasia',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge),
                                      ),
                                      Text('Pedido: $pedido',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
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

  Widget nada() {
    return Container();
  }
}
