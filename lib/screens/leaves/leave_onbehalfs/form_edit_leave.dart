import 'dart:convert';

import 'package:app/models/leave_request.dart';
import 'package:app/providers/leave_request_provider.dart';
import 'package:app/providers/public_holiday_provider.dart';
import 'package:flutter/material.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:app/models/leave_request.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditOnbehalfLeavePage extends ConsumerStatefulWidget {
  final LeaveRequest leaveRequest;

  const EditOnbehalfLeavePage({Key? key, required this.leaveRequest})
      : super(key: key);

  @override
  _RequestLeavePageState createState() =>
      _RequestLeavePageState(leaveRequest: leaveRequest);
}

class _RequestLeavePageState extends ConsumerState<EditOnbehalfLeavePage> {
  final LeaveRequest leaveRequest;
  _RequestLeavePageState({Key? key, required this.leaveRequest});

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
  double totalDays = 0;
  String? _handoverStaff;
  String? _delegate;
  bool? viewApprove = false;
  bool _isApplying = false;

  int countWeekdays(DateTime startDate, DateTime endDate) {
    int totalDays = 0;
    DateTime currentDate = startDate;

    while (!currentDate.isAfter(endDate)) {
      int dayOfWeek = currentDate.weekday; // 1 for Monday, 7 for Sunday
      if (dayOfWeek != DateTime.saturday && dayOfWeek != DateTime.sunday) {
        totalDays++;
      }
      currentDate = currentDate.add(Duration(days: 1));
    }

    return totalDays;
  }

  @override
  void initState() {
    super.initState();
    _getToken();
    ref.read(leaveProvider.notifier).fetchEmployeeLeaves();
    if (leaveRequest != null) {
      _leaveType = leaveRequest.leaveTypeId.toString();
      _handoverStaff = leaveRequest.handoverStaffId.toString();
      _delegate = leaveRequest.delegate?.delegate_id.toString();
      _startDate = leaveRequest.startDate;
      _endDate = leaveRequest.endDate;
      final numberOfDay = leaveRequest.numberOfDay.toString();
      _numberOfDays = double.parse(numberOfDay);
      _reason = leaveRequest.reason;
    }
    _isHalfDay =
        (leaveRequest.startHalfDay != null || leaveRequest.endHalfDay != null);
    totalDays =
        leaveRequest.endDate!.difference(leaveRequest.startDate!).inDays + 1;
    if (_isHalfDay && totalDays == 1) {
      _halfDaySession = leaveRequest.startHalfDay;
    }
    if (_isHalfDay && totalDays > 1) {
      if (leaveRequest.startHalfDay != "" &&
          leaveRequest.startHalfDay != null) {
        _startDaySession = leaveRequest.startHalfDay;
      }
      if (leaveRequest.endHalfDay != "" && leaveRequest.endHalfDay != null) {
        _endDaySession = leaveRequest.endHalfDay;
      }
    }
  }

  Future<void> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final roleString = prefs.getString('role');

    if (roleString != null) {
      final role = jsonDecode(roleString); // Convert the JSON string to a Map
      final permission = role['Permission'];
      var result = permission.firstWhere(
        (perm) => perm["name"] == "lang.leaves_admin" && perm["is_view"] == 1,
        orElse: () => null, // Return null if no match is found
      );
      if (result != null) {
        viewApprove = true;
      }
    } else {
      print("Role not found in SharedPreferences.");
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? _startDate ?? DateTime.now()),
      firstDate: isStartDate
          ? DateTime(1900)
          : (_startDate ??
              DateTime(1900)), // Prevent selecting end date before start date
      lastDate: DateTime(2101),
      selectableDayPredicate: (DateTime day) {
        return day.weekday != DateTime.saturday &&
            day.weekday != DateTime.sunday;
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;

          // Ensure end date is not before the new start date
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate;
          }
        } else {
          if (_startDate == null ||
              picked.isAfter(_startDate!) ||
              picked.isAtSameMomentAs(_startDate!)) {
            _endDate = picked;
          } else {
            // Show error if end date is before start date
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('End date cannot be before start date')),
            );
            return; // Do not update _endDate
          }
        }

        // Reset session data when date changes
        _isHalfDay = false;
        _halfDaySession = null;
        _startDaySession = null;
        _endDaySession = null;
        _calculateNumberOfDays();
      });
    }
  }

  Future<void> _calculateNumberOfDays() async {
    if (_startDate != null && _endDate != null) {
      int totalDays = countWeekdays(_startDate!, _endDate!);

      // Fetch public holidays from API
      await ref.read(publicHolidayProvider.notifier).fetchSearchHolidays(
            fromDate: _startDate,
            toDate: _endDate,
          );

      final holidays = ref.read(publicHolidayProvider);
      // Count weekdays that fall within public holidays
      int holidayWeekdays = 0;
      for (var holiday in holidays) {
        holidayWeekdays += countWeekdays(holiday.from, holiday.to!);
      }

      // Adjust total days by removing holidays
      int totalWorkDays = totalDays - holidayWeekdays;

      // Adjust for half-day selections
      double adjustedDays = totalWorkDays.toDouble();
      if (_isHalfDay && totalWorkDays == 1) {
        adjustedDays = 0.5;
      }
      if (_startDaySession != null) {
        adjustedDays -= 0.5;
      }
      if (_endDaySession != null) {
        adjustedDays -= 0.5;
      }

      setState(() {
        _numberOfDays = adjustedDays;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentLanguage = Localizations.localeOf(context).languageCode;
    final leaveState = ref.watch(leaveProvider);
    final delegates = leaveState.delegates;
    final employee = leaveState.employee;
    final leaveTypes = leaveState.leaveTypes;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.editLeaveRequest,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF9F2E32),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/leaves/onbehalf',
                arguments: viewApprove);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: leaveRequest?.leaveTypeId?.toString(),
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.leaveType + ' *'),
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
                validator: (value) => value == null
                    ? AppLocalizations.of(context)!.pleaseSelectAleaveType
                    : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.startDate + ' *'),
                controller: TextEditingController(
                    text: _startDate == null
                        ? ''
                        : DateFormat('yyyy-MM-dd').format(_startDate!)),
                onTap: () => _selectDate(context, true),
                validator: (value) => _startDate == null
                    ? AppLocalizations.of(context)!.pleaseSelectAStartDate
                    : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.endDate + ' *'),
                controller: TextEditingController(
                    text: _endDate == null
                        ? ''
                        : DateFormat('yyyy-MM-dd').format(_endDate!)),
                onTap: () => _selectDate(context, false),
                validator: (value) => _endDate == null
                    ? AppLocalizations.of(context)!.pleaseSelectSAnEndDate
                    : null,
              ),
              CheckboxListTile(
                title: Text(AppLocalizations.of(context)!.halfDay),
                value: _isHalfDay,
                onChanged: (value) {
                  if (value == false) {
                    _startDaySession = null;
                    _endDaySession = null;
                  }
                  setState(() {
                    _isHalfDay = value ?? false;
                    _calculateNumberOfDays();
                  });
                },
              ),
              if (_isHalfDay && _numberOfDays < 1)
                DropdownButtonFormField<String>(
                  value: _halfDaySession,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.selectHalfDay),
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
                      ? AppLocalizations.of(context)!.pleaseSelectAnAMandPM
                      : null,
                ),
              if (_isHalfDay && totalDays > 1)
                Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _startDaySession,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.startDay),
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
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.endDay),
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
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.numberOfDays),
                readOnly: true,
                controller:
                    TextEditingController(text: _numberOfDays.toString()),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: leaveRequest.handoverStaffId?.toString(),
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.handoverStaff),
                items: employee.map((emp) {
                  return DropdownMenuItem<String>(
                    value: emp.iD?.toString(),
                    child: Text(currentLanguage == "en"
                        ? emp.employeeNameEn
                        : emp.employeeNameKh),
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
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.textDelegate),
                items: delegates.map((emp) {
                  return DropdownMenuItem<String>(
                    value: emp.iD?.toString(),
                    child: Text(currentLanguage == "en"
                        ? emp.employeeNameEn
                        : emp.employeeNameKh),
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
                decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.leaveReason + ' *'),
                controller: TextEditingController(text: _reason.toString()),
                maxLines: 3,
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)!.pleaseProvideAreasonForLeave
                    : null,
                onChanged: (value) {
                  _reason = value;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _isApplying
                    ? null // disable the button while applying
                    : () async {
                        if (_isHalfDay != false && _halfDaySession == "AM") {
                          _startDaySession = _halfDaySession;
                        }
                        if (_isHalfDay != false && _halfDaySession == "PM") {
                          _endDaySession = _halfDaySession;
                        }
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isApplying = true;
                          });
                          // Create the LeaveRequest object with form values
                          LeaveRequest request = LeaveRequest(
                            id: leaveRequest.id,
                            leaveTypeId: int.tryParse(_leaveType ?? ""),
                            startDate: _startDate ?? DateTime.now(),
                            endDate: _endDate ?? DateTime.now(),
                            startHalfDay: _startDaySession,
                            endHalfDay: _endDaySession,
                            reason: _reason,
                            numberOfDay: _numberOfDays.toString(),
                            handoverStaffId: int.tryParse(_handoverStaff ?? ""),
                            delegateId: int.tryParse(_delegate ?? ""),
                          );
                          try {
                            final result = await ref
                                .read(leaveProvider.notifier)
                                .updateRequestLeave(request, context);
                            setState(() {
                              _isApplying = false;
                            });
                          } finally {
                            setState(() {
                              _isApplying = false;
                            });
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9F2E32),
                ),
                child: _isApplying
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Pending...',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      )
                    : Text(
                        AppLocalizations.of(context)!.apply,
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
