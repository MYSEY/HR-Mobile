class LeaveAllocation {
  final int employeeId;
  final String defaultAnnualLeave;
  final String defaultSickLeave;
  final String defaultSpecialLeave;
  final String defaultUnpaidLeave;
  final String totalAnnualLeave;
  final String totalSickLeave;
  final String totalSpecialLeave;
  final String totalUnpaidLeave;
  final String year1;
  final String year2;
  final String year3;
  final int createdBy;
  final int? updatedBy;

  LeaveAllocation({
    required this.employeeId,
    required this.defaultAnnualLeave,
    required this.defaultSickLeave,
    required this.defaultSpecialLeave,
    required this.defaultUnpaidLeave,
    required this.totalAnnualLeave,
    required this.totalSickLeave,
    required this.totalSpecialLeave,
    required this.totalUnpaidLeave,
    required this.year1,
    required this.year2,
    required this.year3,
    required this.createdBy,
    this.updatedBy,
  });

  // Factory method to create an instance from JSON
  factory LeaveAllocation.fromJson(Map<String, dynamic> json) {
    return LeaveAllocation(
      employeeId: json['employee_id'],
      defaultAnnualLeave: json['default_annual_leave'],
      defaultSickLeave: json['default_sick_leave'],
      defaultSpecialLeave: json['default_special_leave'],
      defaultUnpaidLeave: json['default_unpaid_leave'],
      totalAnnualLeave: json['total_annual_leave'],
      totalSickLeave: json['total_sick_leave'],
      totalSpecialLeave: json['total_special_leave'],
      totalUnpaidLeave: json['total_unpaid_leave'],
      year1: json['year_1'],
      year2: json['year_2'],
      year3: json['year_3'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'default_annual_leave': defaultAnnualLeave,
      'default_sick_leave': defaultSickLeave,
      'default_special_leave': defaultSpecialLeave,
      'default_unpaid_leave': defaultUnpaidLeave,
      'total_annual_leave': totalAnnualLeave,
      'total_sick_leave': totalSickLeave,
      'total_special_leave': totalSpecialLeave,
      'total_unpaid_leave': totalUnpaidLeave,
      'year_1': year1,
      'year_2': year2,
      'year_3': year3,
      'created_by': createdBy,
      'updated_by': updatedBy,
    };
  }
}
