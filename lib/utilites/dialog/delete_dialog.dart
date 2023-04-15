import 'package:flutter/material.dart';
import 'package:mynotesfinal/utilites/dialog/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Delete",
    content: "Are you sure you want to Delete this item?",
    optionBuilder: () => {"cancel": false, "Yes": true},
  ).then((value) => value ?? false);
}
