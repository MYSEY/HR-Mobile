import 'package:app/models/leave_request.dart';
import 'package:app/providers/leave_request_provider.dart';
import 'package:app/widgets/CommonUtils/button.dart';
import 'package:app/widgets/CommonUtils/show_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveRequestApproveCard extends ConsumerWidget {
  final LeaveRequest leaveRequest;
  LeaveRequestApproveCard({
    required this.leaveRequest,
  });

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
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              mainAxisAlignment:
                  MainAxisAlignment.end, // Align buttons to the right
              children: [
                button(
                  child: Text(
                    'Approve',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    final title = "Confirm Approve";
                    final subtitle =
                        "Are you sure you want to approve this leave request?";
                    final result = await showConfirmationDialog(
                      context: context,
                      title: title,
                      subtitle: subtitle,
                    );
                    if (result != null && result['confirmed'] == true) {
                      try {
                        await ref
                            .read(leaveProvider.notifier)
                            .approveLeave(leaveRequest, context);
                      } catch (e) {
                        print("dare: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("Failed to approve leave request: $e"),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(width: 8),
                button(
                  child: Text(
                    'Reject',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    final title = "Confirm Reject";
                    final subtitle =
                        "Are you sure you want to reject this leave request?";
                    final result = await showConfirmationDialog(
                      context: context,
                      title: title,
                      subtitle: subtitle,
                      apRemark: true,
                    );
                    if (result != null && result['confirmed'] == true) {
                      try {
                        leaveRequest.remark = result["input"].toString();
                        await ref
                            .read(leaveProvider.notifier)
                            .rejectLeave(leaveRequest, context);
                      } catch (e) {
                        print("dare: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Failed to reject leave request: $e"),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
