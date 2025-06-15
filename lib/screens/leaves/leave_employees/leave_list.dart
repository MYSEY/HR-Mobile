import 'package:app/models/leave_request.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:app/widgets/leave_request_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/leave_request_provider.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:intl/intl.dart';

class LeaveRequestPage extends ConsumerStatefulWidget {
  const LeaveRequestPage({Key? key}) : super(key: key);
  @override
  _LeaveRequestPageState createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends ConsumerState<LeaveRequestPage>
    with SingleTickerProviderStateMixin {
  _LeaveRequestPageState();

  final PageController _pageController = PageController();
  Timer? _autoSlideTimer;
  int _currentPage = 0;

  // Initialize leaveCategories as an empty list at the class level
  List<Map<String, dynamic>> leaveCategories = [];
  @override
  void initState() {
    super.initState();
    fetchLeaveRequests();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // API : Fetch leave requests
  void fetchLeaveRequests() {
    ref.read(leaveProvider.notifier).fetchLeaveRequests().then((_) {
      print("Leave requests fetched successfully.");
    }).catchError((error) {
      print("Error fetching leave requests: $error");
    });
  }

  // Function to start auto-sliding
  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (leaveCategories.isNotEmpty) {
        if (_currentPage < (leaveCategories.length / 2).ceil() - 1) {
          _currentPage++;
        } else {
          _currentPage = 0; // Reset to the first page after the last page
        }
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300), // Smooth transition
          curve: Curves.easeInOut, // Custom curve for better animation
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final leaveState = ref.watch(leaveProvider);
    final leaveAllocation = leaveState.leaveAllocation;
    final leaveRequests = leaveState.leaveRequests;

    // Update the leaveCategories list based on the current leaveAllocation
    leaveCategories = [
      {
        "title": AppLocalizations.of(context)!.annualLeave,
        "count": leaveAllocation?.totalAnnualLeave ?? 0,
        "color": const Color.fromARGB(255, 160, 164, 165),
      },
      {
        "title": AppLocalizations.of(context)!.sickLeave,
        "count": leaveAllocation?.totalSickLeave ?? 0,
        "color": const Color.fromARGB(255, 160, 164, 165),
      },
      {
        "title": AppLocalizations.of(context)!.specialLeave,
        "count": leaveAllocation?.totalSpecialLeave ?? 0,
        "color": const Color.fromARGB(255, 160, 164, 165),
      },
      {
        "title": AppLocalizations.of(context)!.unpaidLeave,
        "count": leaveAllocation?.totalUnpaidLeave ?? 0,
        "color": const Color.fromARGB(255, 160, 164, 165),
      },
      {
        "title": AppLocalizations.of(context)!.longSickLeave,
        "count": 0,
        "color": const Color.fromARGB(255, 160, 164, 165),
      },
      {
        "title": AppLocalizations.of(context)!.year + " 1",
        "count": leaveAllocation?.year1 ?? 0,
        "color": const Color.fromARGB(255, 160, 164, 165),
      },
      {
        "title": AppLocalizations.of(context)!.year + " 2",
        "count": leaveAllocation?.year2 ?? 0,
        "color": const Color.fromARGB(255, 160, 164, 165),
      },
      {
        "title": AppLocalizations.of(context)!.year + " 3",
        "count": leaveAllocation?.year3 ?? 0,
        "color": const Color.fromARGB(255, 160, 164, 165),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.leaves,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF9F2E32),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Leave Category Buttons
            SizedBox(
              height: 120, // Adjust the height as needed
              child: PageView.builder(
                controller: _pageController,
                itemCount: (leaveCategories.length / 2).ceil(),
                itemBuilder: (context, index) {
                  final itemsToShow = leaveCategories.sublist(
                    index * 2,
                    (index * 2 + 2) > leaveCategories.length
                        ? leaveCategories.length
                        : index * 2 + 2,
                  );

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: itemsToShow.map((category) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: category['color'],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${category['count']}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  category['title'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),

            // Leave Request Info Header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.leaveRequestInfo,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),

            leaveRequests.isEmpty
                ? const Center(child: Text('No leave request available'))
                : Expanded(
                    child: ListView.builder(
                      itemCount: leaveRequests.length,
                      itemBuilder: (context, index) {
                        final leaveRequest = leaveRequests[index];
                        return LeaveRequestCard(
                          leaveRequest: leaveRequest,
                          id: leaveRequest.id.toString(),
                          applicationType: leaveRequest.numberOfDay ??
                              "Full Day Application",
                          startDate: leaveRequest.startDate,
                          endDate: leaveRequest.endDate,
                          leaveType: leaveRequest.leaveType?.name ?? '',
                          status: leaveRequest.status ?? '',
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/leaves/create');
        },
        child: const Icon(Icons.add),
        backgroundColor: Color(0xFF9F2E32),
      ),
    );
  }
}
