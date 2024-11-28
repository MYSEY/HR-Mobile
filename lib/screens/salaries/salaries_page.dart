import 'package:flutter/material.dart';
import 'package:app/providers/payroll_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PayrollListPage extends ConsumerStatefulWidget {
  const PayrollListPage({Key? key}) : super(key: key);

  @override
  _SalaryPage createState() => _SalaryPage();
}

class _SalaryPage extends ConsumerState<PayrollListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(payrollProvider.notifier).fetchPayroll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final payroll = ref.watch(payrollProvider);
    final totalSalaryTaxUsd = payroll?.totalSalaryTaxUsd ?? 0;
    final totalPensionFund = payroll?.totalPensionFund ?? 0;
    final loanAmount = payroll?.loanAmount ?? 0;
    final totalStaffBook = payroll?.totalStaffBook ?? 0;
    final deduction =
        totalSalaryTaxUsd + totalPensionFund + loanAmount + totalStaffBook;

    // print("Payroll $payroll");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Salary',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        // backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: Colors.white),
            onPressed: () {
              // Add history functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.download, color: Colors.white),
            onPressed: () {
              // Add download payslip functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Section
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Payment Date: ${DateFormat('dd-MM-yyyy').format(payroll?.paymentDate ?? DateTime.now())}", // Use ?. and ?? 0
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Gross Salary: ${NumberFormat.currency(symbol: "\$").format(payroll?.totalGrossSalary ?? 0)}", // Use ?. and ?? 0
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Deductions: ${NumberFormat.currency(symbol: "\$").format(deduction)}', // Replace with actual deductions if available
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Net Salary: ${NumberFormat.currency(symbol: "\$").format(payroll?.totalSalary ?? 0)}', // Use ?. and ?? 0
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Detailed Breakdown
            Text(
              'Breakdown',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.money),
              title: Text('Basic Pay'),
              trailing: Text(
                  '\$${payroll?.basicSalary?.toString() ?? '0.00'}'), // Use ?. and ?? '0.00'
            ),
            ListTile(
              leading: Icon(Icons.money),
              title: Text('Allowance'),
              trailing: Text(
                  '\$${payroll?.totalChildAllowance?.toString() ?? '0.00'}'), // Use ?. and ?? '0.00'
            ),
            ListTile(
              leading: Icon(Icons.money_off),
              title: Text('Deductions'),
              trailing: Text(
                  '${NumberFormat.currency(symbol: "\$").format(deduction)}'), // Replace with actual deductions if available
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Bonuses'),
              trailing:
                  Text('\$${payroll?.totalSeverancePay?.toString() ?? '0.00'}'),
            ),
            Spacer(),
            // History Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/salaries/history');
                },
                child: Text('View Salary History'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
