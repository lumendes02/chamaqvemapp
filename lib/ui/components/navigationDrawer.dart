import 'package:chamaqvem/services/usuario_api.dart';
import 'package:chamaqvem/ui/components/menu_drawer.dart';
import 'package:chamaqvem/ui/components/user_drawer.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const <Widget>[
              UserDrawer(),
              MenuDrawer(),
            ],
          ),
        ),
      );
}
