import 'package:chamaqvem/models/cardapio.dart';
import 'package:chamaqvem/models/loja.dart';
import 'package:chamaqvem/models/user_type.dart';
import 'package:chamaqvem/services/cardapio_api.dart';
import 'package:chamaqvem/services/loja_api.dart';
import 'package:chamaqvem/ui/components/button.dart';
import 'package:chamaqvem/ui/pages/cardapio/cardapio_form_page.dart';
import 'package:chamaqvem/ui/pages/loja/loja_form_page.dart';
import 'package:chamaqvem/ui/pages/tipo_usuario/tipo_usuario_form_page.dart';
import 'package:chamaqvem/services/tipousuario_api.dart';
import 'package:flutter/material.dart';

class CardapioList extends StatefulWidget {
  const CardapioList({Key? key}) : super(key: key);

  @override
  State<CardapioList> createState() => _CardapioListState();
}

class _CardapioListState extends State<CardapioList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Cardapios'),
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              bool? refresh = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
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
          )
        ],
      ),
      body: SafeArea(
          child: FutureBuilder(
        future: getCardapio(),
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
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("$idcardapio - $fantasia",
                              style: Theme.of(context).textTheme.titleLarge),
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
                                    return FormCardapio(
                                      cardapio: postItem,
                                      editar: true,
                                    );
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
                                                  deleteCardapio(idcardapio)
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
