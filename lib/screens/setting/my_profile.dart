import 'dart:ffi';
import 'package:app/screens/employees/employee_list.dart';
import 'package:flutter/material.dart';
import 'package:app/models/employee.dart';
import 'package:app/providers/employee_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyProfilePage extends ConsumerStatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends ConsumerState<MyProfilePage> {
  late int employeeId;
  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Get the JSON string from SharedPreferences
      final employeeJsonString = prefs.getString('employee');
      if (employeeJsonString != null) {
        // Decode the JSON string to a map
        final Map<String, dynamic> employee = jsonDecode(employeeJsonString);

        setState(() {
          employeeId = employee['id'];
        });
      }
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  void _launchPhone(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) return;
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      print('Could not launch $phoneUri');
    }
  }

  void _launchEmailWithFallback(BuildContext context, String email) async {
    final Uri mailtoUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Hello&body=Hi there!',
    );

    final Uri gmailWebUri = Uri.parse(
      'https://mail.google.com/mail/?view=cm&fs=1&to=$email&su=Hello&body=Hi%20there!',
    );

    if (await canLaunchUrl(mailtoUri)) {
      await launchUrl(mailtoUri);
    } else if (await canLaunchUrl(gmailWebUri)) {
      await launchUrl(gmailWebUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open email client or Gmail.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Employee?>(
      future: ref.read(employeeProvider.notifier).fetchEmployeeId(employeeId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading spinner while data is being fetched
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle errors
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.myProfile,
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
            body: SingleChildScrollView(
              child: Column(
                children: [
                  !snapshot.hasData
                      ? Center(
                          child: Text(
                              AppLocalizations.of(context)!.nodataToDisplay))
                      : _buildProfileHeader(context, snapshot.data!),
                  _buildWorkInformation(snapshot.data!),
                  _buildExpandableSection(
                      AppLocalizations.of(context)!.personalInformations,
                      snapshot.data!,
                      "",
                      0),
                  _buildExpandableSection(
                      AppLocalizations.of(context)!.experienceInformations,
                      null,
                      "/experience",
                      snapshot.data!.id),
                  _buildExpandableSection(
                      AppLocalizations.of(context)!.childrenInformations,
                      null,
                      "/children/infor",
                      employeeId),
                  _buildExpandableSection(
                      AppLocalizations.of(context)!.employmentEducation,
                      null,
                      "/education",
                      snapshot.data!.id),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context, singleEmployee) {
    String currentLanguage = Localizations.localeOf(context).languageCode;
    Employee data = singleEmployee;

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildProfilePicture(data.profile),
          SizedBox(height: 10),
          Text(
              "${currentLanguage == 'en' ? data.employeeNameEn : data.employeeNameKh}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text("${data.position!.name_english}",
              style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // children: [
            //   _buildIconButton(
            //     Icons.phone,
            //     "${data.personalPhoneNumber}",
            //     () => _launchPhone(data.personalPhoneNumber),
            //   ),
            //   const SizedBox(width: 20),
            //   _buildIconButton(
            //     Icons.email,
            //     AppLocalizations.of(context)!.email,
            //     () => _launchEmailWithFallback(context, data.email!),
            //   ),
            //   const SizedBox(width: 20),
            //   _buildIconButton(
            //     Icons.account_tree,
            //     "Org Chart",
            //     () {
            //       // Implement org chart navigation if needed
            //     },
            //   ),
            // ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture(Profile) {
    final profile = Profile;
    return CircleAvatar(
      radius: 50,
      // backgroundColor: Colors.brown,
      backgroundImage: (profile != null && profile!.isNotEmpty)
          ? NetworkImage(profile!)
          : const AssetImage('assets/icon/default-user-icon.png')
              as ImageProvider,
      // child: Text("J", style: TextStyle(fontSize: 40, color: Colors.white)),
    );
  }

  Widget _buildIconButton(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.blue),
          onPressed: onPressed,
        ),
        Text(label, style: TextStyle(color: Colors.blue)),
      ],
    );
  }

  String formatDate(String dateString) {
    try {
      DateTime parsedDate = DateTime.parse(dateString);
      return DateFormat('dd-MMM-yyyy').format(parsedDate);
    } catch (e) {
      return "N/A";
    }
  }

  Widget _buildWorkInformation(singleEmployee) {
    Employee data = singleEmployee;
    String statusLoan = data.isLoan == 0 ? "No" : "Yes";

    // Fixing color assignment logic
    Color statusColor = (data.isLoan == 1) ? Colors.red : Colors.green;

    final Map<String, String> statusMap = {
      "Probation": "Probation",
      "1": "FDC-1",
      "10": "FDC-2",
      "2": "UDC"
    };
    String statusEmployee = statusMap[data.empStatus] ?? "Unknown";
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.workInformation,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Divider(),
          _buildInfoRow(AppLocalizations.of(context)!.employeeType,
              AppLocalizations.of(context)!.fullTime, Colors.black),
          _buildInfoRow(AppLocalizations.of(context)!.employeeId,
              "${data.numberEmployee}", Colors.black),
          _buildInfoRow(AppLocalizations.of(context)!.dateOfJoining,
              "${formatDate(data.dateOfCommencement)}", Colors.black),
          _buildInfoRow(AppLocalizations.of(context)!.officeLocation,
              "${data.branch?.branch_name_en ?? 'N/A'}", Colors.black),
          _buildInfoRow(AppLocalizations.of(context)!.roleAccess,
              "${data.role?.role_name ?? 'N/A'}", Colors.black),
          _buildInfoRow(
              AppLocalizations.of(context)!.loan, statusLoan, statusColor),
          _buildInfoRow(AppLocalizations.of(context)!.status, statusEmployee,
              Colors.black),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          Text(value,
              style: TextStyle(color: color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildExpandableSection(
      String title, Employee? dataPersonal, String url, int? argument) {
    if (dataPersonal == null) {
      return Card(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        child: ListTile(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.pushNamed(
              context,
              '${url}',
              arguments: {'source': 'myprofile', 'id': employeeId},
            );
          },
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(8),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          _buildInfoRow(AppLocalizations.of(context)!.email,
              dataPersonal.email ?? "N/A", Colors.black),
          _buildInfoRow(AppLocalizations.of(context)!.dateOfBirth,
              formatDate(dataPersonal.dateOfBirth), Colors.black),
          _buildInfoRow(AppLocalizations.of(context)!.gender,
              dataPersonal.option?.name_english ?? "N/A", Colors.black),
          _buildInfoRow(AppLocalizations.of(context)!.marriedStatus,
              dataPersonal.MarriedStatus?.name_english ?? "N/A", Colors.black),
        ],
      ),
    );
  }
}
