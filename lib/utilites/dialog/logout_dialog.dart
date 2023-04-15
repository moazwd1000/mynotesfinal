import 'package:flutter/material.dart';
import 'package:mynotesfinal/utilites/dialog/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Log Out",
    content: "Are you sure you want to log out ?",
    optionBuilder: () => {"cancel": false, "Log out": true},
  ).then((value) => value ?? false);
}
