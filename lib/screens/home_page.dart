import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  var menus = [
    {'icon': Icons.settings, 'label': 'Settings', 'route': '/setting'},
    {'icon': Icons.attach_money, 'label': 'Salary', 'route': '/salaries'},
    {
      'icon': Icons.event,
      'label': 'Public Holidays',
      'route': '/public/holiday'
    },
  ];

  @override
  void initState() {
    super.initState();
    _getToken(); // Retrieve the token when the home page initializes
  }

  Future<void> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final roleString = prefs.getString('role');

    if (roleString != null) {
      final role = jsonDecode(roleString); // Convert the JSON string to a Map
      final permission = role['Permission'];

      if (permission != null) {
        // Loop through permissions and add to menus
        bool viewApprove = false;
        for (var perm in permission) {
          if (perm['name'] == "lang.leaves_admin" && perm['is_view'] == 1) {
            viewApprove = true;
          }
          if (perm['name'] == "lang.leaves_employee" && perm['is_view'] == 1) {
            menus.add({
              'icon': Icons.exit_to_app,
              'label': 'Leaves',
              'route': '/leaves/list',
              'arguments': viewApprove,
            });
          }
          if (perm['name'] == "lang.motor_rental" && perm['is_view'] == 1) {
            menus.add({
              'icon': Icons.commute,
              'label': 'Motor & Tablet',
              'route': '/motor/list',
            });
          }
          if (perm['name'] == "lang.training" && perm['is_view'] == 1) {
            menus.add({
              'icon': Icons.book,
              'label': 'Training',
              'route': '/trainings',
            });
          }
        }
      }
    } else {
      print("Role not found in SharedPreferences.");
    }
    // Get the JSON string from SharedPreferences
    String? employeeJson = prefs.getString('employee');
    if (employeeJson != null) {
      // Decode the JSON string to a map
      Map<String, dynamic> employee = jsonDecode(employeeJson);
      // Set the employee details to be displayed
      setState(() {
        employeeNameEn = employee['employee_name_en'];
        email = employee['email'] ?? "";
        position = employee['Position']?["name_english"] ?? "";
        location = employee['Branch']?["branch_name_en"] ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF006D77), // Background color
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        // Profile image (optional, can be updated later)
                        backgroundImage: AssetImage('assets/icon/logo.png'),
                        radius: 30,
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello, ${employeeNameEn ?? 'User'}!", // Default value if null
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.chat_bubble_outline, color: Colors.white),
                      SizedBox(width: 16),
                      Icon(Icons.notifications_none, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),

            // Account Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(71, 24, 23, 23),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email: ${email ?? 'N/A'}", // Default value if null
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        Text(
                          "Position: ${position ?? 'N/A'}", // Default value if null
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        Text(
                          "Location: ${location ?? 'N/A'}", // Default value if null
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                      //   ),
                      // ],
                    ),
                  ],
                ),
              ),
            ),

            // Grid Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 3, // Number of columns
                  mainAxisSpacing: 16, // Spacing between rows
                  crossAxisSpacing: 16, // Spacing between columns
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
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.teal[300],
                            child: Icon(
                              item['icon'] as IconData,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            item['label'] as String,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
