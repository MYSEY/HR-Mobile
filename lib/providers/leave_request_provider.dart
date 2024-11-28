import 'package:app/providers/auth_provider.dart';
import 'package:app/screens/leaves/leave_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/services/api_service.dart';
import 'package:app/models/leave_request.dart';

final leaveProvider =
    StateNotifierProvider<LeaveNotifier, LeaveRequestsState>((ref) {
  return LeaveNotifier(ref);
});

class LeaveNotifier extends StateNotifier<LeaveRequestsState> {
  LeaveNotifier(this.ref) : super(LeaveRequestsState());
  final Ref ref;

  get context => null;

  Future<void> fetchLeaveRequests() async {
    final response = await ref.read(authProvider).getLeaveRequests();

    // Extract the 'data' field from the response
    final responseData = response.data; // Parse LeaveAllocation

    // Check if responseData is valid
    if (responseData != null && responseData is Map<String, dynamic>) {
      // Parse LeaveAllocation
      LeaveAllocation leaveAllocation =
          LeaveAllocation.fromJson(responseData['LeaveAllocation']);

      // Parse datas (leave requests)
      final datas = responseData['datas'];
      List<LeaveRequest> leaveRequests =
          (datas as List).map((e) => LeaveRequest.fromJson(e)).toList();

      // Update state with both LeaveAllocation and leaveRequests
      state = LeaveRequestsState(
        leaveAllocation: leaveAllocation,
        leaveRequests: leaveRequests,
      );
    } else {
      print("Failed to get leave requests or response is invalid.");
    }
  }

  Future<void> fetchEmployeeLeaves() async {
    final response = await ref.read(authProvider).getEmployeeLeaves();

    // Extract the 'data' field from the response
    final responseData = response.data;
    // Check if responseData is valid
    if (responseData != null && responseData is Map<String, dynamic>) {
      // Parse delegates
      final dataDelegates = responseData['delegates'];
      List<Employee> delegates =
          (dataDelegates as List).map((e) => Employee.fromJson(e)).toList();
      // Parse LeaveTypes
      final leaveTypes = responseData['leaveTypes'];
      List<LeaveTypes> leaveType =
          (leaveTypes as List).map((e) => LeaveTypes.fromJson(e)).toList();

      // Parse datas (employees)
      final datas = responseData['datas'];
      List<Employee> employee =
          (datas as List).map((e) => Employee.fromJson(e)).toList();

      state = LeaveRequestsState(
        delegates: delegates,
        employee: employee,
        leaveTypes: leaveType,
      );
    } else {
      print("Failed to get emplyee or response is invalid.");
    }
  }

  Future<void> createRequestLeave(
      LeaveRequest LeaveRequest, BuildContext context) async {
    final jsonRequest = LeaveRequest.toJson();
    try {
      final response =
          await ref.read(authProvider).createRequestLeave(jsonRequest);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Navigation happens here using the context passed from the widget
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LeaveRequestPage()),
          );
        }
      } else {
        print('Error Response Data: ${response.data}');
        throw Exception('Failed to create leave request');
      }
    } catch (e) {
      print('Error creating leave request: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error creating leave request: ${e.toString()}')),
        );
      }
    }
  }
}
