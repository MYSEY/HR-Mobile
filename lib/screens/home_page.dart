import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? employeeNameEn;
  String? email;
  String? position;
  String? location;
  int _selectedIndex = 0;
  String? employeeJson;
  var menus = [];

  @override
  void initState() {
    super.initState();
    _getToken(); // Retrieve the token when the home page initializes
  }

  Future<void> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final roleString = prefs.getString('role');

      if (roleString != null) {
        final role = jsonDecode(roleString); // Convert JSON string to Map
        final permission = role['Permission'];

        if (permission is List) {
          // Clear previous menu items
          menus.clear();
          bool viewApprove = false;
          for (var perm in permission) {
            if (perm['name'] == "lang.leaves_admin" && perm['is_view'] == 1) {
              viewApprove = true;
            }
            if (role['role_type'] != "Employee" &&
                perm['name'] == "lang.all_employee" &&
                perm['is_view'] == 1) {
              menus.add({
                'icon': Icons.people,
                'label': 'All\nEmployee',
                'route': '/employees',
              });
            }
            if (perm['url'] == "payroll" && perm['is_view'] == 1) {
              menus.add({
                'icon': Icons.attach_money,
                'label': 'C&B',
                'route': '/salaries',
              });
            }
            if (perm['url'] == "holidays" && perm['is_view'] == 1) {
              menus.add({
                'icon': Icons.event,
                'label': 'Public\nHolidays',
                'route': '/public/holiday',
              });
            }
            if (perm['url'] == "leaves/admin" && perm['is_view'] == 1) {
              menus.add({
                'icon': Icons.check_circle_outline,
                'label': 'Leave\nAdmin',
                'route': '/leaves/admin',
                'arguments': viewApprove,
              });
            }
            if (perm['url'] == "leaves/employee" && perm['is_view'] == 1) {
              menus.add({
                'icon': Icons.add_circle,
                'label': 'Leave\nEmployee',
                'route': '/leaves/list',
                'arguments': viewApprove,
              });
            }
            if (perm['url'] == "leaves/replcement" && perm['is_view'] == 1) {
              menus.add({
                'icon': Icons.add_circle,
                'label': 'Leave\nOn Behalf',
                'route': '/leaves/onbehalf',
                'arguments': viewApprove,
              });
            }
            // if (perm['url'] == "motor-rentel/pay" && perm['is_view'] == 1) {
            //   menus.add({
            //     'icon': Icons.commute,
            //     'label': 'Motor & Tablet',
            //     'route': '/motor/list',
            //   });
            // }
            if (perm['url'] == "training/list" && perm['is_view'] == 1) {
              menus.add({
                'icon': Icons.book,
                'label': 'Training',
                'route': '/trainings',
              });
            }
            // if (perm['url'] == "admin-expense/list" && perm['is_view'] == 1) {
            //   menus.add({
            //     'icon': Icons.attach_money,
            //     'label': 'Expense\nAdmin',
            //     'route': '/expense/admin',
            //   });
            // }
          }
        }
      } else {
        print("Role not found in SharedPreferences.");
      }

      // Get the JSON string from SharedPreferences
      final employeeJsonString = prefs.getString('employee');
      if (employeeJsonString != null) {
        // Decode the JSON string to a map
        final Map<String, dynamic> employee = jsonDecode(employeeJsonString);

        if (mounted) {
          setState(() {
            employeeJson = employeeJsonString;
            employeeNameEn = employee['employee_name_en'] ?? "Unknown";
            email = employee['email'] ?? "";
            position = employee['Position']?["name_english"] ?? "No Position";
            location = employee['Branch']?["branch_name_en"] ?? "No Branch";
          });
        }
      }
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> employeeData =
        employeeJson != null ? jsonDecode(employeeJson!) : {};
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xFF9F2E32),
        elevation: 0,
        toolbarHeight: 100,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  AssetImage('assets/icon/logo.png'), // Update with your asset
              radius: 25,
            ),
            SizedBox(width: 12),
            Text(
              "ខេមា មីក្រូហិរញ្ញវត្ថុ លីមីតធីត\nCAMMA Microfinance Limited",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            Stack(
              children: [
                Icon(Icons.notifications_none, color: Colors.white, size: 28),
                Positioned(
                  right: 0,
                  top: 2,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Color(0xFF9F2E32),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "3",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card Widget
            if (employeeJson != null)
              CreditCardWidget(employeeData: employeeData),
            SizedBox(height: 20),

            // Grid Menu
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: menus.map((item) {
                  return GestureDetector(
                    onTap: () {
                      final route = item['route'] as String?;
                      final arguments = item['arguments'] as bool?;
                      if (route != null) {
                        if (route == "/leaves/list") {
                          Navigator.pushReplacementNamed(context, route,
                              arguments: arguments);
                        } else {
                          Navigator.pushReplacementNamed(context, route);
                        }
                      }
                    },
                    child: MenuItem(
                      icon: item['icon'] as IconData,
                      label: item['label'] as String,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, "/home");
              break;
            case 1:
              Navigator.pushReplacementNamed(context, "/myprofile");
              break;
            case 2:
              Navigator.pushReplacementNamed(context, "/setting");
              break;
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "My Profile"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}

class CreditCardWidget extends StatelessWidget {
  final Map<String, dynamic> employeeData;

  const CreditCardWidget({Key? key, required this.employeeData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extracting employee data
    final String employeeId =
        employeeData['number_employee']?.toString() ?? 'Unknown ID';
    final String employeeName =
        employeeData['employee_name_en'] ?? 'Unknown Name';
    final String email = employeeData['email'] ?? 'No Email';
    final String position =
        employeeData['Position']?['name_english'] ?? 'No Position';

    return SizedBox(
      width: double.infinity, // Makes it take full width of the screen
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 159, 91, 3), Color(0xFFFFBB60)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Employee ID
            Text(
              "ID: $employeeId",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Employee Name
            Text(
              employeeName,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),

            // Employee Email
            Text(
              email,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            SizedBox(height: 8),

            // Employee Position
            Text(
              position,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// Grid Menu Item
class MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;

  MenuItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.greenAccent, size: 40),
          SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
