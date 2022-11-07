import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/models/user.dart';
import 'package:chamaqvem/services/usuario_api.dart';
import 'package:chamaqvem/ui/pages/perfil/perfil_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({Key? key}) : super(key: key);

  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(box.read('user')),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var response = snapshot.data as User;
          return Material(
            color: Colors.purple[500],
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return Perfil(
                    id: box.read('user'),
                  );
                }));
              },
              child: Container(
                padding: EdgeInsets.only(
                    top: 12 + MediaQuery.of(context).padding.top, bottom: 12),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 52,
                      backgroundImage: NetworkImage(
                          'https://pbs.twimg.com/profile_images/2767740364/3397e4e9ee5da5f72641a156da009770_400x400.png'),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(response.nome)
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
