import 'package:app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/services/api_service.dart';
import 'package:app/models/employee.dart';

final employeeProvider =
    StateNotifierProvider<EmployeeNotifier, List<Employee>>((ref) {
  return EmployeeNotifier(ref);
});

class EmployeeNotifier extends StateNotifier<List<Employee>> {
  EmployeeNotifier(this.ref) : super([]);
  final Ref ref;

  Future<void> fetchEmployees() async {
    final response = await ref.read(authProvider).getEmployees();
    final responseData = response.data;
    // Check if 'datas' key exists, is non-null, and is of type List
    if (responseData != null && responseData['datas'] is List) {
      final datas = responseData['datas'];
      state = (datas as List).map((e) => Employee.fromJson(e)).toList();
    } else {
      state = [];
      print(
          'Warning: "datas" field is missing, null, or not a list in the API response');
    }
  }

  Future<Employee?> fetchEmployeeId(int id) async {
    try {
      final response =
          await ref.read(authProvider).getEmployeeId(id.toString());

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;

        if (responseData.containsKey('data')) {
          if (responseData['data'] is Map<String, dynamic>) {
            // Convert the single employee object to Employee model
            return Employee.fromJson(responseData['data']);
          } else {
            debugPrint(
                'Warning: "data" field is present but not in expected format.');
            return null;
          }
        } else {
          debugPrint('Warning: "data" field is missing.');
          return null;
        }
      } else {
        debugPrint('Error: Invalid response or API error.');
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint("Error fetching employee: $e");
      debugPrint("StackTrace: $stackTrace");
      return null;
    }
  }
}
