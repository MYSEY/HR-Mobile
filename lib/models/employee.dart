import 'dart:convert';

class Employee {
  final int id;
  final String? numberEmployee;
  final String? lastNameKh;
  final String? firstNameKh;
  final String? lastNameEn;
  final String? firstNameEn;
  final String? employeeNameKh;
  final String? employeeNameEn;
  final int? gender;
  final String dateOfBirth;
  final String departmentId;
  final String positionId;
  final int? branchId;
  final String? profile;
  final String roleId;
  final String? unit;
  final String? level;
  final String? lineManager;
  final String dateOfCommencement;
  final String? phoneAllowance;
  final String? email;
  final String? positionType;
  final String? currentProvince;
  final String? currentDistrict;
  final String? currentCommune;
  final String? currentVillage;
  final String? currentHouseNo;
  final String? currentStreetNo;
  final String? permanentProvince;
  final String? permanentDistrict;
  final String? permanentCommune;
  final String? permanentVillage;
  final String? permanentHouseNo;
  final String? permanentStreetNo;
  final String personalPhoneNumber;
  final String maritalStatus;
  final String fdcDate;
  final String fdcEnd;
  final String udcEndDate;
  final String? resignDate;
  final String? resignReason;
  final String? remark;
  final String? empStatus;
  final int? isLoan;
  // final String? type;
  final Option? MarriedStatus;
  final Option? option;
  final Role? role;
  final Branch? branch;
  final Department? department;
  final Position? position;

  Employee({
    required this.id,
    required this.numberEmployee,
    required this.lastNameKh,
    required this.firstNameKh,
    required this.lastNameEn,
    required this.firstNameEn,
    required this.employeeNameKh,
    required this.employeeNameEn,
    required this.gender,
    required this.dateOfBirth,
    required this.departmentId,
    required this.positionId,
    required this.branchId,
    this.profile,
    required this.roleId,
    this.unit,
    this.level,
    this.lineManager,
    required this.dateOfCommencement,
    this.phoneAllowance,
    this.email,
    this.positionType,
    this.currentProvince,
    this.currentDistrict,
    this.currentCommune,
    this.currentVillage,
    this.currentHouseNo,
    this.currentStreetNo,
    this.permanentProvince,
    this.permanentDistrict,
    this.permanentCommune,
    this.permanentVillage,
    this.permanentHouseNo,
    this.permanentStreetNo,
    required this.personalPhoneNumber,
    required this.maritalStatus,
    required this.fdcDate,
    required this.fdcEnd,
    required this.udcEndDate,
    this.resignDate,
    this.resignReason,
    this.remark,
    required this.empStatus,
    required this.isLoan,
    required this.option,
    required this.MarriedStatus,
    required this.role,
    required this.branch,
    required this.department,
    required this.position,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      numberEmployee: json['number_employee']?.toString() ?? '',
      lastNameKh: json['last_name_kh']?.toString() ?? '',
      firstNameKh: json['first_name_kh']?.toString() ?? '',
      lastNameEn: json['last_name_en']?.toString() ?? '',
      firstNameEn: json['first_name_en']?.toString() ?? '',
      employeeNameKh: json['employee_name_kh']?.toString() ?? '',
      employeeNameEn: json['employee_name_en']?.toString() ?? '',
      gender: json['gender'] is int
          ? json['gender']
          : int.tryParse(json['gender'].toString()) ?? 0,
      dateOfBirth: json['date_of_birth']?.toString() ?? '',
      departmentId: json['department_id']?.toString() ?? '',
      positionId: json['position_id']?.toString() ?? '',
      branchId: json['branch_id'] is int
          ? json['branch_id']
          : int.tryParse(json['branch_id'].toString()) ?? 0,
      profile: json['profile']?.toString(),
      roleId: json['role_id']?.toString() ?? '',
      unit: json['unit']?.toString(),
      level: json['level']?.toString(),
      lineManager: json['line_manager']?.toString(),
      dateOfCommencement: json['date_of_commencement']?.toString() ?? '',
      phoneAllowance: json['phone_allowance']?.toString(),
      email: json['email']?.toString(),
      positionType: json['position_type']?.toString(),
      currentProvince: json['current_province']?.toString(),
      currentDistrict: json['current_district']?.toString(),
      currentCommune: json['current_commune']?.toString(),
      currentVillage: json['current_village']?.toString(),
      currentHouseNo: json['current_house_no']?.toString(),
      currentStreetNo: json['current_street_no']?.toString(),
      permanentProvince: json['permanent_province']?.toString(),
      permanentDistrict: json['permanent_district']?.toString(),
      permanentCommune: json['permanent_commune']?.toString(),
      permanentVillage: json['permanent_village']?.toString(),
      permanentHouseNo: json['permanent_house_no']?.toString(),
      permanentStreetNo: json['permanent_street_no']?.toString(),
      personalPhoneNumber: json['personal_phone_number']?.toString() ?? '',
      maritalStatus: json['marital_status']?.toString() ?? '',
      fdcDate: json['fdc_date']?.toString() ?? '',
      fdcEnd: json['fdc_end']?.toString() ?? '',
      udcEndDate: json['udc_end_date']?.toString() ?? '',
      resignDate: json['resign_date']?.toString(),
      resignReason: json['resign_reason']?.toString(),
      remark: json['remark']?.toString(),
      empStatus: json['emp_status']?.toString() ?? '',
      isLoan: json['is_loan'] is int
          ? json['is_loan']
          : int.tryParse(json['is_loan'].toString()) ?? 0,
      option: Option.fromJson(json['Option'] ?? {}),
      MarriedStatus: Option.fromJson(json['MarriedStatus'] ?? {}),
      role: Role.fromJson(json['Role'] ?? {}),
      branch: Branch.fromJson(json['Branch'] ?? {}),
      department: Department.fromJson(json['Department'] ?? {}),
      position: Position.fromJson(json['Position'] ?? {}),
    );
  }
  @override
  String toString() {
    return 'Employee('
        'id: $id, '
        'numberEmployee: $numberEmployee, '
        'lastNameKh: $lastNameKh, '
        'firstNameKh: $firstNameKh, '
        'lastNameEn: $lastNameEn, '
        'firstNameEn: $firstNameEn, '
        'employeeNameKh: $employeeNameKh, '
        'employeeNameEn: $employeeNameEn, '
        'gender: $gender, '
        'dateOfBirth: $dateOfBirth, '
        'departmentId: $departmentId, '
        'positionId: $positionId, '
        'branchId: $branchId, '
        'profile: $profile, '
        'roleId: $roleId, '
        'unit: $unit, '
        'level: $level, '
        'lineManager: $lineManager, '
        'dateOfCommencement: $dateOfCommencement, '
        'phoneAllowance: $phoneAllowance, '
        'email: $email, '
        'positionType: $positionType, '
        'currentProvince: $currentProvince, '
        'currentDistrict: $currentDistrict, '
        'currentCommune: $currentCommune, '
        'currentVillage: $currentVillage, '
        'currentHouseNo: $currentHouseNo, '
        'currentStreetNo: $currentStreetNo, '
        'permanentProvince: $permanentProvince, '
        'permanentDistrict: $permanentDistrict, '
        'permanentCommune: $permanentCommune, '
        'permanentVillage: $permanentVillage, '
        'permanentHouseNo: $permanentHouseNo, '
        'permanentStreetNo: $permanentStreetNo, '
        'personalPhoneNumber: $personalPhoneNumber, '
        'maritalStatus: $maritalStatus, '
        'fdcDate: $fdcDate, '
        'fdcEnd: $fdcEnd, '
        'udcEndDate: $udcEndDate, '
        'resignDate: $resignDate, '
        'resignReason: $resignReason, '
        'remark: $remark, '
        'empStatus: $empStatus, '
        'isLoan: $isLoan, '
        'option: ${option.toString()}, '
        'MarriedStatus: ${MarriedStatus.toString()}, '
        'role: ${role.toString()}, '
        'branch: ${branch.toString()}, '
        'department: ${department.toString()}, '
        'position: ${position.toString()}'
        ')';
  }
}

class Option {
  final String name_khmer;
  final String name_english;

  Option({
    required this.name_khmer,
    required this.name_english,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      name_khmer: json['name_khmer'] ?? '',
      name_english: json['name_english'] ?? '',
    );
  }
  @override
  String toString() {
    return 'Option('
        'nameKhmer: $name_khmer,'
        'nameEnglish: $name_english,'
        ')';
  }
}

class Role {
  final String role_name;
  final String role_type;

  Role({
    required this.role_name,
    required this.role_type,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      role_name: json['role_name'] ?? '',
      role_type: json['role_type'] ?? '',
    );
  }
  @override
  String toString() {
    return 'Role('
        'roleName: $role_name,'
        'roleType: $role_type,'
        ')';
  }
}

class Branch {
  final String branch_name_kh;
  final String branch_name_en;
  final String direct_manager_id;

  Branch({
    required this.branch_name_kh,
    required this.branch_name_en,
    required this.direct_manager_id,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      branch_name_kh: json['branch_name_kh'] ?? '',
      branch_name_en: json['branch_name_en'] ?? '',
      direct_manager_id: json['direct_manager_id'] ?? '',
    );
  }
  @override
  String toString() {
    return 'Branch('
        'branchNameKh: $branch_name_kh,'
        'branchNameEn: $branch_name_en,'
        'directManagerId: $direct_manager_id,'
        ')';
  }
}

class Department {
  final int? direct_manager_id;
  final String name_khmer;
  final String name_english;

  Department({
    required this.direct_manager_id,
    required this.name_khmer,
    required this.name_english,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      direct_manager_id: json['direct_manager_id'] ?? '',
      name_khmer: json['name_khmer'] ?? '',
      name_english: json['name_english'] ?? '',
    );
  }
  @override
  String toString() {
    return 'Department('
        'directManagerId: $direct_manager_id,'
        'nameKhmer: $name_khmer,'
        'nameEnglish: $name_english,'
        ')';
  }
}

class Position {
  final String name_khmer;
  final String name_english;

  Position({
    required this.name_khmer,
    required this.name_english,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      name_khmer: json['name_khmer'] ?? '',
      name_english: json['name_english'] ?? '',
    );
  }
  @override
  String toString() {
    return 'Position('
        'nameKhmer: $name_khmer,'
        'nameEnglish: $name_english,'
        ')';
  }
}

class ChildrenInfo {
  final int id;
  final int employee_id;
  final String? name;
  final String? sex;
  final DateTime? date_of_birth;
  final Option? Gender;

  ChildrenInfo({
    required this.id,
    required this.employee_id,
    required this.name,
    required this.sex,
    required this.date_of_birth,
    required this.Gender,
  });

  factory ChildrenInfo.fromJson(Map<String, dynamic> json) {
    return ChildrenInfo(
      id: json['id'] ?? 0,
      employee_id: json['employee_id'] ?? 0,
      name: json['name'],
      sex: json['sex'],
      date_of_birth: json['date_of_birth'] != null
          ? DateTime.tryParse(json['date_of_birth'])
          : null,
      Gender: json['Gender'] != null ? Option.fromJson(json['Gender']) : null,
    );
  }
  @override
  String toString() {
    return 'ChildrenInfo('
        'id: $id,'
        'employee_id: $employee_id,'
        'name: $name,'
        'sex: $sex,'
        'date_of_birth: $date_of_birth,'
        'Gender: $Gender,'
        ')';
  }
}

class Education {
  final int id;
  final int employee_id;
  final String? school;
  final String? degree;
  final String? field_of_study;
  final Option? FieldofStudy;
  final DateTime? start_date;
  final DateTime? end_date;
  final String? grade;
  final Option? Degree;

  Education({
    required this.id,
    required this.employee_id,
    required this.school,
    required this.degree,
    required this.field_of_study,
    required this.FieldofStudy,
    required this.start_date,
    required this.end_date,
    required this.grade,
    required this.Degree,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'] ?? '',
      employee_id: json['employee_id'] ?? '',
      school: json['school'] ?? '',
      degree: json['degree'] ?? '',
      field_of_study: json['field_of_study'] ?? '',
      FieldofStudy: json['FieldofStudy'] != null
          ? Option.fromJson(json['FieldofStudy'])
          : null,
      start_date: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'])
          : null,
      end_date:
          json['end_date'] != null ? DateTime.tryParse(json['end_date']) : null,
      grade: json['grade'] ?? '',
      Degree: json['Degree'] != null ? Option.fromJson(json['Degree']) : null,
    );
  }
  @override
  String toString() {
    return 'Education('
        'id: $id,'
        'employee_id: $employee_id,'
        'school: $school,'
        'degree: $degree,'
        'field_of_study: $field_of_study,'
        'FieldofStudy: $FieldofStudy,'
        'start_date: $start_date,'
        'end_date: $end_date,'
        'grade: $grade,'
        'Degree: $Degree,'
        ')';
  }
}

class Experience {
  final int id;
  final int employee_id;
  final int? employment_type;
  final String? company_name;
  final String? position;
  final String? location;
  final DateTime? start_date;
  final DateTime? end_date;
  final Option? type;

  Experience({
    required this.id,
    required this.employee_id,
    required this.employment_type,
    required this.company_name,
    required this.position,
    required this.location,
    required this.start_date,
    required this.end_date,
    required this.type,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'] ?? '',
      employee_id: json['employee_id'] ?? '',
      employment_type: json['employment_type'] ?? '',
      company_name: json['company_name'] ?? '',
      position: json['position'] ?? '',
      location: json['location'] ?? '',
      start_date: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'])
          : null,
      end_date:
          json['end_date'] != null ? DateTime.tryParse(json['end_date']) : null,
      type: json['type'] != null ? Option.fromJson(json['type']) : null,
    );
  }
  @override
  String toString() {
    return 'Experience('
        'id: $id,'
        'employee_id: $employee_id,'
        'employment_type: $employment_type,'
        'company_name: $company_name,'
        'position: $position,'
        'location: $location,'
        'start_date: $start_date,'
        'end_date: $end_date,'
        'type: $type,'
        ')';
  }
}
