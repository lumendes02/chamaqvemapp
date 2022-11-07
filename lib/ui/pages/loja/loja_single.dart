import 'package:chamaqvem/constants.dart';
import 'package:chamaqvem/models/loja.dart';
import 'package:chamaqvem/services/loja_api.dart';
import 'package:chamaqvem/ui/pages/cardapio/cardapio_form_page.dart';
import 'package:chamaqvem/ui/pages/cardapio/cardapio_page.dart';
import 'package:chamaqvem/ui/pages/pedido/pedido_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class LojaSingle extends StatefulWidget {
  final int idusuario;
  const LojaSingle({required this.idusuario, Key? key}) : super(key: key);

  @override
  State<LojaSingle> createState() => _LojaSingleState();
}

class _LojaSingleState extends State<LojaSingle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(''),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: getLojaEspecifico(widget.idusuario),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                var lmao = snapshot.data as List<Loja>;
                var response = lmao[0];

                return Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Column(
                      children: [
                        Material(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 220,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    'https://pbs.twimg.com/profile_images/2767740364/3397e4e9ee5da5f72641a156da009770_400x400.png'),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              SizedBox(height: 8),
                              Text(response.fantasia.toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic,
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.volume_up),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.volume_up),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.volume_up),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                              Wrap(
                                runSpacing: 16,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.list),
                                    title: const Text('CARDAPIO'),
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return CardapioList(
                                            idloja: response.idloja,
                                            idusuario: response.idusuario);
                                      }));
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.store),
                                    title: const Text('MINHA LOJA'),
                                    onTap: () {},
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                  ),
                                  // box.read('user')
                                  1 == widget.idusuario
                                      ? _createButtonPedido(response.idloja)
                                      : nada(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back)),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _createButtonPedido(idloja) {
    return ListTile(
      leading: const Icon(Icons.list),
      title: const Text('PEDIDOS DA LOJA'),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return UsuarioPedidosList(idloja: idloja);
        }));
      },
    );
  }

  Widget nada() {
    return Container();
  }
}
