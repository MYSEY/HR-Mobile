import 'dart:ffi';
import 'dart:math';
import 'package:app/screens/employees/employee_list.dart';
import 'package:flutter/material.dart';
import 'package:app/providers/children_info_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChildrenInforPage extends ConsumerStatefulWidget {
  final int employeeId;

  ChildrenInforPage({Key? key, required this.employeeId}) : super(key: key);

  @override
  _ChildrenInforPageState createState() => _ChildrenInforPageState();
}

class _ChildrenInforPageState extends ConsumerState<ChildrenInforPage> {
  late int employeeId;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchChildrens();
    });
  }

  void fetchChildrens() async {
    try {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final employee_id = args?['id'] as int?;

      if (employee_id == null) {
        throw Exception("Employee ID is required to fetch children.");
      }
      await ref
          .read(childreenInforProvider.notifier)
          .fetchChildrenId(employee_id);
      debugPrint("Children information fetched successfully.");
    } catch (error) {
      debugPrint("Error fetching Children information: $error");
    }
  }

  int _calculateAge(String? birthDateString) {
    if (birthDateString == null) return 0;

    try {
      DateTime birthDate =
          DateTime.parse(birthDateString); // Must be in ISO format (yyyy-MM-dd)
      DateTime today = DateTime.now();

      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0; // If parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataChildren = ref.watch(childreenInforProvider);
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final source = args?['source'] as String? ?? '';
    final employeeId = args?['id'] as int?;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Children Informations",
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
          child: dataChildren.isEmpty
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
                        itemCount: dataChildren.length,
                        itemBuilder: (context, index) {
                          final children = dataChildren[index];
                          return ListTile(
                            key: ValueKey(children.name),
                            leading: CircleAvatar(
                              backgroundImage: const AssetImage(
                                  'assets/icon/default-user-icon.png'),
                              radius: 30,
                            ),
                            title: Text(
                              children.name ?? 'No Name',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(children.Gender?.name_english ??
                                    'No Gender'),
                                Text(
                                  "Date of Birth: ${DateFormat('dd-MMM-yyyy').format(children.date_of_birth!)}",
                                  // style: const TextStyle(
                                  //     fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                    "Age: ${_calculateAge(children.date_of_birth!.toIso8601String())}"),
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
