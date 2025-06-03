import 'package:app/models/leave_request.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:app/widgets/leave_onbehalf_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/leave_request_provider.dart';
import 'dart:async';

import 'package:intl/intl.dart';

class LeaveOnbehalfPage extends ConsumerStatefulWidget {
  const LeaveOnbehalfPage({Key? key}) : super(key: key);

  @override
  _LeaveOnbehalfPageState createState() => _LeaveOnbehalfPageState();
}

class _LeaveOnbehalfPageState extends ConsumerState<LeaveOnbehalfPage> {
  @override
  void initState() {
    super.initState();
    fetchLeaveOnbehalfs();
  }

  void fetchLeaveOnbehalfs() {
    ref.read(leaveProvider.notifier).fetchLeaveOnbehalfs().then((_) {
      print("Leave requests fetched successfully.");
    }).catchError((error) {
      print("Error fetching leave requests: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    final leaveState = ref.watch(leaveProvider);
    final leaveRequests = leaveState.leaveRequests;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Leave On Behalf',
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
        child: leaveRequests.isEmpty
            ? const Center(child: Text('No data to display.'))
            : ListView.builder(
                itemCount: leaveRequests.length,
                itemBuilder: (context, index) {
                  final leaveRequest = leaveRequests[index];
                  return LeaveOnbehalfCard(leaveRequest: leaveRequest);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/leaves/onbehalf/create');
        },
        child: const Icon(Icons.add),
        backgroundColor: Color(0xFF9F2E32),
      ),
    );
  }
}
