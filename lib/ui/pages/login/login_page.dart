import 'dart:convert';
import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/models/user.dart';
import 'package:chamaqvem/ui/pages/login/singup_page.dart';
import 'package:flutter/material.dart';
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
        backgroundColor: Colors.white,
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
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Singup();
                        }));
                      },
                      child: const Text(
                        'Registrar',
                        style: TextStyle(
                          color: Color.fromARGB(255, 51, 255, 0),
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Logar',
                      style: TextStyle(
                        color: Color(0xff4c505b),
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xff4c505b),
                      child: IconButton(
                        color: Colors.white,
                        onPressed: () {
                          postData(EmailController.text, SenhaController.text);
                        },
                        icon: const Icon(Icons.arrow_forward),
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

  postData(email, senha) async {
    Get.toNamed('/home');
    try {
      var response = await http.post(
          Uri.parse('http://localhost:8000/api/login'),
          body: {"login": email, "senha": senha});
      final Map<String, dynamic> responseMap = jsonDecode(response.body);
      box.write('token', 'Bearer ' + responseMap['token']);
      box.write('user', responseMap['user']['idusuario']);
      Get.toNamed('/home');
      print(box.read('user'));
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }
}
