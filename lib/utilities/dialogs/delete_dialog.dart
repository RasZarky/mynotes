import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context){
  return showGenericDialog(
      context: context,
      title: "Delete",
      content: "Are you sure you want delete this item ?",
      optionsBuilder: () => {
        "cancel": false,
        "Yes": true,
      }).then(
        (value) => value ?? false,
  );
}