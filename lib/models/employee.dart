class Employee {
  final int id;
  final String nric4Digit;
  final String name;
  final String manpowerId;
  final String designation;
  final String project;
  final String team;
  final String supervisor;
  final DateTime joinDate;
  final DateTime? resignDate;

  Employee({
    required this.id,
    required this.nric4Digit,
    required this.name,
    required this.manpowerId,
    required this.designation,
    required this.project,
    required this.team,
    required this.supervisor,
    required this.joinDate,
    this.resignDate,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      nric4Digit: json['nric4Digit'],
      name: json['name'],
      manpowerId: json['manpowerId'],
      designation: json['designation'],
      project: json['project'],
      team: json['team'],
      supervisor: json['supervisor'],
      joinDate: DateTime.parse(json['joinDate']),
      resignDate: json['resignDate'] != null
          ? DateTime.parse(json['resignDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nric4Digit': nric4Digit,
      'name': name,
      'manpowerId': manpowerId,
      'designation': designation,
      'project': project,
      'team': team,
      'supervisor': supervisor,
      'joinDate': joinDate.toIso8601String(),
      'resignDate': resignDate?.toIso8601String(),
    };
  }

  Employee copyWith({
    int? id,
    String? nric4Digit,
    String? name,
    String? manpowerId,
    String? designation,
    String? project,
    String? team,
    String? supervisor,
    DateTime? joinDate,
    DateTime? resignDate,
  }) {
    return Employee(
      id: id ?? this.id,
      nric4Digit: nric4Digit ?? this.nric4Digit,
      name: name ?? this.name,
      manpowerId: manpowerId ?? this.manpowerId,
      designation: designation ?? this.designation,
      project: project ?? this.project,
      team: team ?? this.team,
      supervisor: supervisor ?? this.supervisor,
      joinDate: joinDate ?? this.joinDate,
      resignDate: resignDate ?? this.resignDate,
    );
  }
}
