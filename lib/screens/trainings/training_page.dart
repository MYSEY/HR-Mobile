import 'package:app/providers/leave_request_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final trainings = ref.watch(trainingProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Training List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF006D77),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: trainings.isEmpty
          ? Center(child: Text('No trainings available'))
          : ListView.builder(
              itemCount: trainings.length,
              itemBuilder: (context, index) {
                final training = trainings[index];

                return ListTile(
                  leading: Icon(Icons.book, color: Colors.red),
                  title: Text('Course Name: ${training.courseName}'),
                  subtitle: Text(
                      'Sart Date: ${DateFormat('yyyy-MM-dd').format(training.startDate)} - ${DateFormat('yyyy-MM-dd').format(training.endDate)}'),
                  // title: Text(training.courseName),
                  // subtitle: Text('Type: ${training.trainingType}'),
                  trailing: Text(
                    training.endDate.isAfter(DateTime.now())
                        ? 'Ongoing'
                        : 'Completed',
                    style: TextStyle(
                      color: training.endDate.isAfter(DateTime.now())
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  onTap: () {
                    // Navigate to detailed view or handle other actions on tap
                  },
                );
              },
            ),
    );
  }
}
