import 'package:admin_app/main.dart';
import 'package:flutter/widgets.dart';

class StaffLeaveController with ChangeNotifier {
  List<Map<String, dynamic>> leaveList = [];
  Future<void> fetchStaffLeave() async {
    try {
      final response = await supabase
          .from("tbl_staffleave")
          .select("*, staff:staff_id (staff_name)");
      leaveList = response;
      notifyListeners();
    } catch (e) {
      print("Error: $e");
    }
  }
}
