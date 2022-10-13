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
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

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
        GetPage(name: '/produto', page: () => ProdutoList()),
      ],
      builder: EasyLoading.init(),
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.purple, //<-- SEE HERE
        ),
        primaryColor: Colors.purple[50],
        scaffoldBackgroundColor: Colors.purple[200],
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromRGBO(156, 39, 176, 1),
          foregroundColor: Colors.white,
          shadowColor: Colors.purple[500],
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Color.fromARGB(255, 227, 207, 231),
          iconColor: Colors.purple,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: Colors.purple),
            borderRadius: BorderRadius.all(
              Radius.circular(64.0),
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.purple[500],
            onPrimary: Colors.white,
          ),
        ),
      ),
    );
  }
}
