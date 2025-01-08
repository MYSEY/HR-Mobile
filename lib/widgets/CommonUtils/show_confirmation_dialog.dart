import 'package:flutter/material.dart';

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
                      labelText: 'Enter your remark',
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
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  if (apRemark == true) {
                    if (inputController.text.trim().isEmpty) {
                      setState(() {
                        errorMessage = 'This field is required';
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
                child: Text('Yes'),
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
