class LeaveRequest {
  final int? id;
  final int? employeeId;
  final int? leaveTypeId;
  final int? requestTo;
  final int? lineManagerId;
  final int? handoverStaffId;
  final DateTime startDate;
  final String? startHalfDay;
  final DateTime endDate;
  final String? endHalfDay;
  final DateTime? approvedDate;
  final String? nextApprover;
  final String? approvedBy;
  final String? status;
  final String? numberOfDay;
  final String? totalAnnualLeave;
  final String? totalSickLeave;
  final String? totalSpecialLeave;
  final String? totalUnpaidLeave;
  final String? totalLongSickLeave;
  final String? reason;
  final String? remark;
  final int? createdBy;
  final int? updatedBy;
  final DateTime? deletedAt;
  final LeaveType? leaveType;

  LeaveRequest({
    this.id,
    this.employeeId,
    this.leaveTypeId,
    this.requestTo,
    this.lineManagerId,
    this.handoverStaffId,
    required this.startDate,
    this.startHalfDay,
    required this.endDate,
    this.endHalfDay,
    this.approvedDate,
    this.nextApprover,
    this.approvedBy,
    this.status,
    this.numberOfDay,
    this.totalAnnualLeave,
    this.totalSickLeave,
    this.totalSpecialLeave,
    this.totalUnpaidLeave,
    this.totalLongSickLeave,
    this.reason,
    this.remark,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    this.leaveType,
  });

  // Factory method for creating an instance from a JSON object
  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'] as int?,
      employeeId: json['employee_id'],
      leaveTypeId: json['leave_type_id'],
      requestTo: json['request_to'],
      lineManagerId: json['line_manager_id'],
      handoverStaffId: json['handover_staff_id'],
      startDate: DateTime.parse(json['start_date']),
      startHalfDay: json['start_half_day'],
      endDate: DateTime.parse(json['end_date']),
      endHalfDay: json['end_half_day'],
      approvedDate: json['approved_date'] != null
          ? DateTime.parse(json['approved_date'])
          : null,
      nextApprover: json['next_approver'],
      approvedBy: json['approved_by'],
      status: json['status'],
      numberOfDay: json['number_of_day'],
      totalAnnualLeave: json['total_annual_leave'],
      totalSickLeave: json['total_sick_leave'],
      totalSpecialLeave: json['total_special_leave'],
      totalUnpaidLeave: json['total_unpaid_leave'],
      totalLongSickLeave: json['total_long_sick_leave'],
      reason: json['reason'],
      remark: json['remark'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      leaveType: LeaveType.fromJson(json['Leave Type']),
    );
  }

  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'leave_type_id': leaveTypeId,
      'handover_staff_id': handoverStaffId,
      'start_date': startDate.toIso8601String(),
      'start_half_day': startHalfDay ?? '',
      'end_date': endDate.toIso8601String(),
      'end_half_day': endHalfDay ?? '',
      'number_of_day': numberOfDay,
      'reason': reason,
    };
  }
}

class LeaveType {
  final String name;

  LeaveType({required this.name});

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(name: json['name']);
  }
}

class LeaveTypes {
  final int? id;
  final String name;
  final String? description;
  final String? type;

  LeaveTypes({
    required this.id,
    required this.name,
    this.description,
    this.type,
  });

  // Factory method to create a LeaveType instance from JSON
  factory LeaveTypes.fromJson(Map<String, dynamic> json) {
    return LeaveTypes(
      id: json['id'] as int?,
      name: json['name'],
      description: json['description'],
      type: json['type'],
    );
  }

  // Method to convert LeaveType instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': type,
    };
  }
}

class LeaveAllocation {
  final int id;
  final int employeeId;
  final String totalAnnualLeave;
  final String totalSickLeave;
  final String totalSpecialLeave;
  final String totalUnpaidLeave;
  final String defaultAnnualLeave;
  final String defaultSickLeave;
  final String defaultSpecialLeave;
  final String defaultUnpaidLeave;
  final String year1;
  final String year2;
  final String year3;

  LeaveAllocation({
    required this.id,
    required this.employeeId,
    required this.totalAnnualLeave,
    required this.totalSickLeave,
    required this.totalSpecialLeave,
    required this.totalUnpaidLeave,
    required this.defaultAnnualLeave,
    required this.defaultSickLeave,
    required this.defaultSpecialLeave,
    required this.defaultUnpaidLeave,
    required this.year1,
    required this.year2,
    required this.year3,
  });

  factory LeaveAllocation.fromJson(Map<String, dynamic> json) {
    return LeaveAllocation(
      id: json['id'],
      employeeId: json['employee_id'],
      totalAnnualLeave: json['total_annual_leave'],
      totalSickLeave: json['total_sick_leave'],
      totalSpecialLeave: json['total_special_leave'],
      totalUnpaidLeave: json['total_unpaid_leave'],
      defaultAnnualLeave: json['default_annual_leave'],
      defaultSickLeave: json['default_sick_leave'],
      defaultSpecialLeave: json['default_special_leave'],
      defaultUnpaidLeave: json['default_unpaid_leave'],
      year1: json['year_1'],
      year2: json['year_2'],
      year3: json['year_3'],
    );
  }

  @override
  String toString() {
    return 'LeaveAllocation('
        'id: $id,'
        'employeeId: $employeeId,'
        'totalAnnualLeave: $totalAnnualLeave,'
        'totalSickLeave: $totalSickLeave,'
        'totalSpecialLeave: $totalSpecialLeave,'
        'totalUnpaidLeave: $totalUnpaidLeave,'
        'defaultAnnualLeave: $defaultAnnualLeave,'
        'defaultSickLeave: $defaultSickLeave,'
        'defaultSpecialLeave: $defaultSpecialLeave,'
        'defaultUnpaidLeave: $defaultUnpaidLeave,'
        'year1: $year1,'
        'year2: $year2,'
        'year3: $year3'
        ')';
  }
}

class Employee {
  final int? iD; // Make this nullable if it can be null
  final String numberEmployee;
  final String lastNameKh;
  final String firstNameKh;
  final String lastNameEn;
  final String firstNameEn;
  final String employeeNameKh;
  final String employeeNameEn;
  final int? gender; // This is already nullable

  Employee({
    required this.iD, // Mark as required if you always expect a value
    required this.numberEmployee,
    required this.lastNameKh,
    required this.firstNameKh,
    required this.lastNameEn,
    required this.firstNameEn,
    required this.employeeNameKh,
    required this.employeeNameEn,
    this.gender, // Optional, defaults to null
  });

  // Factory method for JSON deserialization
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      iD: json['id'] as int?, // Safely cast to int?
      numberEmployee: json['number_employee'] ?? '',
      lastNameKh: json['last_name_kh'] ?? '',
      firstNameKh: json['first_name_kh'] ?? '',
      lastNameEn: json['last_name_en'] ?? '',
      firstNameEn: json['first_name_en'] ?? '',
      employeeNameKh: json['employee_name_kh'] ?? '',
      employeeNameEn: json['employee_name_en'] ?? '',
      gender: json['gender'] as int?, // Already nullable
    );
  }

  // Method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': iD, // Match JSON key to be 'id'
      'number_employee': numberEmployee,
      'last_name_kh': lastNameKh,
      'first_name_kh': firstNameKh,
      'last_name_en': lastNameEn,
      'first_name_en': firstNameEn,
      'employee_name_kh': employeeNameKh,
      'employee_name_en': employeeNameEn,
      'gender': gender,
    };
  }

  @override
  String toString() {
    return 'Employee('
        'iD: $iD, '
        'numberEmployee: $numberEmployee, '
        'lastNameKh: $lastNameKh, '
        'firstNameKh: $firstNameKh, '
        'lastNameEn: $lastNameEn, '
        'firstNameEn: $firstNameEn, '
        'employeeNameKh: $employeeNameKh, '
        'employeeNameEn: $employeeNameEn, '
        'gender: $gender'
        ')';
  }
}

class LeaveRequestsState {
  final LeaveAllocation? leaveAllocation;
  final List<LeaveRequest> leaveRequests;
  final List<Employee> employee;
  final List<Employee> delegates;
  final List<LeaveTypes> leaveTypes;

  LeaveRequestsState({
    this.leaveAllocation,
    this.leaveRequests = const [],
    this.employee = const [],
    this.delegates = const [],
    this.leaveTypes = const [],
  });
}
