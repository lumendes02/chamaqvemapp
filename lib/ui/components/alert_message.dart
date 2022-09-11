import 'package:flutter/material.dart';

class AlertMessage {
  Future show(
      {required BuildContext context,
      required String title,
      required String text,
      required List<Widget> button}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: button,
          );
        });
  }
}
