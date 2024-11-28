import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveRequestCard extends StatelessWidget {
  final String id;
  final String applicationType;
  final DateTime startDate;
  final DateTime endDate;
  final String leaveType;
  final String status;

  LeaveRequestCard({
    required this.id,
    required this.applicationType,
    required this.startDate,
    required this.endDate,
    required this.leaveType,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
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
              "${DateFormat('yyyy-MMM-dd').format(startDate)} - ${DateFormat('yyyy-MMM-dd').format(endDate)}",
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
            ? _buildStatusBadge(context, id)
            : SizedBox.shrink(),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, id) {
    return Row(
      mainAxisSize: MainAxisSize
          .min, // To ensure the Row wraps tightly around its children
      children: [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.pushNamed(context, '/leaves/edit', arguments: id);
            // Handle edit action
            // Navigator.pushNamed(context, '/employee/edit', arguments: leaverequest);
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            // Handle delete action
            // Show a confirmation dialog before deleting
          },
        ),
      ],
    );
  }
}
