class LeaveType {
  final String name;
  final String description;
  final String type;
  final String defaultDay;
  final int createdBy;
  final int? updatedBy;

  LeaveType({
    required this.name,
    required this.description,
    required this.type,
    required this.defaultDay,
    required this.createdBy,
    this.updatedBy,
  });

  // Factory method to create a LeaveType instance from JSON
  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(
      name: json['name'],
      description: json['description'],
      type: json['type'],
      defaultDay: json['default_day'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
    );
  }

  // Method to convert LeaveType instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': type,
      'default_day': defaultDay,
      'created_by': createdBy,
      'updated_by': updatedBy,
    };
  }
}
