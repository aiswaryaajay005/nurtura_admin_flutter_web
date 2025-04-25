import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/screens/addschedule.dart';

class ViewStaff extends StatefulWidget {
  const ViewStaff({super.key});

  @override
  State<ViewStaff> createState() => _ViewStaffState();
}

class _ViewStaffState extends State<ViewStaff> {
  List<Map<String, dynamic>> stafflist = [];

  @override
  void initState() {
    super.initState();
    fetchstaff();
  }

  Future<void> fetchstaff() async {
    try {
      final response =
          await supabase.from("tbl_staff").select().eq('staff_status', 3);

      print("Fetched Staff: $response"); // Debugging

      if (mounted) {
        setState(() {
          stafflist = response;
        });
      }

      print("Updated Staff List Length: ${stafflist.length}"); // Debugging
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return stafflist.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center Column content
              children: [
                Text(
                  "Staff Details",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  // Centers the table
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 30,
                      headingRowHeight: 50,
                      border: TableBorder(
                        top: BorderSide(color: Colors.grey[300]!, width: 1),
                        bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                        left: BorderSide(color: Colors.grey[300]!, width: 1),
                        right: BorderSide(color: Colors.grey[300]!, width: 1),
                        horizontalInside: BorderSide.none, // Removes row lines
                      ),
                      headingTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.deepPurple[600],
                      ),
                      columns: [
                        DataColumn(label: Text("S.No")),
                        DataColumn(label: Text("Staff Name")),
                        DataColumn(label: Text("Email")),
                        DataColumn(label: Text("Contact")),
                        DataColumn(label: Text("Action")),
                      ],
                      rows: stafflist.asMap().entries.map((entry) {
                        int index = entry.key + 1;
                        Map<String, dynamic> staff = entry.value;

                        return DataRow(cells: [
                          DataCell(Text(index.toString())),
                          DataCell(Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                staff['staff_name'] ?? 'No Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                staff['staff_email'] ?? 'No Email',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          )),
                          DataCell(Text(staff['staff_email'] ?? 'No Email')),
                          DataCell(
                              Text(staff['staff_contact'] ?? 'No Contact')),
                          DataCell(ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddSchedule(
                                      id: staff['id'],
                                    ),
                                  ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple[50],
                              foregroundColor: Colors.deepPurple,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text('Schedule'),
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
