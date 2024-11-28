import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl for DateFormat
import 'package:app/models/employee.dart';

class EmployeeForm extends StatefulWidget {
  final Employee employee;
  final Function(Employee) onUpdate;

  EmployeeForm({required this.employee, required this.onUpdate});

  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  late TextEditingController _nameController;
  late TextEditingController _nric4DigitController;
  late TextEditingController _designationController;
  late TextEditingController _projectController;
  late TextEditingController _teamController;
  late TextEditingController _supervisorController;
  late TextEditingController _joinDateController;
  late TextEditingController _resignDateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee.name);
    _nric4DigitController =
        TextEditingController(text: widget.employee.nric4Digit);
    _designationController =
        TextEditingController(text: widget.employee.designation);
    _projectController = TextEditingController(text: widget.employee.project);
    _teamController = TextEditingController(text: widget.employee.team);
    _supervisorController =
        TextEditingController(text: widget.employee.supervisor);
    _joinDateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(widget.employee.joinDate));
    _resignDateController = TextEditingController(
        text: widget.employee.resignDate != null
            ? DateFormat('yyyy-MM-dd').format(widget.employee.resignDate!)
            : '');

    // Add listener to each controller
    _nameController.addListener(updateEmployee);
    _nric4DigitController.addListener(updateEmployee);
    _designationController.addListener(updateEmployee);
    _projectController.addListener(updateEmployee);
    _teamController.addListener(updateEmployee);
    _supervisorController.addListener(updateEmployee);
    // _joinDateController.addListener(updateJoinDate);
    // _resignDateController.addListener(updateResignDate);
  }

  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _nric4DigitController.dispose();
    _designationController.dispose();
    _projectController.dispose();
    _teamController.dispose();
    _supervisorController.dispose();
    _joinDateController.dispose();
    _resignDateController.dispose();
    super.dispose();
  }

  // Update employee data when any text field changes
  void updateEmployee() {
    Employee updatedEmployee = widget.employee.copyWith(
      name: _nameController.text,
      nric4Digit: _nric4DigitController.text,
      designation: _designationController.text,
      project: _projectController.text,
      team: _teamController.text,
      supervisor: _supervisorController.text,
      joinDate: DateTime.parse(_joinDateController.text),
      resignDate: _resignDateController.text.isNotEmpty
          ? DateTime.parse(_resignDateController.text)
          : null,
    );
    widget.onUpdate(updatedEmployee);
  }

  // Show date picker for joinDate
  Future<void> updateJoinDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.employee.joinDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _joinDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        updateEmployee();
      });
    }
  }

  // Show date picker for resignDate
  Future<void> updateResignDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.employee.resignDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _resignDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        updateEmployee();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Name'),
        ),
        TextField(
          controller: _nric4DigitController,
          decoration: InputDecoration(labelText: 'NRIC4Digit'),
        ),
        TextField(
          controller: _designationController,
          decoration: InputDecoration(labelText: 'Designation'),
        ),
        TextField(
          controller: _projectController,
          decoration: InputDecoration(labelText: 'Project'),
        ),
        TextField(
          controller: _teamController,
          decoration: InputDecoration(labelText: 'Team'),
        ),
        TextField(
          controller: _supervisorController,
          decoration: InputDecoration(labelText: 'Supervisor'),
        ),
        InkWell(
          onTap: updateJoinDate,
          child: IgnorePointer(
            child: TextField(
              controller: _joinDateController,
              decoration: InputDecoration(labelText: 'Join Date'),
            ),
          ),
        ),
        InkWell(
          onTap: updateResignDate,
          child: IgnorePointer(
            child: TextField(
              controller: _resignDateController,
              decoration: InputDecoration(labelText: 'Resign Date'),
            ),
          ),
        ),
      ],
    );
  }
}
