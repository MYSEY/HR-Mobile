import 'package:app/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/services/api_service.dart';
import 'package:app/models/leave_allocation.dart';

final leaveAllocationProvider =
    StateNotifierProvider<LeaveAllocationNotifier, List<LeaveAllocation>>(
        (ref) {
  return LeaveAllocationNotifier(ref);
});

class LeaveAllocationNotifier extends StateNotifier<List<LeaveAllocation>> {
  LeaveAllocationNotifier(this.ref) : super([]);
  final Ref ref;

  Future<void> fetchLeaveAllocation() async {
    final response = await ref.read(authProvider).getLeaveAllocation();

    // Extract the 'datas' field from the response
    final responseData = response.data['datas'];
    // print("Leave allocation: $responseData");

    // Convert the response data into a LeaveAllocation object
    LeaveAllocation leaveAllocation = LeaveAllocation.fromJson(responseData);
    print("Leave allocation: $leaveAllocation");
    // You can now use 'leaveAllocation' for state or further operations
    state = [leaveAllocation]; // Store the result in the state
  }
}
