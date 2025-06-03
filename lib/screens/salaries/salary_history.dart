import 'package:app/models/payroll.dart';
import 'package:flutter/material.dart';
import 'package:app/providers/payroll_history_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
          'Salary History',
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
                        hint: Text("Select Year"),
                        onChanged: (year) {
                          setState(() {
                            selectedYear = year;
                          });
                        },
                        items: [
                          DropdownMenuItem<int?>(
                            value: null,
                            child: Text("All Years"),
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
                        hint: Text("Select Month"),
                        onChanged: (month) {
                          setState(() {
                            selectedMonth = month;
                          });
                        },
                        items: [
                          DropdownMenuItem<int?>(
                            value: null,
                            child: Text("All Months"),
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
                      ? Center(child: Text('No payroll history available'))
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
                                "label": "Basic Salary Received",
                                "amount": record.basicSalary
                              },
                              {
                                "label": "Increasement",
                                "amount": record.user!.salaryIncreas
                              },
                              {
                                "label": "Monthly/Quarterly Incentive",
                                "amount": record.monthlyQuarterlybonuses
                              },
                              {
                                "label":
                                    "Allowance(Khmer New Year / Pechum Ben)",
                                "amount": record.totalKnyPhcumben
                              },
                              {
                                "label": "Seniority Pay (Included Tax)",
                                "amount": record.seniorityPayIncludedTax
                              },
                              {
                                "label": "Seniority Pay (Excluded Tax)",
                                "amount": record.seniorityPayExcludedTax
                              },
                              {
                                "label": "Severance Pay",
                                "amount": record.totalSeverancePay
                              },
                              {
                                "label": "Adjustment Included Tax(+/-)",
                                "amount": record.adjustmentIncludeTaxe
                              },
                              {
                                "label": "Adjustment Excluded Tax(+/-)",
                                "amount": record.adjustment
                              },
                              {
                                "label": "Phone Allowance",
                                "amount": record.phoneAllowance
                              },
                              {
                                "label": "Child Allowance",
                                "amount": record.totalChildAllowance
                              },
                              {
                                "label": "Parking Allowance",
                                "amount": record.totalAmountCar
                              },
                              {
                                "label": "Other Benefits",
                                "amount": record.otherBenefits
                              },
                            ];
                            final List<Map<String, dynamic>> deductions = [
                              {
                                "label": "Personal Tax",
                                "amount": record.totalSalaryTaxUsd
                              },
                              {
                                "label": "Pension Fund",
                                "amount": record.totalPensionFund
                              },
                              {
                                "label": "Staff Loan",
                                "amount": record.loanAmount
                              },
                              {
                                "label": "Other Deduction",
                                "amount": record.totalStaffBook
                              },
                            ];

                            return Card(
                              margin: EdgeInsets.all(16),
                              child: ExpansionTile(
                                title: Text(
                                  'Salary for ${DateFormat('MMM-yyyy').format(record.paymentDate ?? DateTime.now())}',
                                ),
                                subtitle: Text('Net: \$${record.totalSalary}'),
                                children: [
                                  Table(
                                    children: [
                                      _buildTableHeader(deductions),
                                    ],
                                  ),
                                  const Divider(height: 0),
                                  SizedBox(
                                    height: 300,
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
                                    "Total Earnings",
                                    totalEarnings,
                                    "Total Deductions",
                                    totalDeductions,
                                    bold: true,
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "Total Net Pay: \$${record.totalSalary}",
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

  TableRow _buildTableHeader(deductions) {
    return const TableRow(
      decoration: BoxDecoration(color: Colors.orange),
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Earning",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Amount",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Deduction",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Amount",
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
