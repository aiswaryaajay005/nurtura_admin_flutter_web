import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';

class StaffAttendence extends StatefulWidget {
  const StaffAttendence({super.key});

  @override
  State<StaffAttendence> createState() => _StaffAttendenceState();
}

class _StaffAttendenceState extends State<StaffAttendence> {
  List<Map<String, dynamic>> stafflist = [];
  Set<String> markedStaff = {};

  @override
  void initState() {
    super.initState();
    fetchstaff();
  }

  Future<void> fetchstaff() async {
    try {
      final response = await supabase.from("tbl_staff").select();
      print("Fetched Staff: $response"); // Debugging

      if (mounted) {
        setState(() {
          stafflist = response.cast<Map<String, dynamic>>();
        });

        // Check which staff members have been marked already
        for (var staff in stafflist) {
          await checkAttendance(staff['id']);
        }
      }

      print("Updated Staff List Length: ${stafflist.length}"); // Debugging
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> checkAttendance(String staffId) async {
    try {
      final response = await supabase
          .from('tbl_staffattendence')
          .select()
          .eq('staff_id', staffId)
          .order('timestamp', ascending: false)
          .limit(1);

      if (response.isNotEmpty) {
        DateTime lastMarkedTime = DateTime.parse(response[0]['timestamp']);
        DateTime now = DateTime.now();
        Duration difference = now.difference(lastMarkedTime);

        if (difference.inHours < 18) {
          setState(() {
            markedStaff.add(staffId); // Mark as already recorded
          });
        }
      }
    } catch (e) {
      print("Error checking attendance: $e");
    }
  }

  Future<void> markAttendance(String staffId, int status) async {
    if (markedStaff.contains(staffId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Attendance already marked. Try after 18 hours.")),
      );
      return;
    }

    try {
      await supabase.from('tbl_staffattendence').insert({
        'staff_id': staffId,
        'attendence_status': status,
        'timestamp': DateTime.now().toIso8601String(),
      });

      setState(() {
        markedStaff.add(staffId); // Add to marked list
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Attendance marked successfully")),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return stafflist.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Staff Attendance",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 30,
                      headingRowHeight: 50,
                      border:
                          TableBorder.all(color: Colors.grey[300]!, width: 1),
                      headingTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.deepPurple[600],
                      ),
                      columns: [
                        DataColumn(label: Text("S.No")),
                        DataColumn(label: Text("Staff Name")),
                        DataColumn(label: Text("Last Marked")),
                        DataColumn(label: Text("Action")),
                      ],
                      rows: stafflist.asMap().entries.map((entry) {
                        int index = entry.key + 1;
                        Map<String, dynamic> staff = entry.value;
                        String staffId = staff['id'];
                        bool isMarked = markedStaff.contains(staffId);

                        return DataRow(cells: [
                          DataCell(Text(index.toString())),
                          DataCell(Text(
                            staff['staff_name'] ?? 'No Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                          DataCell(Text(
                            isMarked ? "Marked" : "Not Marked",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isMarked ? Colors.red : Colors.green,
                            ),
                          )),
                          DataCell(
                            Row(
                              children: isMarked
                                  ? [
                                      Icon(Icons.lock,
                                          color: Colors
                                              .grey), // Lock icon if already marked
                                    ]
                                  : [
                                      ElevatedButton(
                                        onPressed: () {
                                          markAttendance(staffId, 1);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green[50],
                                          foregroundColor: Colors.green,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: Text('Present'),
                                      ),
                                      SizedBox(width: 5),
                                      ElevatedButton(
                                        onPressed: () {
                                          markAttendance(staffId, 0);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red[50],
                                          foregroundColor: Colors.red,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: Text('Absent'),
                                      ),
                                    ],
                            ),
                          ),
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
