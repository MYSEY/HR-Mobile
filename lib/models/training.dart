import 'dart:convert';

class Training {
  final int id;
  final int trainingType;
  final String courseName;
  final List<String> trainerId;
  final List<String> employeeId;
  final double? costPrice;
  final int? discount;
  final DateTime startDate;
  final DateTime endDate;
  final int? durationMonth;
  final String? remark;

  Training({
    required this.id,
    required this.trainingType,
    required this.courseName,
    required this.trainerId,
    required this.employeeId,
    this.costPrice,
    this.discount,
    required this.startDate,
    required this.endDate,
    this.durationMonth,
    this.remark,
  });

  // Factory method to create Training instances from JSON
  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      id: int.parse(json['id'].toString()),
      trainingType: int.parse(json['training_type'].toString()),
      courseName: json['course_name'] as String,
      trainerId: List<String>.from(jsonDecode(json['trainer_id'])),
      employeeId: List<String>.from(jsonDecode(json['employee_id'])),
      costPrice: json['cost_price'] != null
          ? double.tryParse(
              json['cost_price'].toString()) // Safely parse cost_price
          : null,
      discount: json['discount'] != null
          ? int.parse(json['discount'].toString())
          : null,
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      durationMonth: json['duration_month'] != null
          ? int.parse(json['duration_month'].toString())
          : null,
      remark: json['remark'] as String?,
    );
  }
}
