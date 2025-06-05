import 'package:admin_app/main.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AdminAttendenceCalenderController with ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> attendanceRecords = [];
  List<Map<String, dynamic>> childrenResponse = [];
  Future<void> fetchAttendanceRecords(DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    try {
      final children = await supabase.from('tbl_child').select();
      final response = await supabase
          .from('tbl_childattendence')
          .select('child_id, attendence_status, checkin_time, checkout_time')
          .eq('attendence_date', formattedDate);
      attendanceRecords = response;
      notifyListeners();
    } catch (e) {
      print("Error fetching attendance: $e");
    }
    notifyListeners();
  }
}
