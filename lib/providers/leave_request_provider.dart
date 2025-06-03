import 'dart:convert';

import 'package:app/providers/auth_provider.dart';
import 'package:app/screens/leaves/leave_employees/leave_list.dart';
import 'package:app/screens/leaves/leave_onbehalfs/leave_onbehalf.dart';
import 'package:app/widgets/CommonUtils/common_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/services/api_service.dart';
import 'package:app/models/leave_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

final leaveProvider =
    StateNotifierProvider<LeaveNotifier, LeaveRequestsState>((ref) {
  return LeaveNotifier(ref);
});

class LeaveNotifier extends StateNotifier<LeaveRequestsState> {
  LeaveNotifier(this.ref) : super(LeaveRequestsState());
  final Ref ref;

  get context => null;

  Future<void> fetchLeaveRequests() async {
    try {
      // Call the API
      final response = await ref.read(authProvider).getLeaveRequests();

      // Ensure the response data is not null and is of type Map<String, dynamic>
      final responseData = response.data;
      if (responseData != null && responseData is Map<String, dynamic>) {
        // Safely parse 'LeaveAllocation'
        final leaveAllocationData = responseData['LeaveAllocation'];
        LeaveAllocation leaveAllocation = leaveAllocationData != null
            ? LeaveAllocation.fromJson(leaveAllocationData)
            : LeaveAllocation(); // Use a default or empty object

        // Safely parse 'datas' (leave requests)
        final datas = responseData['datas'];
        List<LeaveRequest> leaveRequests = datas != null
            ? (datas as List).map((e) => LeaveRequest.fromJson(e)).toList()
            : [];

        // Update the state with parsed data
        state = LeaveRequestsState(
          leaveAllocation: leaveAllocation,
          leaveRequests: leaveRequests,
        );
      } else {
        // Handle the case where responseData is null or invalid
        throw Exception("Invalid or null response data for leave requests.");
      }
    } catch (error) {
      // Log the error and set default state
      print("Error in fetchLeaveRequests: $error");
      state = LeaveRequestsState(); // Set an empty or default state
    }
  }

  Future<void> fetchLeaveOnbehalfs() async {
    try {
      // Call the API
      // state = LeaveRequestsState();
      final response = await ref.read(authProvider).getLeaveOnbehalfs();

      // Ensure the response data is not null and is of type Map<String, dynamic>
      final responseData = response.data;
      if (responseData != null && responseData is Map<String, dynamic>) {
        final datas = responseData['datas'];
        List<LeaveRequest> leaveRequests = datas != null
            ? (datas as List).map((e) => LeaveRequest.fromJson(e)).toList()
            : [];

        // Update the state with parsed data
        state = LeaveRequestsState(
          leaveRequests: leaveRequests,
        );
      } else {
        // Handle the case where responseData is null or invalid
        throw Exception("Invalid or null response data for leave requests.");
      }
    } catch (error) {
      // Log the error and set default state
      print("Error in fetchLeaveRequests: $error");
      state = LeaveRequestsState(); // Set an empty or default state
    }
  }

  Future<void> fetchLeaveApproves() async {
    try {
      final response = await ref.read(authProvider).getLeaveApproves();
      final responseData = response.data;

      if (responseData != null && responseData is Map<String, dynamic>) {
        final datas = responseData['datas'];
        List<LeaveRequest> leaveApproves = datas != null
            ? (datas as List).map((e) => LeaveRequest.fromJson(e)).toList()
            : [];

        // Update state with leaveApproves
        state = LeaveRequestsState(
          leaveRequests: leaveApproves,
        );
      } else {
        throw Exception("Invalid or null response data for leave approvals.");
      }
    } catch (error) {
      print("Error in fetchLeaveApproves: $error");
      state = LeaveRequestsState(); // Set default or empty state
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
          await ref.read(authProvider).createRequestLeave(jsonRequest, context);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Navigation happens here using the context passed from the widget
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/leaves/list');
          CommonUtils.showTopSnackbar(
              context, 'Leave request successfully', Colors.green);
        }
      } else {
        print('Error Response Data: ${response}');
        throw Exception('Failed to create leave request');
      }
    } on DioException catch (dioError) {
      final messageEroor = dioError.response?.data;
      print('error_data: $messageEroor');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Error creating leave request: ${messageEroor["error"]}')),
      );
    }
  }

  Future<void> createOnbehalfRequest(
      LeaveRequest LeaveRequest, BuildContext context) async {
    final jsonRequest = LeaveRequest.toJson();
    try {
      final response = await ref
          .read(authProvider)
          .createOnbehalfRequest(jsonRequest, context);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Navigation happens here using the context passed from the widget
        if (context.mounted) {
          final prefs = await SharedPreferences.getInstance();
          final roleString = prefs.getString('role');
          Navigator.pushReplacementNamed(context, '/leaves/onbehalf');
          CommonUtils.showTopSnackbar(
              context, 'Leave request successfully', Colors.green);
        }
      } else {
        print('Error Response Data: ${response}');
        throw Exception('Failed to create leave request');
      }
    } on DioException catch (dioError) {
      final messageEroor = dioError.response?.data;
      print('error_data: $messageEroor');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Error creating leave request: ${messageEroor["error"]}')),
      );
    }
  }

  Future<void> updateRequestLeave(
      LeaveRequest LeaveRequest, BuildContext context) async {
    final jsonRequest = LeaveRequest.toJson();
    try {
      final response =
          await ref.read(authProvider).updateRequestLeave(jsonRequest, context);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LeaveRequestPage()),
            (route) => false, // Remove all previous routes
          );
          CommonUtils.showTopSnackbar(
              context, 'Update successfully', Colors.green);
        }
      } else {
        print('Error Response Data: ${response}');
        throw Exception('Failed to update leave request');
      }
    } on DioException catch (dioError) {
      final messageEroor = dioError.response?.data;
      print('error_data: $messageEroor');
      CommonUtils.showTopSnackbar(context,
          'Error update leave request ${messageEroor["error"]}', Colors.red);
    }
  }

  Future<void> deleteRequestLeave(
      LeaveRequest LeaveRequest, String url, BuildContext context) async {
    final jsonRequest = LeaveRequest.toJson();
    try {
      final Uri uri = Uri.parse(url);
      final response =
          await ref.read(authProvider).deleteRequestLeave(jsonRequest);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (context.mounted) {
          CommonUtils.showTopSnackbar(
              context, 'Delete successfully', Colors.green);
          if (uri.toString() != "onbehalf") {
            Navigator.pushReplacementNamed(context, '/leaves/list');
          } else {
            Navigator.pushReplacementNamed(context, '/leaves/onbehalf');
          }
        }
      } else {
        print('Error Response Data: ${response.data}');
        throw Exception('Failed to create leave request');
      }
    } catch (e) {
      print('Error creating leave request: $e');
      if (context.mounted) {
        CommonUtils.showTopSnackbar(
            context, 'Error creating leave request', Colors.red);
      }
    }
  }

  Future<void> approveLeave(
      LeaveRequest LeaveRequest, BuildContext context) async {
    final jsonRequest = LeaveRequest.toJson();
    try {
      final response = await ref.read(authProvider).approveLeave(jsonRequest);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/leaves/list');
          CommonUtils.showTopSnackbar(
              context, 'Approve successfully', Colors.green);
        }
      } else {
        print('Error Response Data: ${response.data}');
        throw Exception('Failed to approve leave request');
      }
    } catch (e) {
      print('Error creating leave request: $e');
      if (context.mounted) {
        CommonUtils.showTopSnackbar(
            context, 'Error creating leave request', Colors.red);
      }
    }
  }

  Future<void> rejectLeave(
      LeaveRequest LeaveRequest, BuildContext context) async {
    final jsonRequest = LeaveRequest.toJson();
    try {
      final response = await ref.read(authProvider).rejectLeave(jsonRequest);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/leaves/list');
          CommonUtils.showTopSnackbar(
              context, 'Reject successfully', Colors.green);
        }
      } else {
        print('Error Response Data: ${response.data}');
        throw Exception('Failed to reject leave request');
      }
    } catch (e) {
      print('Error reject leave request: $e');
      if (context.mounted) {
        CommonUtils.showTopSnackbar(
            context, 'Error reject leave request', Colors.red);
      }
    }
  }
}
