import 'package:app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/employee_provider.dart';
import 'package:app/widgets/employee_card.dart';

class EmployeeListPage extends ConsumerStatefulWidget {
  @override
  _EmployeeListPageState createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends ConsumerState<EmployeeListPage> {
  @override
  void initState() {
    super.initState();
    ref.read(employeeProvider.notifier).fetchEmployees();
  }

  @override
  Widget build(BuildContext context) {
    final employees = ref.watch(employeeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
      ),
      body: employees.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                return EmployeeCard(employee: employees[index]);
              },
            ),
    );
  }
}
