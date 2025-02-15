import 'package:admin_app/main.dart';
import 'package:admin_app/screens/addschedule.dart';
import 'package:flutter/material.dart';

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
      final response = await supabase.from("tbl_staff").select();

      setState(() {
        stafflist = response;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return stafflist.isEmpty
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: DataTable(
              columns: [
                DataColumn(label: Text("S.No")),
                DataColumn(label: Text("Staff Name")),
                DataColumn(label: Text("Email")),
                DataColumn(label: Text("Contact")),
                DataColumn(label: Text("Action")),
              ],
              rows: stafflist.asMap().entries.map((entry) {
                int index = entry.key + 1; // Staff index
                Map<String, dynamic> staff = entry.value;
                return DataRow(cells: [
                  DataCell(Text(index.toString())), // Serial Number
                  DataCell(Text(staff['staff_name'] ?? 'No Name')),
                  DataCell(Text(staff['staff_email'] ?? 'No Email')),
                  DataCell(Text(staff['staff_contact'] ?? 'No Contact')),
                  DataCell(TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddSchedule(
                              id: staff['id'],
                            ),
                          ));
                    },
                    child: Text('Schedule'),
                  )),
                ]);
              }).toList(),
            ),
          );
  }
}
