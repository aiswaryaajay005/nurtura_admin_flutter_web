// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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
      await supabase.from('tbl_child').update({
        'child_status': 1,
      }).eq('id', childId);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Accepted!")));
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> rejectStatus(int childId) async {
    TextEditingController reasonController = TextEditingController();

    // Show a dialog to get rejection reason
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reject Admission"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Please enter a reason for rejection:"),
              SizedBox(height: 10),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter reason",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String reason = reasonController.text.trim();
                if (reason.isNotEmpty) {
                  try {
                    await supabase.from('tbl_child').update({
                      'child_status': 2,
                      'rejection_reason': reason
                    }).eq('id', childId);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Rejected: $reason")),
                    );
                  } catch (e) {
                    print("Error: $e");
                  }
                  Navigator.of(context).pop(); // Close dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a rejection reason.")),
                  );
                }
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchChild() async {
    try {
      final response =
          await supabase.from("tbl_child").select().eq('child_status', 0);

      setState(() {
        childlist = response;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void showChildDetails(Map<String, dynamic> child) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Child Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(child['child_photo'] ?? '', height: 150),
              SizedBox(height: 10),
              Text("Name: ${child['child_name'] ?? ''}"),
              Text("Gender: ${child['child_gender'] ?? ''}"),
              Text("DOB: ${child['child_dob'] ?? ''}"),
              Text("Allergy: ${child['child_allergy'] ?? ''}"),
              SizedBox(height: 10),
              if (child['child_docs'] != null)
                ElevatedButton(
                  onPressed: () async {
                    final url = child['child_docs'];
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Cannot open document")),
                      );
                    }
                  },
                  child: Text("View Document"),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return childlist.isEmpty
        ? Center(child: Text('No new admissions'))
        : SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "New Admissions",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                DataTable(
                  columns: [
                    DataColumn(label: Text("C.No")),
                    DataColumn(label: Text("Child Name")),
                    DataColumn(label: Text("Actions")),
                  ],
                  rows: childlist.map((child) {
                    int index = childlist.indexOf(child) + 1;
                    return DataRow(
                      cells: [
                        DataCell(Text(index.toString())),
                        DataCell(Text(child['child_name'] ?? '')),
                        DataCell(
                          Row(
                            children: [
                              // View Details Button
                              TextButton(
                                onPressed: () => showChildDetails(child),
                                child: Text("View Details"),
                              ),
                              SizedBox(width: 10),
                              // Accept Button
                              ElevatedButton(
                                onPressed: () {
                                  acceptStatus(child['id']);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: Text("Accept"),
                              ),
                              SizedBox(width: 10),
                              // Reject Button
                              ElevatedButton(
                                onPressed: () {
                                  rejectStatus(child['id']);
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
