import 'package:flutter/material.dart';

ShowSnackBarMSG(context, msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        child: Row(
          children: const [
            Expanded(
              flex: 33,
              child: Text(
                '',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Expanded(
              flex: 33,
              child: Text(
                'Usuario Invalido',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Expanded(
              flex: 33,
              child: Text(
                '',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.purple[100],
      elevation: 0,
    ),
  );
}
