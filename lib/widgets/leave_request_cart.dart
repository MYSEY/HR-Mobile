import 'package:app/models/leave_request.dart';
import 'package:app/providers/leave_request_provider.dart';
import 'package:app/widgets/CommonUtils/show_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LeaveRequestCard extends ConsumerWidget {
  final LeaveRequest leaveRequest;
  final String id;
  final String applicationType;
  final DateTime startDate;
  final DateTime endDate;
  final String leaveType;
  final String handover;
  final String reason;
  final String remark;
  final String status;
  bool showCancel = false;
  bool actionButton = false;

  LeaveRequestCard({
    required this.leaveRequest,
    required this.id,
    required this.applicationType,
    required this.startDate,
    required this.endDate,
    required this.leaveType,
    required this.handover,
    required this.reason,
    required this.remark,
    required this.status,
  });

  bool get isWithinSevenDaysAfterEnd {
    final currentDate = DateTime.now();
    final extendedEndDate = endDate.add(const Duration(days: 7));
    return currentDate.isBefore(extendedEndDate) ||
        currentDate.isAtSameMomentAs(extendedEndDate);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color statusColor = Colors.grey;
    final String statusText;
    late String txReason = reason;
    switch (status) {
      case 'rejected':
        statusColor = Colors.red;
        statusText = 'Rejected';
        txReason = remark;
      case 'pending_cancel':
        statusColor = Colors.orange;
        statusText = 'Pending Cancel';
        txReason = remark;
      case 'cancel':
      case 'cancel_hod':
        statusColor = Colors.green;
        statusText = 'Approved Cancel';
        txReason = remark;
      case 'rejected_lm':
        statusColor = Colors.red;
        statusText = 'Rejected';
        txReason = remark;
      case 'rejected_hod':
        statusColor = Colors.red;
        statusText = 'Rejected';
        txReason = remark;
      case 'approved_lm':
      case 'pending':
        statusColor = Colors.orange;
        statusText = 'Pending';
        actionButton = true;
      case 'approved_hod':
        statusColor = Colors.green;
        statusText = 'Approved';
        actionButton = isWithinSevenDaysAfterEnd;
      case 'approved':
        statusColor = Colors.green;
        statusText = 'Approved';
        actionButton = isWithinSevenDaysAfterEnd;
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown Status';
    }
    DateTime endDateCancel = leaveRequest.endDate.add(Duration(days: 7));
    DateTime currentDate = DateTime.now();

    bool showCancel = (currentDate.isBefore(endDateCancel) ||
            currentDate.isAtSameMomentAs(endDateCancel)) &&
        (leaveRequest.status == "approved_hod" ||
            leaveRequest.status == "approved");
    // return Card(
    //   margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    //   child: Padding(
    //     padding: const EdgeInsets.all(16.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         // Header Section with Leave Type and Dropdown Menu
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Text(
    //               leaveType,
    //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //             ),
    //             if (actionButton == true)
    //               _buildStatusDropdown(
    //                   context, ref, leaveRequest), // Changed to dropdown
    //           ],
    //         ),
    //         Divider(),
    //         // Body Content
    //         Text(
    //           "${DateFormat('dd-MMM-yyyy').format(startDate)} - ${DateFormat('dd-MMM-yyyy').format(endDate)}",
    //           style: TextStyle(fontSize: 16, color: Colors.black),
    //         ),
    //         Text(
    //           "${applicationType} Day",
    //           style: TextStyle(fontWeight: FontWeight.bold),
    //         ),
    //         Text(
    //           "Reason: ${txReason}",
    //         ),
    //         Text(
    //           statusText,
    //           style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      color: Colors.white,
      // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        leaveType,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.dayTaken + ":",
                      ),
                      Text(applicationType,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!.fromDate + ":"),
                      Text("${DateFormat('dd-MMM-yyyy').format(startDate)}"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.toDate + ":",
                      ),
                      Text("${DateFormat('dd-MMM-yyyy').format(endDate)}"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.handoverStaff + ":",
                      ),
                      Text(handover),
                    ],
                  ),
                  Text(
                    AppLocalizations.of(context)!.reason + ": ${txReason}",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  if (actionButton == true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (leaveRequest.status == "pending" ||
                            leaveRequest.status == "approved_lm") ...[
                          buildEditButton(context, ref, leaveRequest),
                          buildDeleteButton(context, ref, leaveRequest),
                        ],
                        if (showCancel)
                          buildCancelButton(context, ref, leaveRequest)
                        // _buildStatusDropdown(context, ref, leaveRequest),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
          _confirmCancel(context, ref, leaveRequest);
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
                Text(AppLocalizations.of(context)!.edit),
              ],
            ),
          ),
          PopupMenuItem(
            value: "delete",
            child: Row(
              children: [
                Icon(Icons.delete, color: Colors.red),
                SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.delete),
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
                Text(AppLocalizations.of(context)!.cancel),
              ],
            ),
          ),
      ],
    );
  }

  Widget buildEditButton(
      BuildContext context, WidgetRef ref, LeaveRequest leaveRequest) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/leaves/edit', arguments: leaveRequest);
      },
      child: Text(
        AppLocalizations.of(context)!.edit,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildDeleteButton(
      BuildContext context, WidgetRef ref, LeaveRequest leaveRequest) {
    return TextButton(
      onPressed: () {
        _confirmDelete(context, ref, leaveRequest);
      },
      child: Text(
        AppLocalizations.of(context)!.delete,
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildCancelButton(
      BuildContext context, WidgetRef ref, LeaveRequest leaveRequest) {
    return TextButton(
      onPressed: () {
        _confirmCancel(context, ref, leaveRequest);
      },
      child: Text(
        AppLocalizations.of(context)!.cancel,
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, WidgetRef ref, LeaveRequest leaveRequest) async {
    final result = await showConfirmationDialog(
      context: context,
      title: AppLocalizations.of(context)!.confirmDeletion,
      subtitle: AppLocalizations.of(context)!.areyousureDelete,
      // "Are you sure you want to delete this leave request?",
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

  void _confirmCancel(
      BuildContext context, WidgetRef ref, LeaveRequest leaveRequest) async {
    final result = await showConfirmationDialog(
      context: context,
      title: AppLocalizations.of(context)!.confirmCancel,
      subtitle: AppLocalizations.of(context)!.areyousureCancel,
      apRemark: true,
    );

    if (result != null && result['confirmed'] == true) {
      try {
        leaveRequest.remark = result["input"].toString();
        await ref
            .read(leaveProvider.notifier)
            .cancelRequestLeave(leaveRequest, context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to cancel leave request: $e"),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
