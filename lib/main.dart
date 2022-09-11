import 'package:chamaqvem/ui/pages/home/home_page.dart';
import 'package:chamaqvem/ui/pages/login/login_page.dart';
import 'package:chamaqvem/ui/pages/tipo_usuario/tipo_usuario_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
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
      ],
    );
  }
}
