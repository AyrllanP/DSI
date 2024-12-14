import 'package:flutter/material.dart';

void mostrarSnackBar({
  required BuildContext context,
  required String texto,
  bool isErro = true,
}) {
  SnackBar snackBar = SnackBar(
    content: Text(texto),
    backgroundColor: isErro ? Colors.red : Colors.green,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
