import 'package:chamaqvem/models/loja.dart';
import 'package:chamaqvem/models/produto.dart';
import 'package:chamaqvem/models/user_type.dart';
import 'package:chamaqvem/services/loja_api.dart';
import 'package:chamaqvem/services/produto_api.dart';
import 'package:chamaqvem/ui/components/button.dart';
import 'package:chamaqvem/ui/pages/loja/loja_form_page.dart';
import 'package:chamaqvem/ui/pages/produto/produto_form_page.dart';
import 'package:chamaqvem/ui/pages/tipo_usuario/tipo_usuario_form_page.dart';
import 'package:chamaqvem/services/tipousuario_api.dart';
import 'package:flutter/material.dart';

class ProdutoList extends StatefulWidget {
  const ProdutoList({Key? key}) : super(key: key);

  @override
  State<ProdutoList> createState() => _ProdutoListState();
}

class _ProdutoListState extends State<ProdutoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Lojas'),
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              bool? refresh = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return FormProduto();
              }));
              if (refresh == true) {
                setState(() {});
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
      body: SafeArea(
          child: FutureBuilder(
        future: getProduto(),
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
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("$idproduto - $descricao",
                              style: Theme.of(context).textTheme.titleLarge),
                          Text("Preço: $preco",
                              style: Theme.of(context).textTheme.titleSmall),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.edit),
                                tooltip: 'Editar',
                                onPressed: () async {
                                  bool? refresh = await Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return FormProduto(produto: postItem, editar: true,)
                                  }));
                                  if (refresh == true) {
                                    setState(() {});
                                  }
                                },
                              ),
                              IconButton(
                                color: Colors.red,
                                icon: const Icon(Icons.delete),
                                tooltip: 'Excluir',
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Deseja excluir?"),
                                          content: const Text(
                                              "Você perdera o dado para sempre."),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () {
                                                  deleteProduto(idproduto)
                                                      .then((response) {
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
                              ),
                            ],
                          )
                        ],
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
