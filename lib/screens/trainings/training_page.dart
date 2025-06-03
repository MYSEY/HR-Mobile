import 'package:app/models/training.dart';
import 'package:app/providers/training_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TrainingListPage extends ConsumerStatefulWidget {
  const TrainingListPage({Key? key}) : super(key: key);

  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends ConsumerState<TrainingListPage> {
  @override
  void initState() {
    super.initState();
    ref.read(trainingProvider.notifier).fetchTrainings();
  }

  /// Safely calculates the training end date
  String getMonth(StaffTraining? staffTraining) {
    if (staffTraining?.training?.durationMonth != null &&
        staffTraining?.training?.endDate != null) {
      try {
        DateTime endDate = staffTraining!.training!.endDate!;
        int durationMonths = staffTraining.training!.durationMonth!;

        // Calculate new month and year
        int newMonth = endDate.month + durationMonths;
        int newYear = endDate.year + (newMonth - 1) ~/ 12; // Adjust year
        newMonth = (newMonth - 1) % 12 + 1; // Normalize month (1-12)

        // Get last valid day of the new month
        int lastDayOfMonth = DateTime(newYear, newMonth + 1, 0).day;
        int newDay =
            endDate.day > lastDayOfMonth ? lastDayOfMonth : endDate.day;

        DateTime newDate = DateTime(newYear, newMonth, newDay);

        return DateFormat('dd-MMM-yyyy').format(newDate);
      } catch (e) {
        print("Error calculating date: $e");
        return 'Invalid date';
      }
    }
    return 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    final staffTrainings = ref.watch(trainingProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Training List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF9F2E32),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: staffTrainings.isEmpty
          ? const Center(child: Text('No trainings available'))
          : ListView.builder(
              itemCount: staffTrainings.length,
              itemBuilder: (context, index) {
                final staffTraining = staffTrainings[index];
                final durationMonth = getMonth(staffTraining);

                // Price calculations with null safety
                double price = 0.0;
                double discount = 0.0;
                double totalPrice = 0.0;

                if (staffTraining.training?.costPrice != null &&
                    staffTraining.training?.aliasCount != null &&
                    staffTraining.training!.aliasCount! > 0) {
                  double costPrice = staffTraining.training!.costPrice!;
                  int aliasCount = staffTraining.training!.aliasCount!;
                  double tDiscount = staffTraining.training?.discount ?? 0.0;

                  price = costPrice / aliasCount;
                  discount = tDiscount / aliasCount;
                  totalPrice = price - discount;
                }

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ExpansionTile(
                    title: Text(
                      staffTraining.training?.courseName ?? 'Unknown Course',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Start Date: ${staffTraining.training?.startDate != null ? DateFormat('dd-MM-yyyy').format(staffTraining.training!.startDate!) : 'N/A'} - '
                      '${staffTraining.training?.endDate != null ? DateFormat('dd-MM-yyyy').format(staffTraining.training!.endDate!) : 'N/A'}',
                    ),
                    children: [
                      ListTile(
                        title: const Text('Type of Training'),
                        trailing: Text(
                          staffTraining.training?.trainingType == 2
                              ? "External"
                              : "Internal",
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text('Price/Unit'),
                        trailing: Text('\$${price.toStringAsFixed(2)}'),
                      ),
                      ListTile(
                        title: const Text('Discount Fee'),
                        trailing: Text('\$${discount.toStringAsFixed(2)}'),
                      ),
                      ListTile(
                        title: const Text('Total'),
                        trailing: Text('\$${totalPrice.toStringAsFixed(2)}'),
                      ),
                      ListTile(
                        title: const Text('Duration Term'),
                        trailing: Text(
                          durationMonth,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
