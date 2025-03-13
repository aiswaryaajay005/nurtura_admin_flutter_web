import 'package:flutter/material.dart';
import 'package:admin_app/main.dart'; // Ensure Supabase instance is imported

class AdminComplaintsPage extends StatefulWidget {
  const AdminComplaintsPage({Key? key}) : super(key: key);

  @override
  State<AdminComplaintsPage> createState() => _AdminComplaintsPageState();
}

class _AdminComplaintsPageState extends State<AdminComplaintsPage> {
  List<Map<String, dynamic>> _complaints = [];

  @override
  void initState() {
    super.initState();
    fetchComplaints();
  }

  Future<void> fetchComplaints() async {
    try {
      final response = await supabase
          .from('tbl_complaints')
          .select('*')
          .order('created_at', ascending: false);
      setState(() {
        _complaints = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching complaints: $e");
    }
  }

  Future<void> respondToComplaint(String complaintId, String response) async {
    try {
      await supabase.from('tbl_complaints').update({
        'response': response,
        'status': 'Resolved',
      }).eq('id', complaintId);

      fetchComplaints(); // Refresh list
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Response Sent!")),
      );
    } catch (e) {
      print("Error responding: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _complaints.isEmpty
        ? Center(child: Text("No complaints yet!"))
        : ListView.builder(
            shrinkWrap: true,
            itemCount: _complaints.length,
            itemBuilder: (context, index) {
              final complaint = _complaints[index];
              TextEditingController _responseController =
                  TextEditingController();

              return SizedBox(
                height: 400,
                width: 400,
                child: Card(
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
                                    controller: _responseController,
                                    decoration: InputDecoration(
                                      labelText: "Reply",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  ElevatedButton(
                                    onPressed: () => respondToComplaint(
                                        complaint['id'],
                                        _responseController.text),
                                    child: Text("Send Response"),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
