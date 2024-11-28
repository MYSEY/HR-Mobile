class Payroll {
  final int? id;
  final int employeeId;
  final double? basicSalary;
  final double? totalGrossSalary;
  final DateTime? paymentDate;
  final double? totalChildAllowance;
  final double? phoneAllowance;
  final double? totalKnyPhcumben;
  final double? totalPensionFund;
  final double? totalSeverancePay;
  final double? loanAmount;
  final double? totalStaffBook;
  final double? baseSalaryReceivedUsd;
  final String? baseSalaryReceivedRiel;
  final int? spouse;
  final int? children;
  final String? totalChargesReduced;
  final String? totalTaxBaseRiel;
  final int? totalRate;
  final double? totalSalaryTaxUsd;
  final String? totalSalaryTaxRiel;
  final double? totalAmountReduced;
  final double? totalSalary;
  final String? exchangeRate;
  final int? createdBy;
  final int? updatedBy;
  final DateTime? deletedAt;

  Payroll({
    this.id,
    required this.employeeId,
    this.basicSalary = 0.0,
    this.totalGrossSalary = 0.0,
    this.paymentDate,
    this.totalChildAllowance = 0.0,
    this.phoneAllowance,
    this.totalKnyPhcumben = 0.0,
    this.totalPensionFund = 0.0,
    this.totalSeverancePay = 0.0,
    this.loanAmount = 0.0,
    this.totalStaffBook = 0.0,
    this.baseSalaryReceivedUsd = 0.0,
    this.baseSalaryReceivedRiel = '0',
    this.spouse = 0,
    this.children = 0,
    this.totalChargesReduced = '0',
    this.totalTaxBaseRiel = '0',
    this.totalRate = 0,
    this.totalSalaryTaxUsd = 0.0,
    this.totalSalaryTaxRiel = '0',
    this.totalAmountReduced = 0.0,
    this.totalSalary = 0.0,
    this.exchangeRate,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
  });

  factory Payroll.fromJson(Map<String, dynamic> json) {
    return Payroll(
      id: json['id'] as int?,
      employeeId: json['employee_id'] as int,
      basicSalary: _parseDouble(json['basic_salary']),
      totalGrossSalary: _parseDouble(json['total_gross_salary']),
      // paymentDate: DateTime.parse(
      //     json['payment_date'] ?? DateTime.now().toIso8601String()),
      paymentDate: json['payment_date'] != null
          ? DateTime.parse(json['payment_date'])
          : null,
      totalChildAllowance: _parseDouble(json['total_child_allowance']),
      phoneAllowance: json['phone_allowance'] != null
          ? _parseDouble(json['phone_allowance'])
          : null,
      totalKnyPhcumben: _parseDouble(json['total_kny_phcumben']),
      totalPensionFund: _parseDouble(json['total_pension_fund']),
      totalSeverancePay: _parseDouble(json['total_severance_pay']),
      loanAmount: _parseDouble(json['loan_amount']),
      totalStaffBook: _parseDouble(json['total_staff_book']),
      baseSalaryReceivedUsd: _parseDouble(json['base_salary_received_usd']),
      baseSalaryReceivedRiel: json['base_salary_received_riel'] as String,
      spouse: json['spouse'] as int?,
      children: json['children'] as int?,
      totalChargesReduced: json['total_charges_reduced'] as String,
      totalTaxBaseRiel: json['total_tax_base_riel'] as String,
      totalRate: json['total_rate'] as int?,
      totalSalaryTaxUsd: _parseDouble(json['total_salary_tax_usd']),
      totalSalaryTaxRiel: json['total_salary_tax_riel'] as String,
      totalAmountReduced: _parseDouble(json['total_amount_reduced']),
      totalSalary: _parseDouble(json['total_salary']),
      exchangeRate: json['exchange_rate'] as String?,
      createdBy: json['created_by'] as int?,
      updatedBy: json['updated_by'] as int?,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else if (value is num) {
      return value.toDouble();
    }
    return null;
  }

  @override
  String toString() {
    return 'Payroll(id: $id, employeeId: $employeeId, basicSalary: $basicSalary, totalGrossSalary: $totalGrossSalary, paymentDate: $paymentDate, totalChildAllowance: $totalChildAllowance, phoneAllowance: $phoneAllowance, totalKnyPhcumben: $totalKnyPhcumben, totalPensionFund: $totalPensionFund, totalSeverancePay: $totalSeverancePay, loanAmount: $loanAmount, totalStaffBook: $totalStaffBook, baseSalaryReceivedUsd: $baseSalaryReceivedUsd, baseSalaryReceivedRiel: $baseSalaryReceivedRiel, spouse: $spouse, children: $children, totalChargesReduced: $totalChargesReduced, totalTaxBaseRiel: $totalTaxBaseRiel, totalRate: $totalRate, totalSalaryTaxUsd: $totalSalaryTaxUsd, totalSalaryTaxRiel: $totalSalaryTaxRiel, totalAmountReduced: $totalAmountReduced, totalSalary: $totalSalary, exchangeRate: $exchangeRate, createdBy: $createdBy, updatedBy: $updatedBy, deletedAt: $deletedAt)';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'basic_salary': basicSalary,
      'total_gross_salary': totalGrossSalary,
      'payment_date': paymentDate?.toIso8601String(),
      'total_child_allowance': totalChildAllowance,
      'phone_allowance': phoneAllowance,
      'total_kny_phcumben': totalKnyPhcumben,
      'total_pension_fund': totalPensionFund,
      'total_severance_pay': totalSeverancePay,
      'loan_amount': loanAmount,
      'total_staff_book': totalStaffBook,
      'base_salary_received_usd': baseSalaryReceivedUsd,
      'base_salary_received_riel': baseSalaryReceivedRiel,
      'spouse': spouse,
      'children': children,
      'total_charges_reduced': totalChargesReduced,
      'total_tax_base_riel': totalTaxBaseRiel,
      'total_rate': totalRate,
      'total_salary_tax_usd': totalSalaryTaxUsd,
      'total_salary_tax_riel': totalSalaryTaxRiel,
      'total_amount_reduced': totalAmountReduced,
      'total_salary': totalSalary,
      'exchange_rate': exchangeRate,
      'created_by': createdBy,
      'updated_by': updatedBy,
    };
  }
}
