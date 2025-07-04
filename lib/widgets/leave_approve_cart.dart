import 'package:app/models/leave_request.dart';
import 'package:app/providers/leave_request_provider.dart';
import 'package:app/widgets/CommonUtils/button.dart';
import 'package:app/widgets/CommonUtils/show_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LeaveRequestApproveCard extends ConsumerWidget {
  final LeaveRequest leaveRequest;
  LeaveRequestApproveCard({
    required this.leaveRequest,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const approvableStatuses = {"pending", "approved_lm", "approved_hod"};
    String currentLanguage = Localizations.localeOf(context).languageCode;
    Color statusColor = Colors.white;
    late String? statusText = "";
    late String? txReason = leaveRequest.reason;
    if (leaveRequest.status == 'pending_cancel') {
      statusColor = Colors.red;
      statusText = 'Request cancel leave';
      txReason = leaveRequest.remark;
      leaveRequest.status = "cancel_hod";
    } else {
      statusColor = Colors.orange;
      statusText = "New leave request";
      txReason = leaveRequest.reason;
    }

    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.name + ': '),
                Text(
                  '${currentLanguage == "en" ? leaveRequest.user?.employee_name_en ?? "N/A" : leaveRequest.user?.employee_name_kh ?? "N/A"}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.type +
                    ': ${leaveRequest.leaveType?.name ?? "N/A"}'),
                Text(AppLocalizations.of(context)!.noOfDays +
                    ': ${leaveRequest.numberOfDay ?? "N/A"}'),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.from +
                    ': ${DateFormat('dd-MMM-yyyy').format(leaveRequest.startDate) ?? "N/A"}'),
                Text(AppLocalizations.of(context)!.to +
                    ': ${DateFormat('dd-MMM-yyyy').format(leaveRequest.endDate) ?? "N/A"}'),
              ],
            ),
            SizedBox(height: 4),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.handoverStaff + ': '),
                Text(
                  '${leaveRequest.handoverStaff?.employee_name_en ?? "N/A"}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(AppLocalizations.of(context)!.reason + ': ${txReason}'),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Align buttons to the right
              children: [
                // button approve leave request
                if (approvableStatuses.contains(leaveRequest.status))
                  buildApproveButton(context, ref),

                const SizedBox(width: 8),
                // button reject leave request
                if (approvableStatuses.contains(leaveRequest.status))
                  buildRejectButton(context, ref),

                if (leaveRequest.status == "cancel_hod")
                  buildCancelButton(context, ref),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildApproveButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
      ),
      child: Text(
        AppLocalizations.of(context)!.approve,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () async {
        final title = AppLocalizations.of(context)!.confirmApprove;
        final subtitle = AppLocalizations.of(context)!.areyousure;

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
            print("Error: $e");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Failed to approve leave request: $e"),
                duration: const Duration(seconds: 3),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    );
  }

  Widget buildRejectButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: Text(
        AppLocalizations.of(context)!.reject,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () async {
        final result = await showConfirmationDialog(
          context: context,
          title: AppLocalizations.of(context)!.confirmReject,
          subtitle: AppLocalizations.of(context)!.areyousureReject,
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
    );
  }

  Widget buildCancelButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
      ),
      child: Text(
        AppLocalizations.of(context)!.approveCancel,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () async {
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
    );
  }
}
