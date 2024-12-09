import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practical_6/Data/Models/LeaveData.dart';
import 'package:flutter_practical_6/UI/ApplyLeaveRequest.dart';

Color appColor = const Color(0xff564ff7);

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<LeaveData> leaveRequests = [];

  void _applyLeave(BuildContext context) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LeaveRequestScreen()))
        .then((value) {
      setState(() {
        leaveRequests.add(value as LeaveData);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          backgroundView(),
          SafeArea(
            child: Column(
              children: [
                _userProfileBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      const SizedBox(width: double.maxFinite, height: 15),
                      _leaveRequestSection(),
                      const SizedBox(width: double.maxFinite, height: 15),
                      Expanded(child: _historyHolidayAndSalaryGrid()),
                      const SizedBox(height: 20),
                      const Text('Upcoming Events',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildEventCard(
                                name: 'Amit Prajapati',
                                message:
                                    'Sending a birthday wish wrapped with lots of happiness. Enjoy your day!',
                                date: '11 Oct 95',
                              ),
                              _buildEventCard(
                                name: '', // Empty name for the second card
                                message:
                                    'Celebrate Gandhi Jayanti with love and happiness',
                                date: '11 Oct 19',
                                icon: Icons.cake,
                              ),
                              // Add more event cards here as needed
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _applyLeave(context);
        },
        tooltip: 'Apply leave',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget backgroundView() {
    return Column(
      children: [
        ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(15)),
          child: Container(
            height: 200,
            decoration: BoxDecoration(color: appColor),
          ),
        ),
      ],
    );
  }

  Widget _userProfileBar() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Icon(Icons.person, color: Colors.white, size: 50),
        ),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('HR', style: TextStyle(color: Colors.white)),
              Text('Siri', style: TextStyle(color: Colors.white))
            ],
          ),
        ),
        IconButton(
            onPressed: () {
              if (kDebugMode) {
                print('menu button pressed');
              }
            },
            icon: const Icon(Icons.table_rows_rounded,
                color: Colors.white, size: 24.0)),
      ],
    );
  }

  Widget _leaveRequestSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _leaveRequestButton(
            Icons.work_off_rounded, 'Leave Request', leaveRequests.length),
        _leaveRequestButton(
            Icons.work_history_rounded, 'Early Leave Request', null)
      ],
    );
  }

  Widget _leaveRequestButton(IconData icon, String title, int? requests) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(icon, color: appColor),
            const SizedBox(
              width: 10,
            ),
            Text(title, style: const TextStyle(color: Colors.black)),
            const SizedBox(width: 10),
            Text(requests != null ? "$requests" : "",
                style: TextStyle(
                    color: appColor, fontSize: 20, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }

  Widget _historyHolidayAndSalaryGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) =>
          Center(child: gridCellView(HomeActionCellType.values[index])),
      itemCount: HomeActionCellType.values.length,
    );
  }

  Widget gridCellView(HomeActionCellType type) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
          // This already centers horizontally
          child: Padding(
            // Add padding for better visual alignment
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // Center vertically
              crossAxisAlignment: CrossAxisAlignment.center,
              // Center horizontally
              children: [
                Icon(type.getIcon(type), color: appColor, size: 50),
                Text(type.name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18)),
                Text(getCount(type) != null ? '${getCount(type)}' : '',
                    style: const TextStyle(color: Colors.black, fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double? getCount(HomeActionCellType type) {
    switch (type) {
      case HomeActionCellType.applyLeave:
        return leaveRequests
            .where((i) => i.leaveStatus == LeaveStatus.pending)
            .length
            .toDouble();
      case HomeActionCellType.leaveHistory:
        return leaveRequests
            .where((i) => i.leaveStatus == LeaveStatus.approved)
            .length
            .toDouble();
      case HomeActionCellType.holiday:
        return null;
      case HomeActionCellType.salarySlip:
        return null;
    }
  }
}

Widget _buildEventCard({
  required String name,
  required String message,
  required String date,
  IconData? icon,
}) {
  return Card(
    color: Colors.white,
    child: SizedBox(
      width: 350,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (name.isNotEmpty)
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(
                        'assets/user_avatar.png'), // Replace with your image path
                  ),
                  const SizedBox(width: 10),
                  Text(name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            const SizedBox(height: 10),
            Text(message),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(date),
                if (icon != null) Icon(icon),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

enum HomeActionCellType {
  applyLeave,
  leaveHistory,
  holiday,
  salarySlip;

  IconData getIcon(HomeActionCellType type) {
    switch (type) {
      case HomeActionCellType.applyLeave:
        return Icons.work_off_rounded;
      case HomeActionCellType.leaveHistory:
        return Icons.work_history_rounded;
      case HomeActionCellType.holiday:
        return Icons.calendar_month_rounded;
      case HomeActionCellType.salarySlip:
        return Icons.attach_money_rounded;
    }
  }
}
