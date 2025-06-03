import 'package:app/models/leave_request.dart';
import 'package:app/providers/leave_request_provider.dart';
import 'package:app/widgets/CommonUtils/button.dart';
import 'package:app/widgets/CommonUtils/show_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveOnbehalfCard extends ConsumerWidget {
  final LeaveRequest leaveRequest;
  LeaveOnbehalfCard({
    required this.leaveRequest,
  });

  void _confirmDelete(
      BuildContext context, WidgetRef ref, LeaveRequest leaveRequest) async {
    final result = await showConfirmationDialog(
      context: context,
      title: "Confirm Deletion",
      subtitle: "Are you sure you want to delete this leave request?",
    );

    if (result != null && result['confirmed'] == true) {
      try {
        await ref
            .read(leaveProvider.notifier)
            .deleteRequestLeave(leaveRequest, "onbehalf", context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to delete leave request: $e"),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${leaveRequest.user?.employee_name_en ?? "N/A"}',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Type: ${leaveRequest.leaveType?.name ?? "N/A"}'),
                Text('No. of Days: ${leaveRequest.numberOfDay ?? "N/A"}'),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'From: ${DateFormat('dd-MMM-yyyy').format(leaveRequest.startDate) ?? "N/A"}'),
                Text(
                    'To: ${DateFormat('dd-MMM-yyyy').format(leaveRequest.endDate) ?? "N/A"}'),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Text('Handover Staff: '),
                Text(
                  '${leaveRequest.handoverStaff?.employee_name_en ?? "N/A"}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text('Reason: ${leaveRequest.reason}'),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 8),
                if (leaveRequest.status == "pending" ||
                    leaveRequest.status == "approved_lm") ...[
                  button(
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      _confirmDelete(context, ref, leaveRequest);
                    },
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
