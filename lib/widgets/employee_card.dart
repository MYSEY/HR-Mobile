import 'package:flutter/material.dart';
import 'package:app/models/employee.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;

  EmployeeCard({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(employee.name),
        subtitle: Text(employee.designation),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.pushNamed(context, '/employee/edit', arguments: employee);
          },
        ),
      ),
    );
  }
}
