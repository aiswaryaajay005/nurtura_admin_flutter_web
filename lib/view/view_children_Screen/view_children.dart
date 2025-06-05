// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:admin_app/controller/view_children_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewChildren extends StatefulWidget {
  const ViewChildren({super.key});

  @override
  State<ViewChildren> createState() => _ViewChildrenState();
}

class _ViewChildrenState extends State<ViewChildren> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<ViewChildrenController>().fetchChild();
      },
    );
    super.initState();
    // fetchChild();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ViewChildrenController>();
    return provider.childlist.isEmpty
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
                  rows: provider.childlist.map((child) {
                    int index = provider.childlist.indexOf(child) + 1;
                    return DataRow(
                      cells: [
                        DataCell(Text(index.toString())),
                        DataCell(Text(child['child_name'] ?? '')),
                        DataCell(
                          Row(
                            children: [
                              // View Details Button
                              TextButton(
                                onPressed: () => context
                                    .read<ViewChildrenController>()
                                    .showChildDetails(child, context),
                                child: Text("View Details"),
                              ),
                              SizedBox(width: 10),
                              // Accept Button
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<ViewChildrenController>()
                                      .acceptStatus(child['id'], context);
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
                                  context
                                      .read<ViewChildrenController>()
                                      .rejectStatus(child['id'], context);
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
