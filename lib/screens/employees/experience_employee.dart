import 'dart:ffi';
import 'package:app/screens/employees/employee_list.dart';
import 'package:flutter/material.dart';
import 'package:app/models/employee.dart';
import 'package:app/providers/experience_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetExperiences();
    });
  }

  void fetExperiences() async {
    try {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final employee_id = args?['id'] as int?;

      if (employee_id == null) {
        throw Exception("Employee ID is required to fetch children.");
      }
      await ref.read(experienceProvider.notifier).fetchExperiece(employee_id);
      debugPrint("Experiece information fetched successfully.");
    } catch (error) {
      debugPrint("Error fetching Experiece information: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentLanguage = Localizations.localeOf(context).languageCode;
    final dataExperience = ref.watch(experienceProvider);
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final source = args?['source'] as String? ?? '';
    final employeeId = args?['id'] as int?;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.experienceInformations,
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
                              AppLocalizations.of(context)!.date +
                                  ':' "${DateFormat('dd-MMM-yyyy').format(experience.start_date!)} - ${DateFormat('dd-MMM-yyyy').format(experience.end_date!)}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context)!.companyName +
                                    ':' "${experience.company_name}"),
                                Text(AppLocalizations.of(context)!
                                        .employmentType +
                                    ':' "${currentLanguage == "en" ? experience.type!.name_english : experience.type!.name_khmer}"),
                                Text(AppLocalizations.of(context)!.jobPosition +
                                    ':' "${experience.position!}"),
                                Text(AppLocalizations.of(context)!.location +
                                    ':' "${experience.location!}"),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

          // Column(
          //     children: [
          //       Table(
          //         columnWidths: const {
          //           0: FlexColumnWidth(2),
          //           1: FlexColumnWidth(2),
          //           2: FlexColumnWidth(2),
          //           3: FlexColumnWidth(2),
          //           4: FlexColumnWidth(2),
          //         },
          //         children: [
          //           _buildTableHeader(), // assume this returns a TableRow
          //         ],
          //       ),
          //       const Divider(height: 0),
          //       SizedBox(
          //         height: MediaQuery.of(context).size.height * 0.5,
          //         child: SingleChildScrollView(
          //           child: Table(
          //             columnWidths: const {
          //               0: FlexColumnWidth(2),
          //               1: FlexColumnWidth(2),
          //               2: FlexColumnWidth(2),
          //               3: FlexColumnWidth(2),
          //               4: FlexColumnWidth(2),
          //             },
          //             border: TableBorder.symmetric(
          //               inside: BorderSide(color: Colors.grey.shade300),
          //             ),
          //             children: dataExperience.map<TableRow>((experience) {
          //               return TableRow(
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.all(6.0),
          //                     child: Text(
          //                       '${DateFormat('dd-MMM-yyyy').format(experience.start_date!)} - ${DateFormat('dd-MMM-yyyy').format(experience.end_date!)}',
          //                       style: TextStyle(fontSize: 10),
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(6.0),
          //                     child: Text(experience.company_name ?? '',
          //                         style: TextStyle(fontSize: 10)),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(6.0),
          //                     child: Text(
          //                         experience.type?.name_english ?? '',
          //                         style: TextStyle(fontSize: 10)),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(6.0),
          //                     child: Text(experience.position ?? '',
          //                         style: TextStyle(fontSize: 10)),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(6.0),
          //                     child: Text(experience.location ?? '',
          //                         style: TextStyle(fontSize: 10)),
          //                   ),
          //                 ],
          //               );
          //             }).toList(),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
        ));
  }

  TableRow _buildTableHeader(BuildContext context) {
    return TableRow(
      decoration: BoxDecoration(color: Colors.orange),
      children: [
        Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              AppLocalizations.of(context)!.date,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            )),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(AppLocalizations.of(context)!.companyName,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10)),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(AppLocalizations.of(context)!.employmentType,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10)),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(AppLocalizations.of(context)!.jobPosition,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10)),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(AppLocalizations.of(context)!.location,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10)),
        ),
      ],
    );
  }
}
