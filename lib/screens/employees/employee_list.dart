import 'package:app/providers/employee_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeePage extends ConsumerStatefulWidget {
  const EmployeePage({Key? key}) : super(key: key);

  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends ConsumerState<EmployeePage> {
  // Controller for the search input
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchEmployees();
    });

    // Listen for changes in the search query
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  void fetchEmployees() async {
    try {
      await ref.read(employeeProvider.notifier).fetchEmployees();
      debugPrint("Employee fetched successfully.");
    } catch (error) {
      debugPrint("Error fetching employee: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataEmployees = ref.watch(employeeProvider);
    // Filter employees based on the search query
    final filteredEmployees = dataEmployees.where((employee) {
      return employee.employeeNameEn!.toLowerCase().contains(_searchQuery) ||
          employee.numberEmployee!.toLowerCase().contains(_searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employees',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search field to filter employees
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredEmployees.length,
                itemBuilder: (context, index) {
                  final employee = filteredEmployees[index];
                  final Map<String, String> statusMap = {
                    "Probation": "Probation",
                    "1": "FDC-1",
                    "10": "FDC-2",
                    "2": "UDC"
                  };
                  String statusEmployee =
                      statusMap[employee.empStatus] ?? "Unknown";
                  return ListTile(
                    key: ValueKey(employee.employeeNameEn),
                    leading: CircleAvatar(
                      backgroundImage: (employee.profile != null &&
                              employee.profile!.isNotEmpty)
                          ? NetworkImage(employee
                              .profile!) // Use network image if available
                          : const AssetImage(
                                  'assets/icon/default-user-icon.png')
                              as ImageProvider, // Use default asset image

                      // AssetImage('${employee.profile ?? ""}'),
                      radius: 30,
                    ),
                    title: Text('${employee.employeeNameEn}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(employee.position!.name_english),
                        Text("${employee.branch!.branch_name_en}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    // trailing: const Icon(Icons.arrow_forward_ios),
                    trailing: Text(
                      '${statusEmployee}',
                      style: const TextStyle(
                        // color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/employees/detail',
                          arguments: employee.id);
                    },
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
