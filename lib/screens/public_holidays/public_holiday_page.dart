import 'package:app/providers/public_holiday_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicHolidaysPage extends ConsumerStatefulWidget {
  const PublicHolidaysPage({Key? key}) : super(key: key);

  @override
  _PublicHolidaysPageState createState() => _PublicHolidaysPageState();
}

class _PublicHolidaysPageState extends ConsumerState<PublicHolidaysPage> {
  @override
  void initState() {
    super.initState();
    ref.read(publicHolidayProvider.notifier).fetchPublicHolidays();
  }

  @override
  Widget build(BuildContext context) {
    final publicHolidays = ref.watch(publicHolidayProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Public Holidays",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF006D77),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: publicHolidays.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: publicHolidays.length,
                itemBuilder: (context, index) {
                  final holiday = publicHolidays[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(
                        Icons.event,
                        // color: Colors.blue,
                        color: Colors.red,
                        size: 40,
                      ),
                      title: Text(
                        holiday.titleKh ?? '',
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(holiday.titleEn ?? ''),
                          Text(
                            "Date: ${holiday.getDayAttribute}",
                            style: const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: PublicHolidaysPage(),
    ),
  );
}
