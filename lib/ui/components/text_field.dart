import 'package:flutter/material.dart';

class TextFieldTxt extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final TextInputType? keyboard;

  const TextFieldTxt(
      {required this.controller, required this.text, this.keyboard, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        keyboardType: keyboard ?? TextInputType.text,
        decoration: InputDecoration(
            labelText: text, border: const OutlineInputBorder()),
      ),
    );
  }
}
