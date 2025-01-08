import 'package:flutter/material.dart';

class LeaveApprovalPage extends StatefulWidget {
  @override
  _LeaveApprovalPageState createState() => _LeaveApprovalPageState();
}

class _LeaveApprovalPageState extends State<LeaveApprovalPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Map<String, dynamic>> leaves = [
    {
      'employeeName': 'Bhagya Thalath',
      'leaveType': 'Sick Leave',
      'fromDate': '20 Nov 2020',
      'toDate': '20 Nov 2020',
      'days': 1.0,
      'status': 'Pending',
    },
  ];

  final List<Map<String, dynamic>> myLeaves = [
    {
      'employeeName': 'My Request',
      'leaveType': 'Casual Leave',
      'fromDate': '10 Dec 2024',
      'toDate': '12 Dec 2024',
      'days': 3.0,
      'status': 'Approved',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leaves',
          style: TextStyle(color: Colors.white),
        ),
        // backgroundColor: Colors.blue,
        backgroundColor: Color(0xFF006D77),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white, // Active tab text color
          unselectedLabelColor: Colors.grey[300], // Inactive tab text color
          indicatorColor: Colors.white, // Underline color for active tab
          tabs: [
            Tab(text: 'MY LEAVES'),
            Tab(text: 'LEAVES'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Content changes based on selected tab
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Content for "MY LEAVES" tab
                ListView.builder(
                  itemCount: myLeaves.length,
                  itemBuilder: (context, index) {
                    return buildLeaveCard(myLeaves[index]);
                  },
                ),
                // Content for "LEAVES" tab
                ListView.builder(
                  itemCount: leaves.length,
                  itemBuilder: (context, index) {
                    return buildLeaveCard(leaves[index]);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLeaveCard(Map<String, dynamic> leave) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Applied for leave',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Employee: ${leave['employeeName']}'),
                Text('Type: ${leave['leaveType']}'),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('From: ${leave['fromDate']}'),
                Text('To: ${leave['toDate']}'),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('No. of Days: ${leave['days']}'),
                CircleAvatar(
                  backgroundColor: Colors.orange,
                  radius: 12,
                  child: Text(
                    '${leave['days']}',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
