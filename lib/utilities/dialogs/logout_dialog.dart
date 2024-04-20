import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context){
  return showGenericDialog(
      context: context,
      title: "Log out",
      content: "Are you sure you want to log out ?",
      optionsBuilder: () => {
        "cancel": false,
        "Log out": true,
      }).then(
        (value) => value ?? false,
  );
}