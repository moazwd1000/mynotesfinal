import 'package:flutter/material.dart';
import 'package:mynotesfinal/utilites/dialog/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog(
    content: text,
    context: context,
    title: 'A Error Ocurred',
    optionBuilder: () => {"OK": null},
  );
}
