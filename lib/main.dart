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
        //GetPage(name: '/produto', page: () => ProdutoList()),
      ],
      builder: EasyLoading.init(),
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.red, //<-- SEE HERE
          selectionColor: Colors.white,
        ),
        primaryColor: Colors.orange[50],
        scaffoldBackgroundColor: Colors.orange[200],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red, //Color.fromARGB(255, 250, 89, 2),
          foregroundColor: Colors.white,
          shadowColor: Colors.red[500],
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Color.fromARGB(255, 237, 220, 240),
          iconColor: Colors.red,
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.red),
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.red[500],
            onPrimary: Colors.white,
          ),
        ),
      ),
    );
  }
}
