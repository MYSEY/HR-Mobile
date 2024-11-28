import 'package:flutter/material.dart';
import 'package:app/providers/motor_rantel_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class motorListPage extends ConsumerStatefulWidget {
  const motorListPage({Key? key}) : super(key: key);

  @override
  _motorPage createState() => _motorPage();
}

class _motorPage extends ConsumerState<motorListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(motorRantelProvider.notifier).fetchMotorRantels();
    });
  }

  static int calculateAgeMotor(String year) {
    // Get the current year
    final now = DateTime.now();
    // Parse the input year
    final pastYear = int.tryParse(year) ?? now.year;
    // Calculate the age
    final age = now.year - pastYear;
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final motorRantelAPI = ref.watch(motorRantelProvider);

    //*** Information Motor rantels */
    final motor = motorRantelAPI.motorRental;
    final double priceEngineOil = motor?.priceEngineOil ?? 0;
    final double priceTaplabRental = motor?.priceTaplabRental ?? 0;
    final productYear = motor?.productYear ?? 0;
    final sheltLife = calculateAgeMotor(productYear.toString());

    double priceMotorRentel = 0.0;
    if (sheltLife >= 0 && sheltLife <= 5) {
      priceMotorRentel = 30.0;
    } else if (sheltLife > 5 && sheltLife <= 7) {
      priceMotorRentel = 25.0;
    } else if (sheltLife > 7 && sheltLife <= 10) {
      priceMotorRentel = 20.0;
    }
    //*** END */
    //*** Information Pay M&T*/
    final motorRantel = motorRantelAPI.motorRentalDetail;
    final totalWorkDay = motorRantel?.totalWorkDay ?? 0;
    final totalGasoline = motorRantel?.totalGasoline ?? 0;
    final gasolinePricePerLiter = motorRantel?.gasolinePricePerLiter ?? 0;
    final amountPriceMotorRental = motorRantel?.amountPriceMotorRental ?? 0;
    final amountPriceTaplabRental = motorRantel?.amountPriceTaplabRental ?? 0;
    final amountPriceEngineOil = motorRantel?.amountPriceEngineOil ?? 0;

    final adjustAmountExclude = motorRantel?.adjustAmountExclude ?? 0;
    final adjustAmountTabpleExclude =
        motorRantel?.adjustAmountTabpleExclude ?? 0;
    final adjustAmountInclude = motorRantel?.adjustAmountInclude ?? 0;
    final adjustAmountTabpleInclude =
        motorRantel?.adjustAmountTabpleInclude ?? 0;
    final adjustAmountEngineOil = motorRantel?.adjustAmountEngineOil ?? 0;
    final taxRate = motorRantel?.taxRate ?? 0;
    final adjustAmountKh = motorRantel?.adjustAmountKh ?? 0;

    //*** Calculate total gasoline */
    final totalGasolineNetPay =
        totalGasoline * totalWorkDay * gasolinePricePerLiter;
    // *** end */

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
    //*** END */
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Motor & Tablet',
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Date: ${DateFormat('dd-MM-yyyy').format(motorRantel?.fromDate ?? DateTime.now())} - ${DateFormat('dd-MM-yyyy').format(motorRantel?.toDate ?? DateTime.now())}", // Use ?. and ?? 0
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Total Workingdays: ${totalWorkDay}", // Use ?. and ?? 0
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Total gasoline net pay: ${totalGasolineNetPay + adjustAmountKh} ៛', // Replace with actual deductions if available
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Total Deductions: ${NumberFormat.currency(symbol: "\$").format(deduction)}', // Replace with actual deductions if available
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Total net pay: ${NumberFormat.currency(symbol: "\$").format(totalNetPay)}', // Use ?. and ?? 0
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

            Divider(),
            Text(
              'Motorcycle Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            _infoRow('Motorcycle Brand:', motor?.motorcycleBrand ?? ""),
            _infoRow('Year of Manufacture:', motor?.productYear ?? ""),
            _infoRow('Expiretion Year:', motor?.expiredYear ?? ""),
            _infoRow('Shelt Life:', sheltLife.toString()),
            _infoRow(
              'Start Date:',
              motor?.startDate != null
                  ? DateFormat('dd-MM-yyyy').format(motor!.startDate!)
                  : "",
            ),
            _infoRow(
              'End date:',
              motor?.endDate != null
                  ? DateFormat('dd-MM-yyyy').format(motor!.endDate!)
                  : "",
            ),
            _infoRow('Gasoline:',
                '${motor?.totalGasoline?.toString() ?? ""} Litters/Day'),
            _infoRow(
                'Engine Oil Price:', '\$' + priceEngineOil.toStringAsFixed(2)),
            _infoRow('Price:', '\$' + priceMotorRentel.toStringAsFixed(2)),
            if (motor?.taplabRental != null) ...[
              SizedBox(height: 20),
              Divider(),
              Text(
                'Tablet Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              _infoRow('Model:', motor?.taplabRental ?? ""),
              _infoRow('ID (IMEI):', motor?.taplabImei ?? ""),
              _infoRow(
                'Start Date:',
                motor?.startDateTaplab != null
                    ? DateFormat('dd-MM-yyyy').format(motor!.startDateTaplab!)
                    : "",
              ),
              _infoRow(
                  'Price:',
                  '\$' +
                      (motor?.priceTaplabRental?.toStringAsFixed(2) ?? "0.00")),
            ],
            Spacer(),
            // History Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/motor/histories');
                },
                child: Text('Payment M&T History'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
