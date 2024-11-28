import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    // Clear all stored data
    await prefs.clear();
  }

  void _logout(BuildContext context) async {
    await _clearUserData();
    // Show SnackBar with success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logout successful!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
    // Navigate to the login screen
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        // backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: ListView(
        children: [
          // Account Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Account",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Edit Profile"),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/edit/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Change Password"),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/change/password');
            },
          ),
          Divider(),

          // Notifications Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Notifications",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          SwitchListTile(
            title: Text("Push Notifications"),
            value: true,
            onChanged: (bool value) {
              // Handle switch logic
            },
            secondary: Icon(Icons.notifications),
          ),
          SwitchListTile(
            title: Text("Email Notifications"),
            value: false,
            onChanged: (bool value) {
              // Handle switch logic
            },
            secondary: Icon(Icons.email),
          ),
          Divider(),

          // Privacy Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Privacy",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text("Privacy Policy"),
            onTap: () {
              // Navigate to privacy policy
            },
          ),
          ListTile(
            leading: Icon(Icons.shield),
            title: Text("Terms and Conditions"),
            onTap: () {
              // Navigate to terms and conditions
            },
          ),
          Divider(),

          // App Settings Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "App Settings",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text("Language"),
            subtitle: Text("English"),
            onTap: () {
              // Navigate to language settings
            },
          ),
          ListTile(
            leading: Icon(Icons.palette),
            title: Text("Theme"),
            subtitle: Text("Light"),
            onTap: () {
              // Navigate to theme settings
            },
          ),
          ListTile(
            leading: Icon(Icons.update),
            title: Text("Check for Updates"),
            onTap: () {
              // Handle check for updates
            },
          ),
          Divider(),

          // Logout Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 233, 51, 51),
              ),
              onPressed: () => _logout(context),
              child: Text(
                "Log Out",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
