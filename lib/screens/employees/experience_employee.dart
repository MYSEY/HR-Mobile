import 'dart:ffi';
import 'package:app/screens/employees/employee_list.dart';
import 'package:flutter/material.dart';
import 'package:app/models/employee.dart';
import 'package:app/providers/experience_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ExperiencePage extends ConsumerStatefulWidget {
  final int employeeId;

  ExperiencePage({Key? key, required this.employeeId}) : super(key: key);

  @override
  _ExperiencePageState createState() => _ExperiencePageState();
}

class _ExperiencePageState extends ConsumerState<ExperiencePage> {
  late int employeeId;
  @override
  void initState() {
    super.initState();
    employeeId = widget.employeeId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetExperiences();
    });
  }

  void fetExperiences() async {
    try {
      await ref.read(experienceProvider.notifier).fetchExperiece(employeeId);
      debugPrint("Experiece information fetched successfully.");
    } catch (error) {
      debugPrint("Error fetching Experiece information: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataExperience = ref.watch(experienceProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Experience Informations",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF9F2E32),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/employees/detail',
                  arguments: employeeId);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: dataExperience.isEmpty
              ? const Center(
                  child: Text(
                    "There is no data to display.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: dataExperience.length,
                        itemBuilder: (context, index) {
                          final experience = dataExperience[index];
                          return ListTile(
                            title: Text(
                              "* Date: ${DateFormat('dd-MMM-yyyy').format(experience.start_date!)} - ${DateFormat('dd-MMM-yyyy').format(experience.end_date!)}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Company Name: ${experience.company_name}"),
                                Text(
                                    "Employment Type: ${experience.type!.name_english}"),
                                Text("Job Position	: ${experience.position!}"),
                                Text("Location	: ${experience.location!}"),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ));
  }
}
