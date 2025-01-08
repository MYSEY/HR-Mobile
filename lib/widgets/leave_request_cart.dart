import 'package:app/models/leave_request.dart';
import 'package:app/providers/leave_request_provider.dart';
import 'package:app/widgets/CommonUtils/show_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveRequestCard extends ConsumerWidget {
  final LeaveRequest leaveRequest;
  final String id;
  final String applicationType;
  final DateTime startDate;
  final DateTime endDate;
  final String leaveType;
  final String status;

  LeaveRequestCard({
    required this.leaveRequest,
    required this.id,
    required this.applicationType,
    required this.startDate,
    required this.endDate,
    required this.leaveType,
    required this.status,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color statusColor = Colors.grey;
    final String statusText;
    switch (status) {
      case 'rejected':
        statusColor = Colors.red;
        statusText = 'Rejected by HR';
      case 'cancel':
        statusColor = Colors.red;
        statusText = 'Cancel';
      case 'rejected_lm':
        statusColor = Colors.red;
        statusText = 'Rejected by Line Manager';
      case 'rejected_hod':
        statusColor = Colors.red;
        statusText = 'Rejected by ACEO/Head/BM';
      case 'approved_lm':
      case 'pending':
        statusColor = Colors.orange;
        statusText = 'Waiting Approve by ACEO/Head/BM';
      case 'approved_hod':
        statusColor = Colors.orange;
        statusText = 'Waiting Verify by HR';
      case 'approved':
        statusColor = Colors.green;
        statusText = 'Approved';
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown Status';
    }
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(
          leaveType,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${DateFormat('dd-MMM-yyyy').format(startDate)} - ${DateFormat('dd-MMM-yyyy').format(endDate)}",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Text(
              "${applicationType} Day",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              statusText,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        trailing: status == "pending"
            ? _buildStatusBadge(context, ref, leaveRequest)
            : SizedBox.shrink(),
      ),
    );
  }

  Widget _buildStatusBadge(
      BuildContext context, WidgetRef ref, LeaveRequest leaveRequest) {
    return Row(
      mainAxisSize: MainAxisSize
          .min, // To ensure the Row wraps tightly around its children
      children: [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.pushNamed(context, '/leaves/edit',
                arguments: leaveRequest);
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            final title = "Confirm Deletion";
            final subtitle =
                "Are you sure you want to delete this leave request?";
            final result = await showConfirmationDialog(
              context: context,
              title: title,
              subtitle: subtitle,
            );
            if (result != null && result['confirmed'] == true) {
              try {
                await ref
                    .read(leaveProvider.notifier)
                    .deleteRequestLeave(leaveRequest, context);
              } catch (e) {
                print("dare: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Failed to delete leave request: $e"),
                    duration: Duration(seconds: 3),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }
}
