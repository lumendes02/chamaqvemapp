import 'package:chamaqvem/ui/pages/cardapio/cardapio_page.dart';
import 'package:chamaqvem/ui/pages/home/home_page.dart';
import 'package:chamaqvem/ui/pages/login/login_page.dart';
import 'package:chamaqvem/ui/pages/login/singup_page.dart';
import 'package:chamaqvem/ui/pages/loja/loja_page.dart';
import 'package:chamaqvem/ui/pages/produto/produto_page.dart';
import 'package:chamaqvem/ui/pages/tipo_usuario/tipo_usuario_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/tipousuario', page: () => UserTypeList()),
        GetPage(name: '/registrar', page: () => Singup()),
        GetPage(name: '/lojas', page: () => LojaList()),
        GetPage(name: '/cardapio', page: () => CardapioList()),
        GetPage(name: '/produto', page: () => ProdutoList()),
      ],
    );
  }
}
