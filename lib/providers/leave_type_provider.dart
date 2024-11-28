import 'package:app/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/services/api_service.dart';
import 'package:app/models/leave_type.dart';

final leaveTypeProvider =
    StateNotifierProvider<LeaveTypeNotifier, List<LeaveType>>((ref) {
  return LeaveTypeNotifier(ref);
});

class LeaveTypeNotifier extends StateNotifier<List<LeaveType>> {
  LeaveTypeNotifier(this.ref) : super([]);
  final Ref ref;

  Future<void> fetchLeaveRequests() async {
    final response = await ref.read(authProvider).getLeaveTypes();

    // Extract the 'data' field from the response
    final responseData = response.data;

    // Check if responseData is not null and is a Map
    if (responseData != null && responseData is Map<String, dynamic>) {
      final datas = responseData['datas']; // Access the 'datas' field

      // Print the data to debug
      // print("Leave Requests: $datas");

      // Parse the 'datas' field into your LeaveRequest model
      state = (datas as List).map((e) => LeaveType.fromJson(e)).toList();
    } else {
      print("Failed to get leave type or response is invalid.");
    }
  }
}
