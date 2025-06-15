import 'package:app/models/payroll.dart';
import 'package:flutter/material.dart';
import 'package:app/providers/payroll_history_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SalaryHistoryPage extends ConsumerStatefulWidget {
  const SalaryHistoryPage({Key? key}) : super(key: key);

  @override
  _SalaryHistoryPage createState() => _SalaryHistoryPage();
}

class _SalaryHistoryPage extends ConsumerState<SalaryHistoryPage> {
  int? selectedMonth;
  int? selectedYear;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(payrollHistoryProvider.notifier).fetchPayrolls();
    });
  }

  @override
  Widget build(BuildContext context) {
    final payrollHistory = ref.watch(payrollHistoryProvider);
    final isLoading = ref.watch(payrollHistoryProvider.notifier).isLoading;

    // Filter payroll history by selected month and year
    final filteredPayrollHistory = payrollHistory.where((record) {
      final date = record.paymentDate;
      bool matchesMonth = selectedMonth == null || date?.month == selectedMonth;
      bool matchesYear = selectedYear == null || date?.year == selectedYear;
      return matchesMonth && matchesYear;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.salaryHistory,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF9F2E32),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/salaries');
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Year Dropdown
                      DropdownButton<int?>(
                        value: selectedYear,
                        hint: Text(AppLocalizations.of(context)!.selectYear),
                        onChanged: (year) {
                          setState(() {
                            selectedYear = year;
                          });
                        },
                        items: [
                          DropdownMenuItem<int?>(
                            value: null,
                            child: Text(AppLocalizations.of(context)!.allYears),
                          ),
                          ...List.generate(5, (index) {
                            final year = DateTime.now().year - index;
                            return DropdownMenuItem<int?>(
                              value: year,
                              child: Text(year.toString()),
                            );
                          }),
                        ],
                      ),
                      // Month Dropdown
                      DropdownButton<int?>(
                        value: selectedMonth,
                        hint: Text(AppLocalizations.of(context)!.selectMonth),
                        onChanged: (month) {
                          setState(() {
                            selectedMonth = month;
                          });
                        },
                        items: [
                          DropdownMenuItem<int?>(
                            value: null,
                            child:
                                Text(AppLocalizations.of(context)!.allMonths),
                          ),
                          ...List.generate(12, (index) {
                            return DropdownMenuItem<int?>(
                              value: index + 1,
                              child: Text(
                                DateFormat.MMMM()
                                    .format(DateTime(0, index + 1)),
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: filteredPayrollHistory.isEmpty
                      ? Center(
                          child: Text(
                              AppLocalizations.of(context)!.nodataToDisplay))
                      : ListView.builder(
                          itemCount: filteredPayrollHistory.length,
                          itemBuilder: (context, index) {
                            final record = filteredPayrollHistory[index];
                            final totalSalaryTaxUsd =
                                record.totalSalaryTaxUsd ?? 0;
                            final totalPensionFund =
                                record.totalPensionFund ?? 0;
                            final loanAmount = record.loanAmount ?? 0;
                            final totalStaffBook = record.totalStaffBook ?? 0;
                            final totalEarnings = record.totalGrossSalary ?? 0;
                            final totalDeductions = totalSalaryTaxUsd +
                                totalPensionFund +
                                loanAmount +
                                totalStaffBook;
                            // final netPay = totalEarnings - totalDeductions;

                            final List<Map<String, dynamic>> earnings = [
                              {
                                "label": AppLocalizations.of(context)!
                                    .basicSalaryReceived,
                                "amount": record.basicSalary
                              },
                              {
                                "label":
                                    AppLocalizations.of(context)!.increasement,
                                "amount": record.user!.salaryIncreas
                              },
                              {
                                "label":
                                    AppLocalizations.of(context)!.monthlyQI,
                                "amount": record.monthlyQuarterlybonuses
                              },
                              {
                                "label":
                                    AppLocalizations.of(context)!.allowanceKp,
                                "amount": record.totalKnyPhcumben
                              },
                              {
                                "label":
                                    AppLocalizations.of(context)!.seniorityPayI,
                                "amount": record.seniorityPayIncludedTax
                              },
                              {
                                "label":
                                    AppLocalizations.of(context)!.seniorityPayE,
                                "amount": record.seniorityPayExcludedTax
                              },
                              {
                                "label":
                                    AppLocalizations.of(context)!.severancePay,
                                "amount": record.totalSeverancePay
                              },
                              {
                                "label": AppLocalizations.of(context)!
                                    .adjustmentIncludedTax,
                                "amount": record.adjustmentIncludeTaxe
                              },
                              {
                                "label": AppLocalizations.of(context)!
                                    .adjustmentExcludedTax,
                                "amount": record.adjustment
                              },
                              {
                                "label": AppLocalizations.of(context)!
                                    .phoneAllowance,
                                "amount": record.phoneAllowance
                              },
                              {
                                "label": AppLocalizations.of(context)!
                                    .childAllowance,
                                "amount": record.totalChildAllowance
                              },
                              {
                                "label": AppLocalizations.of(context)!
                                    .parkingAllowance,
                                "amount": record.totalAmountCar
                              },
                              {
                                "label":
                                    AppLocalizations.of(context)!.otherBenefits,
                                "amount": record.otherBenefits
                              },
                            ];
                            final List<Map<String, dynamic>> deductions = [
                              {
                                "label":
                                    AppLocalizations.of(context)!.personalTax,
                                "amount": record.totalSalaryTaxUsd
                              },
                              {
                                "label":
                                    AppLocalizations.of(context)!.pensionFund,
                                "amount": record.totalPensionFund
                              },
                              {
                                "label":
                                    AppLocalizations.of(context)!.staffLoan,
                                "amount": record.loanAmount
                              },
                              {
                                "label": AppLocalizations.of(context)!
                                    .otherDeduction,
                                "amount": record.totalStaffBook
                              },
                            ];

                            return Card(
                              margin: EdgeInsets.all(16),
                              child: ExpansionTile(
                                title: Text(
                                  AppLocalizations.of(context)!.salaryfor +
                                      ' ${DateFormat('MMM-yyyy').format(record.paymentDate ?? DateTime.now())}',
                                ),
                                subtitle: Text(
                                    AppLocalizations.of(context)!.net +
                                        ': \$${record.totalSalary}'),
                                children: [
                                  Table(
                                    children: [
                                      _buildTableHeader(context, deductions),
                                    ],
                                  ),
                                  const Divider(height: 0),
                                  SizedBox(
                                    height: 550,
                                    child: SingleChildScrollView(
                                      child: Table(
                                        columnWidths: const {
                                          0: FlexColumnWidth(3),
                                          1: FlexColumnWidth(2),
                                          2: FlexColumnWidth(3),
                                          3: FlexColumnWidth(2),
                                        },
                                        border: TableBorder.symmetric(
                                          inside: BorderSide(
                                              color: Colors.grey.shade300),
                                        ),
                                        children: _buildTableRows(
                                            earnings, deductions),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildSummaryRow(
                                    AppLocalizations.of(context)!.totalEarnings,
                                    totalEarnings,
                                    AppLocalizations.of(context)!
                                        .totalDeductions,
                                    totalDeductions,
                                    bold: true,
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      AppLocalizations.of(context)!
                                              .totalNetPay +
                                          ": \$${record.totalSalary}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
    );
  }

  TableRow _buildTableHeader(BuildContext context, deductions) {
    return TableRow(
      decoration: const BoxDecoration(color: Colors.orange),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppLocalizations.of(context)!.earning,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(AppLocalizations.of(context)!.amount,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(AppLocalizations.of(context)!.deduction,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(AppLocalizations.of(context)!.amount,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  String formatAmount(dynamic value) {
    final number = value is num ? value : double.tryParse(value.toString());
    return number != null ? '\$${number.toStringAsFixed(2)}' : '-';
  }

  List<TableRow> _buildTableRows(List<Map<String, dynamic>> earnings,
      List<Map<String, dynamic>> deductions) {
    final maxRows =
        [earnings.length, deductions.length].reduce((a, b) => a > b ? a : b);

    return List.generate(maxRows, (i) {
      final earn = i < earnings.length ? earnings[i] : null;
      final deduct = i < deductions.length ? deductions[i] : null;

      return TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(earn?["label"] ?? "", style: TextStyle(fontSize: 12)),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(earn != null ? formatAmount(earn["amount"]) : ""),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(deduct?["label"] ?? "", style: TextStyle(fontSize: 12)),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(deduct != null ? formatAmount(deduct["amount"]) : ""),
          ),
        ],
      );
    });
  }

  Widget _buildSummaryRow(
      String title1, double value1, String title2, double value2,
      {bool bold = false}) {
    final style = TextStyle(
        fontSize: 12, fontWeight: bold ? FontWeight.bold : FontWeight.normal);
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(title1, style: style),
        ),
        Expanded(
          flex: 2,
          child: Text("\$${value1.toStringAsFixed(2)}", style: style),
        ),
        Expanded(
          flex: 3,
          child: Text(title2, style: style),
        ),
        Expanded(
          flex: 2,
          child: Text("\$${value2.toStringAsFixed(2)}", style: style),
        ),
      ],
    );
  }
}
