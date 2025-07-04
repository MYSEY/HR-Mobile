import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  final void Function(Locale locale, String fontFamily) onLocaleChanged;

  const SettingsPage({super.key, required this.onLocaleChanged});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int? _languageId = 1; // 1 = English, 2 = Khmer

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLangId = prefs.getInt('languageId') ?? 1;
    setState(() {
      _languageId = savedLangId;
    });
  }

  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void _onLanguageChange(int? value) async {
    if (value == null) return;
    setState(() {
      _languageId = value;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('languageId', value);

    if (value == 1) {
      widget.onLocaleChanged(const Locale('en'), '');
    } else if (value == 2) {
      widget.onLocaleChanged(const Locale('km'), 'Battambang');
    }
  }

  void _logout(BuildContext context) async {
    await _clearUserData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logout successful!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
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
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.selectLanguage + ':',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  RadioListTile<int>(
                    title: const Text('ភាសាខ្មែរ'),
                    value: 2,
                    groupValue: _languageId,
                    onChanged: (value) {
                      if (value != null) {
                        setModalState(() => _languageId = value);
                        Navigator.pop(context);
                        _onLanguageChange(value);
                      }
                    },
                  ),
                  RadioListTile<int>(
                    title: const Text('English'),
                    value: 1,
                    groupValue: _languageId,
                    onChanged: (value) {
                      if (value != null) {
                        setModalState(() => _languageId = value);
                        Navigator.pop(context);
                        _onLanguageChange(value);
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
    String currentLanguage = Localizations.localeOf(context).languageCode;
    currentLanguage == "en" ? _languageId = 1 : _languageId = 2;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF9F2E32),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              AppLocalizations.of(context)!.account,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(AppLocalizations.of(context)!.changeProfile),
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/edit/profile'),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: Text(AppLocalizations.of(context)!.changePassword),
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/change/password'),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              "Notifications",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          SwitchListTile(
            title: const Text("Push Notifications"),
            value: true,
            onChanged: (bool value) {},
            secondary: const Icon(Icons.notifications),
          ),
          SwitchListTile(
            title: const Text("Email Notifications"),
            value: true,
            onChanged: (bool value) {},
            secondary: const Icon(Icons.email),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(AppLocalizations.of(context)!.languages),
            trailing: Text(_languageId == 1 ? 'English' : 'ខ្មែរ'),
            onTap: () => _showLanguageBottomSheet(context),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9F2E32)),
              onPressed: () => _logout(context),
              child: Text(
                AppLocalizations.of(context)!.logOut,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
