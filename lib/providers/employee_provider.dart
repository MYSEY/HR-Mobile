import 'package:app/providers/auth_provider.dart';
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
    state = (response.data as List).map((e) => Employee.fromJson(e)).toList();
  }

  Future<void> fetchEmployeeId() async {
    final response = await ref.read(authProvider).getEmployeeId();
    state = (response.data as List).map((e) => Employee.fromJson(e)).toList();
  }

  Future<void> updateEmployee(String manpowerId, Employee employee) async {
    await ref.read(authProvider).updateEmployee(manpowerId, employee.toJson());
    fetchEmployees();
  }

  // Future<void> downloadEmployeesCsv() async {
  //   await ref.read(authProvider).downloadEmployeesCsv();
  // }
}
