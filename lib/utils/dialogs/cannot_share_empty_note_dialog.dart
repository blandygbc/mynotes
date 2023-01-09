import 'package:flutter/material.dart';
import 'package:mynotes/l10n/generated/l10n.dart';
import 'package:mynotes/utils/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: L10n.of(context).sharing,
    content: L10n.of(context).cannot_share_empty_note_prompt,
    optionsBuilder: () => {
      L10n.of(context).ok: null,
    },
  );
}
