import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/models/loja.dart';
import 'package:chamaqvem/services/loja_api.dart';
import 'package:chamaqvem/ui/components/navigationDrawer.dart';
import 'package:chamaqvem/ui/pages/loja/loja_form_page.dart';
import 'package:chamaqvem/ui/pages/loja/loja_single.dart';
import 'package:flutter/material.dart';

class LojaList extends StatefulWidget {
  const LojaList({Key? key}) : super(key: key);

  @override
  State<LojaList> createState() => _LojaListState();
}

class _LojaListState extends State<LojaList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Lojas'),
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
      drawer: const NavigationDrawer(),
      body: SafeArea(
          child: FutureBuilder(
        future: getLoja(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            var response = snapshot.data as List<Loja>;

            return ListView.builder(
              itemCount: response.length,
              itemBuilder: (context, position) {
                var postItem = response[position];
                var idloja = postItem.idloja;
                var fantasia = postItem.fantasia;
                var endereco = postItem.endereco;
                var imagemLink = postItem.imagem;
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: InkWell(
                      onTap: () async {
                        bool? refresh = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LojaSingle(
                            idusuario: postItem.idusuario,
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
                                  image: NetworkImage(imagemLink),
                                ),
                              ),
                            ),
                            Text(fantasia.toUpperCase(),
                                style: Theme.of(context).textTheme.titleLarge),
                            Text("Endereço: $endereco",
                                style: Theme.of(context).textTheme.titleSmall),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                box.read('user_type') == 1
                                    ? _createButtonEditar(postItem)
                                    : nada(),
                                box.read('user_type') == 1
                                    ? _createButtonDeletar(idloja)
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
          return FormLoja(
            loja: postItem,
            editar: true,
          );
        }));
        if (refresh == true) {
          setState(() {});
        }
      },
    );
  }

  Widget _createButtonDeletar(idloja) {
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
                      deleteLoja(idloja).then((response) {
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
}
