import 'package:admin_app/controller/staff_leave_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewStaffLeave extends StatefulWidget {
  const ViewStaffLeave({super.key});

  @override
  State<ViewStaffLeave> createState() => _ViewStaffLeaveState();
}

class _ViewStaffLeaveState extends State<ViewStaffLeave> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<StaffLeaveController>().fetchStaffLeave();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StaffLeaveController>();
    return provider.leaveList.isEmpty
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Staff Leave Details",
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontFamily: 'Montserrat-Bold',
                        fontSize: 30),
                  ),
                ),
                SizedBox(height: 20),
                DataTable(
                  columnSpacing: 20,
                  headingRowHeight: 50,
                  border: TableBorder(
                    top: BorderSide(color: Colors.grey[300]!, width: 1),
                    bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                    left: BorderSide(color: Colors.grey[300]!, width: 1),
                    right: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                  headingTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.deepPurple,
                  ),
                  columns: [
                    DataColumn(label: Text("S.No")),
                    DataColumn(label: Text("Staff Name")),
                    DataColumn(label: Text("Leave Date")),
                    DataColumn(label: Text("Leave Type")),
                    DataColumn(label: Text("Reason")),
                    DataColumn(label: Text("Status")),
                  ],
                  rows: provider.leaveList.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    Map<String, dynamic> leave = entry.value;

                    DateTime leaveDate = DateTime.parse(leave['leave_fordate']);
                    DateTime today = DateTime.now();

                    String leaveStatus;
                    Color statusColor;

                    if (leaveDate.isAtSameMomentAs(today) ||
                        (leaveDate.year == today.year &&
                            leaveDate.month == today.month &&
                            leaveDate.day == today.day)) {
                      leaveStatus = "On Leave Today";
                      statusColor = Colors.orange;
                    } else if (leaveDate.isAfter(today)) {
                      leaveStatus = "Upcoming";
                      statusColor = Colors.blue;
                    } else {
                      leaveStatus = "Completed";
                      statusColor = Colors.grey;
                    }

                    return DataRow(cells: [
                      DataCell(Text(index.toString())),
                      DataCell(Text(leave['staff']['staff_name'] ?? 'No Name')),
                      DataCell(Text(leave['leave_fordate'] ?? 'No Date')),
                      DataCell(Text(leave['leave_type'] ?? 'N/A')),
                      DataCell(Text(leave['leave_reason'] ?? 'No Reason')),
                      DataCell(
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            leaveStatus,
                            style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ],
            ),
          );
  }
}
