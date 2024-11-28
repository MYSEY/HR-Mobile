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
        // backgroundColor: Colors.blue,
        backgroundColor: Colors.red,
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
                                record?.totalSalaryTaxUsd ?? 0;
                            final totalPensionFund =
                                record?.totalPensionFund ?? 0;
                            final loanAmount = record?.loanAmount ?? 0;
                            final totalStaffBook = record?.totalStaffBook ?? 0;
                            final deduction = totalSalaryTaxUsd +
                                totalPensionFund +
                                loanAmount +
                                totalStaffBook;
                            return Card(
                              margin: EdgeInsets.all(8),
                              child: ExpansionTile(
                                title: Text(
                                  'Salary for ${DateFormat('MM-yyyy').format(record.paymentDate ?? DateTime.now())}',
                                ),
                                subtitle: Text('Net: \$${record.totalSalary}'),
                                children: [
                                  ListTile(
                                    title: Text('Gross Salary'),
                                    trailing:
                                        Text('\$${record.totalGrossSalary}'),
                                  ),
                                  ListTile(
                                    title: Text('Deductions'),
                                    trailing: Text('\$${deduction}'),
                                  ),
                                  ListTile(
                                    title: Text('Net Salary'),
                                    trailing: Text('\$${record.totalSalary}'),
                                  ),
                                  ListTile(
                                    title: Text('Bonuses'),
                                    trailing: Text('\$0.00'),
                                  ),
                                  ListTile(
                                    title: Text('Exchange Rate'),
                                    trailing: Text('${record.exchangeRate}'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
