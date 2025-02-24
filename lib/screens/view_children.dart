// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';

class ViewChildren extends StatefulWidget {
  const ViewChildren({super.key});

  @override
  State<ViewChildren> createState() => _ViewChildrenState();
}

class _ViewChildrenState extends State<ViewChildren> {
  List<Map<String, dynamic>> childlist = [];
  @override
  void initState() {
    super.initState();
    fetchChild();
  }

  Future<void> acceptStatus(int childId) async {
    try {
      await supabase
          .from('tbl_child')
          .update({'child_status': 1}).eq('id', childId);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Accepted!")));
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> rejectStatus(int childId) async {
    try {
      await supabase
          .from('tbl_child')
          .update({'child_status': 2}).eq('id', childId);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Rejected!")));
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> fetchChild() async {
    try {
      final response = await supabase.from("tbl_child").select();

      setState(() {
        childlist = response;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return childlist.isEmpty
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "New Admissions",
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontFamily: 'Montserrat-Bold',
                        fontSize: 30),
                  ),
                ),
                SizedBox(height: 20),
                DataTable(
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
                      fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  columns: [
                    DataColumn(
                        label: Text(
                      "C.No",
                      style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                      ),
                    )),
                    DataColumn(
                        label: Text(
                      "Child Name",
                      style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                      ),
                    )),
                    DataColumn(
                        label: Text(
                      "Child Gender",
                      style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                      ),
                    )),
                    DataColumn(
                        label: Text(
                      "Child DOB",
                      style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                      ),
                    )),
                    DataColumn(
                        label: Text(
                      "Child Allergy Details",
                      style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                      ),
                    )),
                    DataColumn(
                        label: Text(
                      "Action",
                      style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                      ),
                    )),
                  ],
                  rows: childlist.asMap().entries.map((entry) {
                    int index = entry.key + 1; // Staff index
                    Map<String, dynamic> child = entry.value;
                    return DataRow(cells: [
                      DataCell(Text(index.toString())), // Serial Number
                      DataCell(Text(
                        child['child_name'] ?? '',
                        style: TextStyle(
                          fontFamily: 'Montserrat-Regular',
                        ),
                      )),
                      DataCell(Text(
                        child['child_gender'] ?? '',
                        style: TextStyle(
                          fontFamily: 'Montserrat-Regular',
                        ),
                      )),
                      DataCell(Text(
                        child['child_dob'] ?? '',
                        style: TextStyle(
                          fontFamily: 'Montserrat-Regular',
                        ),
                      )),
                      DataCell(Text(
                        child['child_allergy'] ?? '',
                        style: TextStyle(
                          fontFamily: 'Montserrat-Regular',
                        ),
                      )),
                      DataCell(Row(
                        children: [
                          TextButton(
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    Colors.deepPurple[50]),
                                foregroundColor: WidgetStatePropertyAll(
                                  Colors.deepPurple,
                                ),
                                padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                ),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                )),
                            onPressed: () {
                              int childId = child['id'];
                              acceptStatus(childId);
                            },
                            child: Text(
                              'Accept',
                              style: TextStyle(
                                fontFamily: 'Montserrat-Regular',
                              ),
                            ),
                          ),
                          TextButton(
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    Colors.deepPurple[50]),
                                foregroundColor: WidgetStatePropertyAll(
                                  Colors.deepPurple,
                                ),
                                padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                ),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                )),
                            onPressed: () {
                              int childId = child['id'];
                              rejectStatus(childId);
                            },
                            child: Text(
                              'Reject',
                              style: TextStyle(
                                fontFamily: 'Montserrat-Regular',
                              ),
                            ),
                          ),
                        ],
                      )),
                    ]);
                  }).toList(),
                ),
              ],
            ),
          );
  }
}
