import 'dart:convert';

class StaffTraining {
  final int id;
  final String trainingId;
  final String employeeId;
  final int? createdBy;
  final int? updatedBy;
  final DateTime? deletedAt;
  final User? user;
  final Training? training;

  StaffTraining({
    required this.id,
    required this.trainingId,
    required this.employeeId,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    this.user,
    this.training,
  });

  factory StaffTraining.fromJson(Map<String, dynamic> json) {
    return StaffTraining(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      trainingId: json['training_id'].toString(), // Ensure String
      employeeId: json['employee_id'].toString(), // Ensure String
      createdBy: json['created_by'] != null
          ? int.tryParse(json['created_by'].toString())
          : null,
      updatedBy: json['updated_by'] != null
          ? int.tryParse(json['updated_by'].toString())
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      user: json['User'] != null ? User.fromJson(json['User']) : null,
      training:
          json['Training'] != null ? Training.fromJson(json['Training']) : null,
    );
  }

  /// **Convert to JSON**
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'training_id': trainingId,
      'employee_id': employeeId,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}

class User {
  final String number_employee;
  final String employee_name_kh;
  final String employee_name_en;
  final DateTime? date_of_commencement;

  User({
    required this.number_employee,
    required this.employee_name_kh,
    required this.employee_name_en,
    required this.date_of_commencement,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      number_employee: json['number_employee'],
      employee_name_kh: json['employee_name_kh'],
      employee_name_en: json['employee_name_en'],
      date_of_commencement: json['date_of_commencement'] != null
          ? DateTime.parse(json['date_of_commencement']) // Parse correctly
          : null,
    );
  }
  @override
  String toString() {
    return 'User('
        'numberEmployee: $number_employee,'
        'employeeNameKh: $employee_name_kh,'
        'employeeNameEn: $employee_name_en,'
        'dateOfCommencement: $date_of_commencement,'
        ')';
  }
}

class Training {
  final int id;
  final int trainingType;
  final String courseName;
  final double? costPrice;
  final double? discount;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? durationMonth;
  final int? aliasCount;
  final String? remark;

  Training({
    required this.id,
    required this.trainingType,
    required this.courseName,
    this.costPrice,
    this.discount,
    required this.startDate,
    required this.endDate,
    this.durationMonth,
    this.aliasCount,
    this.remark,
  });
  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      trainingType: json['training_type'] is int
          ? json['training_type']
          : int.tryParse(json['training_type'].toString()) ?? 0,
      courseName: json['course_name'] ?? '',
      costPrice: json['cost_price'] != null
          ? double.tryParse(json['cost_price'].toString())
          : null,
      discount: json['discount'] != null
          ? double.tryParse(json['discount'].toString())
          : null,
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'])
          : null,
      endDate:
          json['end_date'] != null ? DateTime.tryParse(json['end_date']) : null,
      durationMonth: json['duration_month'] != null
          ? int.tryParse(json['duration_month'].toString())
          : null,
      aliasCount: json['alias_count'] != null
          ? int.tryParse(json['alias_count'].toString())
          : null,
      remark: json['remark'],
    );
  }
  @override
  String toString() {
    return 'Training('
        'id: $id,'
        'trainingType: $trainingType,'
        'courseName: $courseName,'
        'costPrice: $costPrice,'
        'discount: $discount,'
        'startDate: $startDate,'
        'endDate: $endDate,'
        'durationMonth: $durationMonth,'
        'aliasCount: $aliasCount,'
        'remark: $remark,'
        ')';
  }
}
