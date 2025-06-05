import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ManageStaffController with ChangeNotifier {
  List<Map<String, dynamic>> staffList = [];
  Future<void> acceptStaff(String staffId, BuildContext context) async {
    try {
      await supabase.from('tbl_staff').update({
        'staff_status': 1,
      }).eq('id', staffId);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Staff Accepted!")));
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> rejectStaff(String staffId, dynamic context) async {
    TextEditingController reasonController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reject Staff Application"),
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
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String reason = reasonController.text.trim();
                if (reason.isNotEmpty) {
                  try {
                    await supabase.from('tbl_staff').update({
                      'staff_status': 2,
                      'rejection_reason': reason
                    }).eq('id', staffId);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Rejected: $reason")),
                    );
                  } catch (e) {
                    print("Error: $e");
                  }
                  Navigator.of(context).pop();
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

  Future<void> fetchStaff() async {
    try {
      final response =
          await supabase.from("tbl_staff").select().eq('staff_status', 0);
      staffList = response;
      notifyListeners();
    } catch (e) {
      print("Error: $e");
    }
  }

  void showStaffDetails(Map<String, dynamic> staff, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Staff Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Name: ${staff['staff_name'] ?? ''}"),
              Text("Email: ${staff['staff_email'] ?? ''}"),
              Text("Contact: ${staff['staff_contact'] ?? ''}"),
              Text("Address: ${staff['staff_address'] ?? ''}"),
              SizedBox(height: 10),
              if (staff['staff_cv'] != null)
                ElevatedButton(
                  onPressed: () async {
                    final url = staff['staff_cv'];
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Cannot open CV")),
                      );
                    }
                  },
                  child: Text("View CV"),
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
