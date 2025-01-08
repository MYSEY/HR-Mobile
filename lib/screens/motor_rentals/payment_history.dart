import 'package:app/providers/motor_rantel_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MTHistoryPage extends ConsumerStatefulWidget {
  const MTHistoryPage({Key? key}) : super(key: key);

  @override
  _MTHistoryPage createState() => _MTHistoryPage();
}

class _MTHistoryPage extends ConsumerState<MTHistoryPage> {
  int? selectedMonth;
  int? selectedYear;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(motorRantelDetailProvider.notifier).fetchMotorRantelDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final payrollHistory = ref.watch(motorRantelDetailProvider);
    final isLoading = ref.watch(motorRantelDetailProvider.notifier).isLoading;

    // Filter payroll history by selected month and year
    final filteredPayrollHistory = payrollHistory.where((record) {
      final date = record.fromDate;
      bool matchesMonth = selectedMonth == null || date?.month == selectedMonth;
      bool matchesYear = selectedYear == null || date?.year == selectedYear;
      return matchesMonth && matchesYear;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment M&T History',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        // backgroundColor: Colors.blue,
        backgroundColor: Color(0xFF006D77),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/motor/list');
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
                      ? Center(child: Text('No payment history available'))
                      : ListView.builder(
                          itemCount: filteredPayrollHistory.length,
                          itemBuilder: (context, index) {
                            final record = filteredPayrollHistory[index];
                            final totalWorkDay = record?.totalWorkDay ?? 0;
                            final totalGasoline = record?.totalGasoline ?? 0;
                            final adjustAmountKh = record?.adjustAmountKh ?? 0;
                            final amountPriceMotorRental =
                                record?.amountPriceMotorRental ?? 0;
                            final amountPriceTaplabRental =
                                record?.amountPriceTaplabRental ?? 0;
                            final amountPriceEngineOil =
                                record?.amountPriceEngineOil ?? 0;
                            final adjustAmountExclude =
                                record?.adjustAmountExclude ?? 0;
                            final adjustAmountTabpleExclude =
                                record?.adjustAmountTabpleExclude ?? 0;
                            final adjustAmountInclude =
                                record?.adjustAmountInclude ?? 0;
                            final gasolinePricePerLiter =
                                record?.gasolinePricePerLiter ?? 0;

                            final adjustAmountTabpleInclude =
                                record?.adjustAmountTabpleInclude ?? 0;
                            final adjustAmountEngineOil =
                                record?.adjustAmountEngineOil ?? 0;
                            final taxRate = record?.taxRate ?? 0;

                            final totalGasolineNetPay = totalGasoline *
                                totalWorkDay *
                                gasolinePricePerLiter;

                            //*** Calculate tax */
                            final totalInclodeTax = (amountPriceMotorRental +
                                amountPriceTaplabRental +
                                adjustAmountInclude +
                                adjustAmountTabpleInclude);
                            final deduction = (totalInclodeTax * taxRate) / 100;
                            //** end */

                            final totalNetPay = (totalInclodeTax +
                                    amountPriceEngineOil +
                                    adjustAmountExclude +
                                    adjustAmountTabpleExclude +
                                    adjustAmountEngineOil) -
                                deduction;

                            return Card(
                              margin: const EdgeInsets.all(8),
                              child: ExpansionTile(
                                title: Text(
                                  'From: ${record.fromDate != null ? DateFormat('dd-MM-yyyy').format(record.fromDate!) : ""} - To: ${record.toDate != null ? DateFormat('dd-MM-yyyy').format(record.toDate!) : ""}',
                                ),
                                subtitle:
                                    Text('Total Workingdays: $totalWorkDay'),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start, // Aligns rows to the left
                                      children: [
                                        _infoRow(
                                            'Average Unit Price (Gasoline/1L)',
                                            '${gasolinePricePerLiter} ៛'),
                                        _infoRow('Total Gasoline (Month)',
                                            '${totalGasoline * totalWorkDay} /L'),
                                        _infoRow('Total gasoline net pay',
                                            '${totalGasolineNetPay + adjustAmountKh} ៛'),
                                        _infoRow('Gross Motor Rental fee',
                                            '\$${amountPriceMotorRental}'),
                                        _infoRow(
                                            'Adjustment Motor (Included Tax)',
                                            '\$${adjustAmountInclude}'),
                                        _infoRow(
                                            'Adjustment Motor (Excluded Tax)',
                                            '\$${adjustAmountExclude}'),
                                        if (record?.startDateTaplab !=
                                            null) ...[
                                          _infoRow('Gross Taplet Fee',
                                              '\$${adjustAmountExclude}'),
                                          _infoRow(
                                              'Adjustment Tablet (Included Tax)',
                                              '\$${adjustAmountExclude}'),
                                          _infoRow(
                                              'Adjustment Tablet (Excluded Tax)',
                                              '\$${adjustAmountExclude}'),
                                        ],
                                        _infoRow('Engine oil',
                                            '\$${amountPriceEngineOil}'),
                                        _infoRow('Adjustment Engine oil',
                                            '\$${adjustAmountEngineOil}'),
                                        _infoRow('Total Deductions Tax',
                                            '${NumberFormat.currency(symbol: "\$").format(deduction)}'),
                                        _infoRow('Total net pay',
                                            '${NumberFormat.currency(symbol: "\$").format(totalNetPay)}'),
                                      ],
                                    ),
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

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Ensure equal spacing
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis, // Prevents overflow
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.right, // Align value to the right
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
