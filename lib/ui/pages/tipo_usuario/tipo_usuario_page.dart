import 'package:chamaqvem/models/user_type.dart';
import 'package:chamaqvem/ui/pages/tipo_usuario/tipo_usuario_form_page.dart';
import 'package:chamaqvem/services/tipousuario_api.dart';
import 'package:flutter/material.dart';

class UserTypeList extends StatefulWidget {
  const UserTypeList({Key? key}) : super(key: key);

  @override
  State<UserTypeList> createState() => _UserTypeListState();
}

class _UserTypeListState extends State<UserTypeList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Tipo de Usuario'),
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              bool? refresh = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return FormUserType();
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
        future: getUserType(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            var response = snapshot.data as List<UserType>;

            return ListView.builder(
              itemCount: response.length,
              itemBuilder: (context, position) {
                var postItem = response[position];
                var id = postItem.idtipousuario;
                var nome = postItem.cargo;
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("$id - $nome",
                              style: Theme.of(context).textTheme.titleLarge),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.edit),
                                tooltip: 'Editar',
                                onPressed: () async {
                                  bool refresh = await Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return FormUserType(
                                      idtipousuario: id,
                                      cargo: nome,
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
                                                  deleteUserType(id)
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
