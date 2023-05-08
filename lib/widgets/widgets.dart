import 'package:flutter/material.dart';

void showSnackBar(context, Color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message.toString(),
      style: const TextStyle(fontSize: 14),
    ),
    backgroundColor: Color,
    duration: const Duration(seconds: 2),
    action: SnackBarAction(
      label: "OK",
      onPressed: () {},
      textColor: Colors.white,
    ),
  ));
}
