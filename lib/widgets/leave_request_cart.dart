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
  bool showCancel = false;

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
        statusColor = Colors.green;
        statusText = 'Approved';
      case 'approved':
        statusColor = Colors.green;
        statusText = 'Approved';
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown Status';
    }
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Section with Leave Type and Dropdown Menu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  leaveType,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                _buildStatusDropdown(
                    context, ref, leaveRequest), // Changed to dropdown
              ],
            ),
            Divider(),
            // Body Content
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
      ),
    );

    // return Card(
    //   margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    //   child: ListTile(
    //     title: Text(
    //       leaveType,
    //       style: TextStyle(fontWeight: FontWeight.bold),
    //     ),
    //     subtitle: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(
    //           "${DateFormat('dd-MMM-yyyy').format(startDate)} - ${DateFormat('dd-MMM-yyyy').format(endDate)}",
    //           style: TextStyle(fontSize: 16, color: Colors.black),
    //         ),
    //         Text(
    //           "${applicationType} Day",
    //           style: TextStyle(fontWeight: FontWeight.bold),
    //         ),
    //         Text(
    //           statusText,
    //           style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
    //         ),
    //       ],
    //     ),
    //     trailing: status == "pending"
    //         ? _buildStatusBadge(context, ref, leaveRequest)
    //         : SizedBox.shrink(),
    //   ),
    // );
  }

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
            .deleteRequestLeave(leaveRequest, "persernol", context);
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

  Widget _buildStatusDropdown(
      BuildContext context, WidgetRef ref, LeaveRequest leaveRequest) {
    // Parse the leave end date and add 7 days.
    DateTime endDate = leaveRequest.endDate.add(Duration(days: 7));
    DateTime currentDate = DateTime.now();

    bool showCancel = (currentDate.isBefore(endDate) ||
            currentDate.isAtSameMomentAs(endDate)) &&
        (leaveRequest.status == "approved_hod" ||
            leaveRequest.status == "approved");

    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.purple),
      onSelected: (value) {
        if (value == "edit") {
          Navigator.pushNamed(context, '/leaves/edit', arguments: leaveRequest);
        } else if (value == "delete") {
          _confirmDelete(context, ref, leaveRequest);
        } else if (value == "cancel") {
          // Handle the cancel leave action.
        }
      },
      itemBuilder: (BuildContext context) => [
        if (leaveRequest.status == "pending" ||
            leaveRequest.status == "approved_lm") ...[
          PopupMenuItem(
            value: "edit",
            child: Row(
              children: [
                Icon(Icons.edit, color: Colors.blue),
                SizedBox(width: 8),
                Text("Edit"),
              ],
            ),
          ),
          PopupMenuItem(
            value: "delete",
            child: Row(
              children: [
                Icon(Icons.delete, color: Colors.red),
                SizedBox(width: 8),
                Text("Delete"),
              ],
            ),
          ),
        ],
        // Show Cancel only if conditions are met.
        if (showCancel)
          PopupMenuItem(
            value: "cancel",
            child: Row(
              children: [
                Icon(Icons.cancel, color: Colors.red),
                SizedBox(width: 8),
                Text("Cancel"),
              ],
            ),
          ),
      ],
    );
  }

  // Widget _buildStatusBadge(
  //     BuildContext context, WidgetRef ref, LeaveRequest leaveRequest) {
  //   return Row(
  //     mainAxisSize: MainAxisSize
  //         .min, // To ensure the Row wraps tightly around its children
  //     children: [
  //       IconButton(
  //         icon: Icon(Icons.edit),
  //         onPressed: () {
  //           Navigator.pushNamed(context, '/leaves/edit',
  //               arguments: leaveRequest);
  //         },
  //       ),
  //       IconButton(
  //         icon: Icon(Icons.delete),
  //         onPressed: () async {
  //           final title = "Confirm Deletion";
  //           final subtitle =
  //               "Are you sure you want to delete this leave request?";
  //           final result = await showConfirmationDialog(
  //             context: context,
  //             title: title,
  //             subtitle: subtitle,
  //           );
  //           if (result != null && result['confirmed'] == true) {
  //             try {
  //               await ref
  //                   .read(leaveProvider.notifier)
  //                   .deleteRequestLeave(leaveRequest, context);
  //             } catch (e) {
  //               print("dare: $e");
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 SnackBar(
  //                   content: Text("Failed to delete leave request: $e"),
  //                   duration: Duration(seconds: 3),
  //                   backgroundColor: Colors.red,
  //                 ),
  //               );
  //             }
  //           }
  //         },
  //       ),
  //     ],
  //   );
  // }
}
