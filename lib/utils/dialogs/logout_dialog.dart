import 'package:flutter/material.dart';
import 'package:mynotes/l10n/generated/l10n.dart';
import 'package:mynotes/utils/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: L10n.of(context).logout,
    content: L10n.of(context).logout_dialog_prompt,
    optionsBuilder: () => {
      L10n.of(context).cancel: false,
      L10n.of(context).logout: true,
    },
  ).then((value) => value ?? false);
}
