class Payroll {
  final int? id;
  final int? employeeId;
  final double? basicSalary;
  final double? totalGrossSalary;
  final DateTime? paymentDate;
  final double? totalChildAllowance;
  final double? phoneAllowance;
  final double? monthlyQuarterlybonuses;
  final double? totalKnyPhcumben;
  final double? annualIncentiveBonus;
  final double? seniorityPayIncludedTax;
  final double? totalPensionFund;
  final double? otherBenefits;
  final double? totalSeverancePay;
  final double? loanAmount;
  final double? totalAmountCar;
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
  final double? seniorityPayExcludedTax;
  final double? totalAmountReduced;
  final double? totalSalary;
  final String? exchangeRate;
  final String? adjustment;
  final String? adjustmentIncludeTaxe;
  final int? createdBy;
  final int? updatedBy;
  final DateTime? deletedAt;
  final User? user;

  Payroll({
    this.id,
    required this.employeeId,
    this.basicSalary = 0.0,
    this.totalGrossSalary = 0.0,
    this.paymentDate,
    this.totalChildAllowance = 0.0,
    this.phoneAllowance = 0.0,
    this.monthlyQuarterlybonuses = 0.0,
    this.totalKnyPhcumben = 0.0,
    this.annualIncentiveBonus = 0.0,
    this.seniorityPayIncludedTax = 0.0,
    this.totalPensionFund = 0.0,
    this.otherBenefits = 0.0,
    this.totalSeverancePay = 0.0,
    this.loanAmount = 0.0,
    this.totalAmountCar = 0.0,
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
    this.seniorityPayExcludedTax = 0,
    this.totalAmountReduced = 0.0,
    this.totalSalary = 0.0,
    this.exchangeRate = '0',
    this.adjustment = '0',
    this.adjustmentIncludeTaxe = '0',
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    this.user,
  });

  factory Payroll.fromJson(Map<String, dynamic> json) {
    return Payroll(
      id: json['id'] as int?,
      employeeId: json['employee_id'] as int?,
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
      monthlyQuarterlybonuses: json['monthly_quarterly_bonuses'] != null
          ? _parseDouble(json['monthly_quarterly_bonuses'])
          : null,
      totalKnyPhcumben: _parseDouble(json['total_kny_phcumben']),
      annualIncentiveBonus: _parseDouble(json['annual_incentive_bonus']),
      seniorityPayIncludedTax: _parseDouble(json['seniority_pay_included_tax']),

      totalPensionFund: _parseDouble(json['total_pension_fund']),
      otherBenefits: _parseDouble(json['other_benefits']),
      totalSeverancePay: _parseDouble(json['total_severance_pay']),
      loanAmount: _parseDouble(json['loan_amount']),
      totalAmountCar: _parseDouble(json['total_amount_car']),
      totalStaffBook: _parseDouble(json['total_staff_book']),
      baseSalaryReceivedUsd: _parseDouble(json['base_salary_received_usd']),
      baseSalaryReceivedRiel: json['base_salary_received_riel'] as String?,
      spouse: json['spouse'] as int?,
      children: json['children'] as int?,
      totalChargesReduced: json['total_charges_reduced'] as String?,
      totalTaxBaseRiel: json['total_tax_base_riel'] as String?,
      totalRate: json['total_rate'] as int?,
      totalSalaryTaxUsd: _parseDouble(json['total_salary_tax_usd']),
      totalSalaryTaxRiel: json['total_salary_tax_riel'] as String?,
      seniorityPayExcludedTax: _parseDouble(json['seniority_pay_excluded_tax']),
      totalAmountReduced: _parseDouble(json['total_amount_reduced']),
      totalSalary: _parseDouble(json['total_salary']),
      exchangeRate: json['exchange_rate'] as String?,
      adjustment: json['adjustment'] as String?,
      adjustmentIncludeTaxe: json['adjustment_include_taxe'] as String?,
      createdBy: json['created_by'] as int?,
      updatedBy: json['updated_by'] as int?,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      user: User.fromJson(json['User'] ?? {}),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is String) return double.tryParse(value) ?? 0.0;
    if (value is num) return value.toDouble();
    return 0.0;
  }

  @override
  String toString() {
    return 'Payroll('
        'id: $id,'
        'employeeId: $employeeId,'
        'basicSalary: $basicSalary,'
        'totalGrossSalary: $totalGrossSalary,'
        'paymentDate: $paymentDate,'
        'totalChildAllowance: $totalChildAllowance,'
        'phoneAllowance: $phoneAllowance,'
        'monthlyQuarterlybonuses: $monthlyQuarterlybonuses,'
        'totalKnyPhcumben: $totalKnyPhcumben,'
        'annualIncentiveBonus: $annualIncentiveBonus,'
        'seniorityPayIncludedTax: $seniorityPayIncludedTax,'
        'totalPensionFund: $totalPensionFund,'
        'otherBenefits: $otherBenefits,'
        'totalSeverancePay: $totalSeverancePay,'
        'loanAmount: $loanAmount,'
        'totalAmountCar: $totalAmountCar,'
        'totalStaffBook: $totalStaffBook,'
        'baseSalaryReceivedUsd: $baseSalaryReceivedUsd,'
        'baseSalaryReceivedRiel: $baseSalaryReceivedRiel,'
        'spouse: $spouse,'
        'children: $children,'
        'totalChargesReduced: $totalChargesReduced,'
        'totalTaxBaseRiel: $totalTaxBaseRiel,'
        'totalRate: $totalRate,'
        'totalSalaryTaxUsd: $totalSalaryTaxUsd,'
        'totalSalaryTaxRiel: $totalSalaryTaxRiel,'
        'seniorityPayExcludedTax: $seniorityPayExcludedTax,'
        'totalAmountReduced: $totalAmountReduced,'
        'totalSalary: $totalSalary,'
        'exchangeRate: $exchangeRate,'
        'adjustment: $adjustment,'
        'adjustmentIncludeTaxe: $adjustmentIncludeTaxe,'
        'createdBy: $createdBy,'
        'updatedBy: $updatedBy,'
        'deletedAt: $deletedAt,'
        'user: $user,'
        ')';
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
      'monthly_quarterly_bonuses': monthlyQuarterlybonuses,
      'total_kny_phcumben': totalKnyPhcumben,
      'annual_incentive_bonus': annualIncentiveBonus,
      'seniority_pay_included_tax': seniorityPayIncludedTax,
      'total_pension_fund': totalPensionFund,
      'other_benefits': otherBenefits,
      'total_severance_pay': totalSeverancePay,
      'loan_amount': loanAmount,
      'total_amount_car': totalAmountCar,
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
      'seniority_pay_excluded_tax': seniorityPayExcludedTax,
      'total_amount_reduced': totalAmountReduced,
      'total_salary': totalSalary,
      'exchange_rate': exchangeRate,
      'adjustment': adjustment,
      'adjustment_include_taxe': adjustmentIncludeTaxe,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'user': user,
    };
  }
}

class User {
  final double? preSalary;
  final double? basicSalary;
  final double? salaryIncreas;

  User({
    this.preSalary,
    this.basicSalary,
    this.salaryIncreas,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      preSalary: _parseDouble(json['pre_salary']),
      basicSalary: _parseDouble(json['basic_salary']),
      salaryIncreas: _parseDouble(json['salary_increas']),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is String) return double.tryParse(value) ?? 0.0;
    if (value is num) return value.toDouble();
    return 0.0;
  }
}
