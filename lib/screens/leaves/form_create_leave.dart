import 'package:app/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/leave_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/models/leave_request.dart';
import 'dart:async';

class FormRequestLeavePage extends ConsumerStatefulWidget {
  @override
  _RequestLeavePageState createState() => _RequestLeavePageState();
}

class _RequestLeavePageState extends ConsumerState<FormRequestLeavePage> {
  // final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _leaveType;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isHalfDay = false;
  String? _halfDaySession;
  String? _startDaySession;
  String? _endDaySession;
  String? _reason;
  double _numberOfDays = 0;
  String? _handoverStaff;
  String? _delegate;

  @override
  void initState() {
    super.initState();
    ref.read(leaveProvider.notifier).fetchEmployeeLeaves();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
        _isHalfDay = false;
        _halfDaySession = null;
        _calculateNumberOfDays();
      });
    }
  }

  void _calculateNumberOfDays() {
    if (_startDate != null && _endDate != null) {
      double totalDays = _endDate!.difference(_startDate!).inDays + 1;
      if (_isHalfDay && totalDays == 1) {
        totalDays = 0.5;
      }
      setState(() {
        _numberOfDays = totalDays;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final leaveState = ref.watch(leaveProvider);
    final delegates = leaveState.delegates;
    final employee = leaveState.employee;
    final leaveTypes = leaveState.leaveTypes;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add new request leave',
          style: TextStyle(color: Colors.white),
        ),
        // backgroundColor: Colors.blue,
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/leaves/list');
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _leaveType,
                decoration: InputDecoration(labelText: 'Leave Type *'),
                items: leaveTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type.id?.toString(),
                    child: Text(type.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _leaveType = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a leave type' : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(labelText: 'Start Date *'),
                controller: TextEditingController(
                    text: _startDate == null
                        ? ''
                        : DateFormat('yyyy-MM-dd').format(_startDate!)),
                onTap: () => _selectDate(context, true),
                validator: (value) =>
                    _startDate == null ? 'Please select a start date' : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(labelText: 'End Date *'),
                controller: TextEditingController(
                    text: _endDate == null
                        ? ''
                        : DateFormat('yyyy-MM-dd').format(_endDate!)),
                onTap: () => _selectDate(context, false),
                validator: (value) =>
                    _endDate == null ? 'Please select an end date' : null,
              ),
              CheckboxListTile(
                title: Text('Half Day'),
                value: _isHalfDay,
                onChanged: (value) {
                  setState(() {
                    _isHalfDay = value ?? false;
                    _calculateNumberOfDays();
                  });
                },
              ),
              if (_isHalfDay && _numberOfDays < 1)
                DropdownButtonFormField<String>(
                  value: _halfDaySession,
                  decoration: InputDecoration(labelText: 'Select Half Day'),
                  items: ['AM', 'PM'].map((session) {
                    return DropdownMenuItem<String>(
                      value: session,
                      child: Text(session),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _halfDaySession = value;
                      _calculateNumberOfDays();
                    });
                  },
                  validator: (value) => _isHalfDay && _halfDaySession == null
                      ? 'Please select an AM and PM'
                      : null,
                ),
              if (_isHalfDay && _numberOfDays > 1)
                Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _startDaySession,
                      decoration: InputDecoration(labelText: 'Start Day'),
                      items: ['AM', 'PM'].map((session) {
                        return DropdownMenuItem<String>(
                          value: session,
                          child: Text(session),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _startDaySession = value;
                          _calculateNumberOfDays();
                        });
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: _endDaySession,
                      decoration: InputDecoration(labelText: 'End Day'),
                      items: ['AM', 'PM'].map((session) {
                        return DropdownMenuItem<String>(
                          value: session,
                          child: Text(session),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _endDaySession = value;
                          _calculateNumberOfDays();
                        });
                      },
                    ),
                  ],
                ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Number of Days'),
                readOnly: true,
                controller:
                    TextEditingController(text: _numberOfDays.toString()),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _handoverStaff,
                decoration: InputDecoration(labelText: 'Handover Staff'),
                items: employee.map((emp) {
                  return DropdownMenuItem<String>(
                    value: emp.iD?.toString(),
                    child: Text(emp.employeeNameEn),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _handoverStaff = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _delegate,
                decoration: InputDecoration(labelText: 'Delegate'),
                items: delegates.map((emp) {
                  return DropdownMenuItem<String>(
                    value: emp.iD?.toString(),
                    child: Text(emp.employeeNameEn),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _delegate = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Leave Reason *'),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? 'Please provide a reason for leave' : null,
                onChanged: (value) {
                  _reason = value;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Create the LeaveRequest object with form values
                    LeaveRequest request = LeaveRequest(
                      leaveTypeId: int.tryParse(_leaveType ?? ""),
                      startDate: _startDate ?? DateTime.now(),
                      endDate: _endDate ?? DateTime.now(),
                      startHalfDay: _startDaySession,
                      endHalfDay: _endDaySession,
                      reason: _reason,
                      numberOfDay: _numberOfDays.toString(),
                      handoverStaffId: int.tryParse(_handoverStaff ?? ""),
                    );
                    await ref
                        .read(leaveProvider.notifier)
                        .createRequestLeave(request, context);
                  }
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
