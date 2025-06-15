import 'dart:ffi';
import 'package:app/screens/employees/employee_list.dart';
import 'package:flutter/material.dart';
import 'package:app/models/employee.dart';
import 'package:app/providers/education_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EducationPage extends ConsumerStatefulWidget {
  final int employeeId;

  EducationPage({Key? key, required this.employeeId}) : super(key: key);

  @override
  _EducationPageState createState() => _EducationPageState();
}

class _EducationPageState extends ConsumerState<EducationPage> {
  late int employeeId;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetEducations();
    });
  }

  void fetEducations() async {
    try {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final employee_id = args?['id'] as int?;

      if (employee_id == null) {
        throw Exception("Employee ID is required to fetch children.");
      }
      await ref.read(educationProvider.notifier).fetchEducationId(employee_id);
      debugPrint("Education information fetched successfully.");
    } catch (error) {
      debugPrint("Error fetching Education information: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentLanguage = Localizations.localeOf(context).languageCode;
    final dataEducations = ref.watch(educationProvider);
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final source = args?['source'] as String? ?? '';
    final employeeId = args?['id'] as int?;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.employmentEducation,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF9F2E32),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (source == 'myprofile') {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/myprofile', (route) => false);
            } else if (source == 'employees/detail') {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/employees/detail',
                arguments: employeeId,
                (route) => false,
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: dataEducations.isEmpty
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
                      itemCount: dataEducations.length,
                      itemBuilder: (context, index) {
                        final experience = dataEducations[index];
                        return ListTile(
                          title: Text(
                            AppLocalizations.of(context)!.date +
                                ':' "${DateFormat('dd-MMM-yyyy').format(experience.start_date!)} - ${DateFormat('dd-MMM-yyyy').format(experience.end_date!)}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context)!.institution +
                                  ':' "${experience.school}"),
                              Text(AppLocalizations.of(context)!.fieldOfStudy +
                                  ':' "${currentLanguage == "en" ? experience.FieldofStudy!.name_english : experience.FieldofStudy!.name_khmer}"),
                              Text(AppLocalizations.of(context)!.degree +
                                  ':' "${currentLanguage == "en" ? experience.Degree!.name_english : experience.Degree!.name_khmer}"),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
