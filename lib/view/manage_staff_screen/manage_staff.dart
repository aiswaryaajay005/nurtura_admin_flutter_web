import 'package:admin_app/controller/manage_staff_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageStaff extends StatefulWidget {
  const ManageStaff({super.key});

  @override
  State<ManageStaff> createState() => _ManageStaffState();
}

class _ManageStaffState extends State<ManageStaff> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<ManageStaffController>().fetchStaff();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ManageStaffController>();
    return provider.staffList.isEmpty
        ? Center(child: Text('No new staff applications'))
        : SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "New Staff Applications",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                DataTable(
                  columns: [
                    DataColumn(label: Text("S.No")),
                    DataColumn(label: Text("Staff Name")),
                    DataColumn(label: Text("Actions")),
                  ],
                  rows: provider.staffList.map((staff) {
                    int index = provider.staffList.indexOf(staff) + 1;
                    return DataRow(
                      cells: [
                        DataCell(Text(index.toString())),
                        DataCell(Text(staff['staff_name'] ?? '')),
                        DataCell(
                          Row(
                            children: [
                              TextButton(
                                onPressed: () => context
                                    .read<ManageStaffController>()
                                    .showStaffDetails(staff, context),
                                child: Text("View Details"),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<ManageStaffController>()
                                      .acceptStaff(staff['id'], context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: Text("Accept"),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<ManageStaffController>()
                                      .rejectStaff(staff['id'], context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: Text("Reject"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          );
  }
}
