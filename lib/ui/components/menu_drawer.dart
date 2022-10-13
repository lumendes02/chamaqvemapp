import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/ui/pages/loja/loja_page.dart';
import 'package:chamaqvem/ui/pages/loja/loja_single.dart';
import 'package:flutter/material.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    if (box.read('user_type') == 6) {
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
              const Divider(
                color: Colors.black,
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('SAIR'),
                onTap: () {},
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
