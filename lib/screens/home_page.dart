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
  // Changed to StatefulWidget
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// class HomePage extends StatelessWidget {
  String? employeeNameEn;
  String? email;
  String? position;
  String? location;
  @override
  void initState() {
    super.initState();
    _getToken(); // Retrieve the token when the home page initializes
  }

  Future<void> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    // Get the JSON string from SharedPreferences
    String? employeeJson = prefs.getString('employee');
    if (employeeJson != null) {
      // Decode the JSON string to a map
      Map<String, dynamic> employee = jsonDecode(employeeJson);
      print("employee $employee");
      // Set the employee_name_en value to be displayed
      setState(() {
        employeeNameEn = employee['employee_name_en'];
        email = employee['email'] ?? "";
        position = employee['Position']?["name_english"] ?? "";
        location = employee['Branch']?["branch_name_en"] ?? "";
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        // backgroundColor: Colors.blue,
        backgroundColor: Colors.red,
        actions: [
          IconButton(
              icon: Icon(Icons.notifications, color: Colors.white),
              onPressed: () {}),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/setting');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Profile Header Section
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.red,
            // color: Colors.blue,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      "https://example.com/user_image.jpg"), // Replace with actual image URL
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employeeNameEn!,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.email, size: 16, color: Colors.white70),
                        SizedBox(width: 8),
                        Text(
                          email!,
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.person, size: 16, color: Colors.white70),
                        SizedBox(width: 8),
                        Text(
                          "position: $position",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 16, color: Colors.white70),
                        SizedBox(width: 8),
                        Text(
                          "Location: $location",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Menu Options Section
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                // _buildMenuCard(Icons.settings, "Settings", context),
                _buildMenuCard(Icons.attach_money, "Salary", context),
                _buildMenuCard(Icons.event, "Public Holidays", context),
                _buildMenuCard(
                    Icons.calendar_view_day, "Leave Request", context),
                _buildMenuCard(Icons.book, "Training", context),
                _buildMenuCard(Icons.commute, "Motor & Tablet", context),
              ],
            ),
          ),

          // Footer Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.black12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeInfo("In Time", "8:00 AM"),
                _buildTimeInfo("Out Time", "5:00 PM"),
                _buildTimeInfo("Break Time", "1 hr"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(IconData icon, String title, BuildContext context) {
    return InkWell(
      onTap: () {
        if (title == "Leave Request") {
          Navigator.pushReplacementNamed(context, '/leaves/list');
        }
        if (title == "Settings") {
          Navigator.pushReplacementNamed(context, '/setting');
        }
        if (title == "Training") {
          Navigator.pushReplacementNamed(context, '/trainings');
        }
        if (title == "Salary") {
          Navigator.pushReplacementNamed(context, '/salaries');
        }
        if (title == "Public Holidays") {
          Navigator.pushReplacementNamed(context, '/public/holiday');
        }
        if (title == "Motor & Tablet") {
          Navigator.pushReplacementNamed(context, '/motor/list');
        }
      },
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(icon, size: 48, color: Colors.blue),
            Icon(icon, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text(title, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  // Function to build time information in footer
  Widget _buildTimeInfo(String label, String time) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(time),
      ],
    );
  }
}
