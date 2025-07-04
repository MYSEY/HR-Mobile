import 'package:app/models/leave_request.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:app/widgets/leave_approve_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/leave_request_provider.dart';
import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LeaveAdmintPage extends ConsumerStatefulWidget {
  const LeaveAdmintPage({Key? key}) : super(key: key);

  @override
  _LeaveAdminPageState createState() => _LeaveAdminPageState();
}

class _LeaveAdminPageState extends ConsumerState<LeaveAdmintPage> {
  @override
  void initState() {
    super.initState();
    fetchApproveLeaves();
  }

  // API 1: Fetch approve leaves
  void fetchApproveLeaves() {
    ref.read(leaveProvider.notifier).fetchLeaveApproves().then((_) {
      print("Approve leaves fetched successfully.");
    }).catchError((error) {
      print("Error fetching approve leaves: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    final leaveState = ref.watch(leaveProvider);
    final leaveApproves = leaveState.leaveRequests;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.leaveAdminPage,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF9F2E32),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: leaveApproves.isEmpty
            ? Center(child: Text(AppLocalizations.of(context)!.nodataToDisplay))
            : ListView.builder(
                itemCount: leaveApproves.length,
                itemBuilder: (context, index) {
                  final leaveRequest = leaveApproves[index];
                  return LeaveRequestApproveCard(leaveRequest: leaveRequest);
                },
              ),
      ),
    );
  }
}
