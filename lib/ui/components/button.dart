import 'package:chamaqvem/enums/button_enum.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final ButtonEnum type;
  final VoidCallback click;
  final IconData? icon;

  const Button(
      {this.text = '',
      this.type = ButtonEnum.square,
      required this.click,
      this.icon,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ButtonEnum.square:
        return _createButtonSquare();
      case ButtonEnum.text:
        return _createButtonText();
      default:
        return Container();
    }
  }

  Widget _createButtonText() {
    return TextButton(child: _createItemButton(), onPressed: click);
  }

  Widget _createButtonSquare() {
    return ElevatedButton(child: _createItemButton(), onPressed: click);
  }

  Widget _createItemButton() {
    return icon != null ? Icon(icon) : Text(text);
  }
}
