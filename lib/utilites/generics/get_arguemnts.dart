import 'package:flutter/material.dart' show BuildContext, ModalRoute;

extension GetArgument on BuildContext {
  T? getArgument<T>() {
    final moduleRoute = ModalRoute.of(this);
    if (moduleRoute != null) {
      final arg = moduleRoute.settings.arguments;
      if (arg != null && arg is T) {
        return arg as T;
      }
    }
    return null;
  }
}
