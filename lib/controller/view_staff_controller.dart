import 'package:flutter/foundation.dart';
import 'package:admin_app/main.dart';

class ViewStaffController with ChangeNotifier {
  List<Map<String, dynamic>> stafflist = [];

  Future<void> fetchStaff() async {
    try {
      final response = await supabase
          .from("tbl_staff")
          .select()
          .eq('staff_status', 3) as List<dynamic>;

      print("Fetched Staff: $response");
      stafflist = response.cast<Map<String, dynamic>>();

      print("Updated Staff List Length: ${stafflist.length}");
      notifyListeners();
    } catch (e) {
      print("Error fetching staff: $e");
    }
  }
}
