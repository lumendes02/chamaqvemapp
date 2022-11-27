import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/models/user.dart';
import 'package:chamaqvem/services/usuario_api.dart';
import 'package:chamaqvem/ui/pages/login/login_page.dart';
import 'package:chamaqvem/ui/pages/loja/loja_form_page.dart';
import 'package:chamaqvem/ui/pages/loja/loja_page.dart';
import 'package:chamaqvem/ui/pages/loja/loja_single.dart';
import 'package:chamaqvem/ui/pages/mensagens/mensagens_page.dart';
import 'package:chamaqvem/ui/pages/tipo_usuario/tipo_usuario_page.dart';
import 'package:flutter/material.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(box.read('user')),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var response = snapshot.data as User;
          if (response.idtipousuario == 6) {
            return Material(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Wrap(
                  runSpacing: 16,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.list),
                      title: const Text('LISTA DE LOJAS'),
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return LojaList();
                        }));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.store),
                      title: const Text('MINHA LOJA'),
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return LojaSingle(
                            idusuario: box.read('user'),
                          );
                        }));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.announcement_sharp),
                      title: const Text('MEUS PEDIDOS'),
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return MensagemList(
                            idusuario: box.read('user'),
                          );
                        }));
                      },
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    ListTile(
                      leading: const Icon(Icons.exit_to_app),
                      title: const Text('SAIR'),
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return LoginPage();
                        }));
                      },
                    ),
                  ],
                ),
              ),
            );
          } else if (response.idtipousuario == 1) {
            return Material(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Wrap(
                  runSpacing: 16,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.list),
                      title: const Text('LISTA DE LOJAS'),
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return LojaList();
                        }));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.announcement_sharp),
                      title: const Text('MEUS PEDIDOS'),
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return MensagemList(
                            idusuario: box.read('user'),
                          );
                        }));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.add),
                      title: const Text('TIPOS USUARIOS'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return UserTypeList();
                        }));
                      },
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    ListTile(
                      leading: const Icon(Icons.exit_to_app),
                      title: const Text('SAIR'),
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return LoginPage();
                        }));
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Material(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Wrap(
                  runSpacing: 16,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.list),
                      title: const Text('LISTA DE LOJAS'),
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return LojaList();
                        }));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.announcement_sharp),
                      title: const Text('MEUS PEDIDOS'),
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return MensagemList(
                            idusuario: box.read('user'),
                          );
                        }));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.add),
                      title: const Text('CRIAR LOJA'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return FormLoja();
                        }));
                      },
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    ListTile(
                      leading: const Icon(Icons.exit_to_app),
                      title: const Text('SAIR'),
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return LoginPage();
                        }));
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        } else {
          return Material(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Wrap(
                runSpacing: 16,
                children: [
                  ListTile(
                    leading: Image.network(
                        'https://i.giphy.com/media/L05HgB2h6qICDs5Sms/200.gif'),
                    title: const Text('Carregando...'),
                  ),
                  ListTile(
                    leading: Image.network(
                        'https://i.giphy.com/media/L05HgB2h6qICDs5Sms/200.gif'),
                    title: const Text('Carregando...'),
                  ),
                  ListTile(
                    leading: Image.network(
                        'https://i.giphy.com/media/L05HgB2h6qICDs5Sms/200.gif'),
                    title: const Text('Carregando...'),
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    leading: Image.network(
                        'https://i.giphy.com/media/L05HgB2h6qICDs5Sms/200.gif'),
                    title: const Text('Carregando...'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
