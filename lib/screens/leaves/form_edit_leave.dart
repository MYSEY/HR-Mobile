import 'package:app/models/leave_request.dart';
import 'package:flutter/material.dart';

class EditRequestLeavePage extends StatelessWidget {
  final String id;
  EditRequestLeavePage({required this.id});

  final TextEditingController leaveTypeController =
      TextEditingController(text: "Sick Leave");
  final TextEditingController startDateController =
      TextEditingController(text: "2024-11-25");
  final TextEditingController endDateController =
      TextEditingController(text: "2024-11-25");
  final TextEditingController leaveReasonController =
      TextEditingController(text: "bc");
  final String handoverStaff = "My Sey"; // Example pre-selected value
  final String delegate = ""; // Example pre-selected value
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Leave Request",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leave Type Dropdown
              Text("Leave Type *"),
              DropdownButtonFormField<String>(
                value: leaveTypeController.text,
                items: [
                  DropdownMenuItem(
                      value: "Sick Leave", child: Text("Sick Leave")),
                  DropdownMenuItem(
                      value: "Casual Leave", child: Text("Casual Leave")),
                  DropdownMenuItem(
                      value: "Annual Leave", child: Text("Annual Leave")),
                ],
                onChanged: (value) {
                  leaveTypeController.text = value!;
                },
              ),
              SizedBox(height: 16),
              // Start Date
              Text("Start Date *"),
              TextFormField(
                controller: startDateController,
                decoration: InputDecoration(hintText: "YYYY-MM-DD"),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 16),
              // End Date
              Text("End Date *"),
              TextFormField(
                controller: endDateController,
                decoration: InputDecoration(hintText: "YYYY-MM-DD"),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 16),
              // Half Day Checkbox
              Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (value) {
                      // Handle checkbox toggle
                    },
                  ),
                  Text("Half Day"),
                ],
              ),
              SizedBox(height: 16),
              // Handover Staff Dropdown
              Text("Handover Staff"),
              DropdownButtonFormField<String>(
                value: handoverStaff,
                items: [
                  DropdownMenuItem(value: "My Sey", child: Text("My Sey")),
                  DropdownMenuItem(
                      value: "Other Staff", child: Text("Other Staff")),
                ],
                onChanged: (value) {
                  // Handle selection change
                },
              ),
              SizedBox(height: 16),
              // Delegate Dropdown
              Text("Delegate"),
              DropdownButtonFormField<String>(
                value: delegate,
                items: [
                  DropdownMenuItem(value: "", child: Text("None")),
                  DropdownMenuItem(value: "John Doe", child: Text("John Doe")),
                ],
                onChanged: (value) {
                  // Handle selection change
                },
              ),
              SizedBox(height: 16),
              // Leave Reason
              Text("Leave Reason *"),
              TextFormField(
                controller: leaveReasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Enter reason for leave",
                ),
              ),
              SizedBox(height: 32),
              // Save Changes Button
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle save changes logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text(
                        'Submit Request',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
