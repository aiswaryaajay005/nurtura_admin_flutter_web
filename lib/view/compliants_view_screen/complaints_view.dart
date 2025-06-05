import 'package:admin_app/controller/complaints_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Ensure Supabase instance is imported

class AdminComplaintsPage extends StatefulWidget {
  const AdminComplaintsPage({Key? key}) : super(key: key);

  @override
  State<AdminComplaintsPage> createState() => _AdminComplaintsPageState();
}

class _AdminComplaintsPageState extends State<AdminComplaintsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ComplaintsPageController>().fetchComplaints();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ComplaintsPageController>();
    return provider.complaints.isEmpty
        ? Center(child: Text("No complaints yet!"))
        : Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: provider.complaints.length,
              itemBuilder: (context, index) {
                final complaint = provider.complaints[index];

                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Complaint: ${complaint['complaint']}",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text("Status: ${complaint['status']}",
                            style: TextStyle(color: Colors.red)),
                        SizedBox(height: 10),
                        complaint['response'] != null
                            ? Text("Admin Response: ${complaint['response']}",
                                style: TextStyle(color: Colors.green))
                            : Column(
                                children: [
                                  TextField(
                                    controller: provider.responseController,
                                    decoration: InputDecoration(
                                      labelText: "Reply",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  ElevatedButton(
                                    onPressed: () => context
                                        .read<ComplaintsPageController>()
                                        .respondToComplaint(
                                            complaint['id'], context),
                                    child: Text("Send Response"),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
}
