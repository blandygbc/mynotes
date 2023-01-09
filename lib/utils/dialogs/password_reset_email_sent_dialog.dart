import 'package:flutter/material.dart';
import 'package:mynotes/l10n/generated/l10n.dart';
import 'package:mynotes/utils/dialogs/generic_dialog.dart';

Future<void> showPassowordResetSentDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: L10n.of(context).password_reset,
      content: L10n.of(context).password_reset_dialog_prompt,
      optionsBuilder: () => {
            L10n.of(context).ok: null,
          });
}
