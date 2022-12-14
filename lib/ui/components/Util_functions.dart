import 'package:flutter/material.dart';

ShowSnackBarMSG(context, msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        child: Row(
          children: [
            const Expanded(
              flex: 33,
              child: Text(
                '',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Expanded(
              flex: 33,
              child: Text(
                msg,
                style: TextStyle(color: Colors.black),
              ),
            ),
            const Expanded(
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
      backgroundColor: Colors.orange[100],
      elevation: 0,
    ),
  );
}
