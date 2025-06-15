import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  final void Function(Locale) onLocaleChanged;

  const SettingsPage({super.key, required this.onLocaleChanged});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    // Clear all stored data
    await prefs.clear();
  }

  int? _languageId = 1; // 1 = English, 2 = Khmer

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    String currentLanguage = Localizations.localeOf(context).languageCode;
    setState(() {
      _languageId = currentLanguage == 'km' ? 2 : 1;
    });
  }

  void _onLanguageChange(int? value) {
    if (value == null) return;
    setState(() {
      _languageId = value;
    });

    if (value == 1) {
      widget.onLocaleChanged(const Locale('en'));
    } else if (value == 2) {
      widget.onLocaleChanged(const Locale('km'));
    }
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

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocalizations.of(context)!.selectLanguage + ':',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  RadioListTile<int>(
                    title: const Text('ភាសាខ្មែរ'),
                    value: 2,
                    groupValue: _languageId,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _languageId = value);
                        Navigator.pop(context);
                        _onLanguageChange(value); // call your original handler
                      }
                    },
                  ),
                  RadioListTile<int>(
                    title: const Text('English'),
                    value: 1,
                    groupValue: _languageId,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _languageId = value);
                        Navigator.pop(context);
                        _onLanguageChange(value); // call your original handler
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF9F2E32),
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
              AppLocalizations.of(context)!.account,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(AppLocalizations.of(context)!.changeProfile),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/edit/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text(AppLocalizations.of(context)!.changePassword),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/change/password');
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.person),
          //   title: Text("Personal Information "),
          //   onTap: () {
          //     Navigator.pushReplacementNamed(context, '/myprofile');
          //   },
          // ),
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
            value: true,
            onChanged: (bool value) {
              // Handle switch logic
            },
            secondary: Icon(Icons.email),
          ),
          Divider(),

          // // Privacy Section
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Text(
          //     "Privacy",
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       fontSize: 18,
          //     ),
          //   ),
          // ),
          // ListTile(
          //   leading: Icon(Icons.privacy_tip),
          //   title: Text("Privacy Policy"),
          //   onTap: () {
          //     // Navigate to privacy policy
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.shield),
          //   title: Text("Terms and Conditions"),
          //   onTap: () {
          //     // Navigate to terms and conditions
          //   },
          // ),
          // Divider(),

          ListTile(
            leading: const Icon(Icons.language),
            title: Text(AppLocalizations.of(context)!.languages),
            trailing: Text(_languageId == 1 ? 'English' : 'ខ្មែរ'),
            onTap: () => _showLanguageBottomSheet(context),
          ),
          // ListTile(
          //   leading: Icon(Icons.palette),
          //   title: Text("Theme"),
          //   subtitle: Text("Light"),
          //   onTap: () {
          //     // Navigate to theme settings
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.update),
          //   title: Text("Check for Updates"),
          //   onTap: () {
          //     // Handle check for updates
          //   },
          // ),
          // Divider(),

          // Logout Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9F2E32),
              ),
              onPressed: () => _logout(context),
              child: Text(
                AppLocalizations.of(context)!.logOut,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
