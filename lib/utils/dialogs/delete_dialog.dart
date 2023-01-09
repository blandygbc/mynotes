import 'package:flutter/material.dart';
import 'package:mynotes/l10n/generated/l10n.dart';
import 'package:mynotes/utils/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: L10n.of(context).delete,
    content: L10n.of(context).delete_note_prompt,
    optionsBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
