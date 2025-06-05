import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ComplaintsPageController with ChangeNotifier {
  List<Map<String, dynamic>> complaints = [];
  TextEditingController responseController = TextEditingController();
  Future<void> fetchComplaints() async {
    try {
      final response = await supabase
          .from('tbl_complaints')
          .select('*')
          .order('created_at', ascending: false);
      complaints = List<Map<String, dynamic>>.from(response);
      notifyListeners();
    } catch (e) {
      print("Error fetching complaints: $e");
    }
  }

  Future<void> respondToComplaint(int complaintId, BuildContext context) async {
    try {
      await supabase.from('tbl_complaints').update({
        'response': responseController.text,
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
}
