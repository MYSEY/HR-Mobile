import 'package:app/providers/auth_provider.dart';
import 'package:app/widgets/leave_request_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/leave_request_provider.dart';
import 'dart:async';

class LeaveRequestPage extends ConsumerStatefulWidget {
  @override
  _LeaveRequestPageState createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends ConsumerState<LeaveRequestPage> {
  final PageController _pageController = PageController();
  Timer? _autoSlideTimer;
  int _currentPage = 0;

  // Initialize leaveCategories as an empty list at the class level
  List<Map<String, dynamic>> leaveCategories = [];

  @override
  void initState() {
    super.initState();
    // Fetch leave requests and allocations on init
    ref.read(leaveProvider.notifier).fetchLeaveRequests();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel(); // Stop the timer when disposing the widget
    _pageController.dispose();
    super.dispose();
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
    // Update the leaveCategories list based on the current leaveAllocation
    leaveCategories = [
      {
        "title": "Annual Leave",
        "count": leaveAllocation?.totalAnnualLeave ?? 0,
        "color": const Color.fromARGB(255, 160, 164, 165),
      },
      {
        "title": "Sick Leave",
        "count": leaveAllocation?.totalSickLeave ?? 0,
        "color": const Color.fromARGB(255, 160, 164, 165),
      },
      {
        "title": "Special Leave",
        "count": leaveAllocation?.totalSpecialLeave ?? 0,
        "color": const Color.fromARGB(255, 160, 164, 165),
      },
      {
        "title": "Unpaid Leave",
        "count": leaveAllocation?.totalUnpaidLeave ?? 0,
        "color": const Color.fromARGB(255, 160, 164, 165),
      },
      {
        "title": "Long Sick Leave",
        "count": 0,
        "color": const Color.fromARGB(255, 160, 164, 165),
      },
      {
        "title": "Year 1",
        "count": leaveAllocation?.year1 ?? 0,
        "color": const Color.fromARGB(255, 160, 164, 165),
      },
      {
        "title": "Year 2",
        "count": leaveAllocation?.year2 ?? 0,
        "color": const Color.fromARGB(255, 160, 164, 165),
      },
      {
        "title": "Year 3",
        "count": leaveAllocation?.year3 ?? 0,
        "color": const Color.fromARGB(255, 160, 164, 165),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leave Request',
          style: TextStyle(color: Colors.white),
        ),
        // backgroundColor: Colors.blue,
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.download),
        //     onPressed: () {
        //       // ref.read(authProvider).downloadEmployeesCsv(context);
        //     },
        //   ),
        // ],
      ),
      body: Column(
        children: [
          // Leave Category Buttons
          SizedBox(
            height: 120, // Adjust the height as needed
            child: PageView.builder(
              controller: _pageController,
              itemCount: (leaveCategories.length / 2).ceil(), // Number of pages
              itemBuilder: (context, index) {
                // Display two items per page
                final itemsToShow = leaveCategories.sublist(
                    index * 2,
                    (index * 2 + 2) > leaveCategories.length
                        ? leaveCategories.length
                        : index * 2 + 2);

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
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                category['title'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
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
                  "Leave Request Info",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                // DropdownButton<String>(
                //   value: "This Year",
                //   items: <String>['This Year', 'Last Year'].map((String value) {
                //     return DropdownMenuItem<String>(
                //       value: value,
                //       child: Text(value),
                //     );
                //   }).toList(),
                //   onChanged: (_) {},
                // )
              ],
            ),
          ),
          leaveState.leaveRequests.isEmpty
              ? Center(child: Text('No leave request available'))
              : Expanded(
                  child: ListView.builder(
                    itemCount: leaveState.leaveRequests.length,
                    itemBuilder: (context, index) {
                      final leaveRequest = leaveState.leaveRequests[index];
                      return LeaveRequestCard(
                        id: leaveRequest.id.toString(),
                        applicationType:
                            leaveRequest.numberOfDay ?? "Full Day Application",
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/leaves/create');
        },
        child: Icon(Icons.add),
        // backgroundColor: Colors.blue,
        backgroundColor: Colors.red,
      ),
    );
  }
}
