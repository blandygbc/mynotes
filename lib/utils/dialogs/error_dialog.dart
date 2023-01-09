import 'package:flutter/material.dart';
import 'package:mynotes/l10n/generated/l10n.dart';
import 'package:mynotes/utils/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: L10n.of(context).generic_error_prompt,
    content: text,
    optionsBuilder: () => {
      L10n.of(context).ok: null,
    },
  );
}
