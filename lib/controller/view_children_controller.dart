import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewChildrenController with ChangeNotifier {
  List<Map<String, dynamic>> childlist = [];
  Future<void> acceptStatus(int childId, BuildContext context) async {
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

  Future<void> rejectStatus(int childId, dynamic context) async {
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
      childlist = response;
      notifyListeners();
    } catch (e) {
      print("Error: $e");
    }
  }

  void showChildDetails(Map<String, dynamic> child, dynamic context) {
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
}
