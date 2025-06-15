import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<Map<String, dynamic>?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String subtitle,
  bool? apRemark,
}) async {
  final TextEditingController inputController = TextEditingController();
  String? errorMessage; // Error message for validation

  // Show the dialog and wait for user input
  Map<String, dynamic>? result = await showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(subtitle),
                if (apRemark == true) ...[
                  SizedBox(height: 10),
                  TextField(
                    controller: inputController,
                    maxLines: null,
                    minLines: 3, // Makes it a text area
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.enterYourRemark,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (errorMessage != null) ...[
                    SizedBox(height: 10),
                    Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, {'confirmed': false}),
                child: Text(AppLocalizations.of(context)!.no),
              ),
              TextButton(
                onPressed: () {
                  if (apRemark == true) {
                    if (inputController.text.trim().isEmpty) {
                      setState(() {
                        errorMessage =
                            AppLocalizations.of(context)!.thisFieldIsRequired;
                      });
                    } else {
                      setState(() {
                        errorMessage = null; // Clear error message
                      });
                      Navigator.pop(
                        context,
                        {
                          'confirmed': true,
                          'input': inputController.text.trim(),
                        },
                      );
                    }
                  } else {
                    Navigator.pop(
                      context,
                      {'confirmed': true},
                    );
                  }
                },
                child: Text(AppLocalizations.of(context)!.yes),
              ),
            ],
          );
        },
      );
    },
  );

  // Return the result and user input if confirmed
  if (result != null && result['confirmed'] == true && apRemark == true) {
    final input = result['input'] as String?;
    print("User input: $input"); // Save or process the user input
  }
  return result;
}
