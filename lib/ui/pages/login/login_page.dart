import 'dart:convert';
import 'dart:ffi';
import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/enums/button_enum.dart';
import 'package:chamaqvem/models/user.dart';
import 'package:chamaqvem/ui/components/alert_message.dart';
import 'package:chamaqvem/ui/components/button.dart';
import 'package:chamaqvem/ui/pages/login/singup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class LoginPage extends StatelessWidget {
  @override
  final EmailController = TextEditingController();
  final SenhaController = TextEditingController();
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      child: Scaffold(
        body: Stack(children: [
          Container(
            padding: const EdgeInsets.only(left: 35, top: 80),
            child: const Text(
              "ChamaQVEM",
              style: TextStyle(color: Colors.black, fontSize: 33),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  right: 35,
                  left: 35,
                  top: MediaQuery.of(context).size.height * 0.5),
              child: Column(children: [
                TextField(
                  controller: EmailController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'Login',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: SenhaController,
                  obscureText: true,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'Senha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Singup();
                        }));
                      },
                      child: const Text(
                        'REGISTRAR',
                        style: TextStyle(
                          color: Color.fromARGB(255, 51, 255, 0),
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        bool retorno = await postData(
                            EmailController.text, SenhaController.text);
                        if (retorno == true) {
                          Get.toNamed('/home');
                        } else {
                          _msg(context, 'Atenção', 'Digite usuario valido.');
                          EmailController.text = '';
                          SenhaController.text = '';
                        }
                      },
                      child: const Text(
                        'LOGAR',
                        style: TextStyle(
                          color: Color.fromARGB(255, 51, 255, 0),
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  Future<bool> postData(email, senha) async {
    try {
      EasyLoading.instance
        ..displayDuration = const Duration(milliseconds: 2000)
        ..loadingStyle =
            EasyLoadingStyle.custom //This was missing in earlier code
        ..backgroundColor = Colors.purple
        ..indicatorColor = Colors.white
        ..maskColor = Colors.black
        ..maskType = EasyLoadingMaskType.black
        ..textColor = Colors.white
        ..indicatorType = EasyLoadingIndicatorType.dualRing
        ..dismissOnTap = false;
      EasyLoading.show(status: 'Entrando...');

      var response = await http.post(
          Uri.parse('http://localhost:8000/api/login'),
          body: {"login": email, "senha": senha});
      final Map<String, dynamic> responseMap = jsonDecode(response.body);
      if (response.statusCode == 201) {
        await box.write('token', 'Bearer ' + responseMap['token']);
        await box.write('user', responseMap['user']['idusuario']);
        EasyLoading.dismiss();
        return true;
      } else {
        EasyLoading.dismiss();
        return false;
      }
    } on Exception catch (e) {
      EasyLoading.dismiss();
      print(e);
      return false;
    }
  }

  void _msg(context, String title, String text) {
    AlertMessage().show(context: context, title: title, text: text, button: [
      Button(
          text: 'OK',
          type: ButtonEnum.text,
          click: () {
            Navigator.pop(context);
          }),
    ]);
  }
}
