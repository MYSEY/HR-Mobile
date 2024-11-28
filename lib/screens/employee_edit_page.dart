import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/models/employee.dart';
import 'package:app/providers/employee_provider.dart';
import 'package:app/widgets/employee_form.dart';

class EmployeeEditPage extends ConsumerStatefulWidget {
  final Employee employee;

  EmployeeEditPage({required this.employee});

  @override
  _EmployeeEditPageState createState() => _EmployeeEditPageState();
}

class _EmployeeEditPageState extends ConsumerState<EmployeeEditPage> {
  late Employee _updatedEmployee;

  @override
  void initState() {
    super.initState();
    _updatedEmployee = widget.employee;
  }

  void _updateEmployee(Employee employee) {
    setState(() {
      _updatedEmployee = employee;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Employee')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: EmployeeForm(
              employee: _updatedEmployee, onUpdate: _updateEmployee),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await ref
              .read(employeeProvider.notifier)
              .updateEmployee(_updatedEmployee.manpowerId, _updatedEmployee);
          Navigator.pop(context);
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
