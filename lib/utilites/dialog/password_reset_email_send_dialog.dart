import 'package:flutter/widgets.dart';
import 'package:mynotesfinal/utilites/dialog/generic_dialog.dart';

Future<void> showPasswordResetEmailSendDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: "Password Reset",
      content:
          "We have now send you a password reset link, please check you email",
      optionBuilder: () => {
            "Ok": null,
          });
}
