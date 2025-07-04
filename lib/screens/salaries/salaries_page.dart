import 'package:flutter/material.dart';
import 'package:app/providers/payroll_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          AppLocalizations.of(context)!.cbPage,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF9F2E32),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.history, color: Colors.white),
        //     onPressed: () {
        //       // Add history functionality
        //     },
        //   ),
        //   IconButton(
        //     icon: Icon(Icons.download, color: Colors.white),
        //     onPressed: () {
        //       // Add download payslip functionality
        //     },
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity, // Makes it take full width of the screen
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 159, 91, 3),
                      Color(0xFFFFBB60),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.paymentDate +
                          ": ${DateFormat('MMM-yyyy').format(payroll?.paymentDate ?? DateTime.now())}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      AppLocalizations.of(context)!.basicSalary +
                          ": ${NumberFormat.currency(symbol: "\$").format(payroll?.basicSalary ?? 0)}",
                      // style:
                      //     TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      AppLocalizations.of(context)!.grossSalary +
                          ": ${NumberFormat.currency(symbol: "\$").format(payroll?.totalGrossSalary ?? 0)}",
                      // style:
                      //     TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    // SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.deductions +
                          ': ${NumberFormat.currency(symbol: "\$").format(deduction)}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    // SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.netSalary +
                          ': ${NumberFormat.currency(symbol: "\$").format(payroll?.totalSalary ?? 0)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        // color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Detailed Breakdown
            Text(
              AppLocalizations.of(context)!.breakdown,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.money),
              title: Text(AppLocalizations.of(context)!.basicPay),
              trailing: Text(
                  '\$${payroll?.basicSalary?.toString() ?? '0.00'}'), // Use ?. and ?? '0.00'
            ),
            ListTile(
              leading: Icon(Icons.money),
              title: Text(AppLocalizations.of(context)!.allowance),
              trailing: Text(
                  '\$${payroll?.totalChildAllowance?.toString() ?? '0.00'}'), // Use ?. and ?? '0.00'
            ),
            ListTile(
              leading: Icon(Icons.money_off),
              title: Text(AppLocalizations.of(context)!.deductions),
              trailing: Text(
                  '${NumberFormat.currency(symbol: "\$").format(deduction)}'), // Replace with actual deductions if available
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text(AppLocalizations.of(context)!.bonuses),
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
                child: Text(AppLocalizations.of(context)!.viewSalaryHistory),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
