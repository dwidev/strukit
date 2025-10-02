import 'package:flutter/material.dart';

Future<void> showDeleteAlertDialog({
  required BuildContext context,
  required VoidCallback onDelete,
  VoidCallback? onCancel,
}) async {
  await showAdaptiveDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return AlertDialog.adaptive(
        title: const Text("Are you sure for delete?"),
        actions: [
          TextButton(
            onPressed: onCancel ??
                () {
                  Navigator.pop(context, false);
                },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.lightBlue),
            ),
          ),
          TextButton(
            onPressed: onDelete,
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}
