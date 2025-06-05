import 'package:admin_app/main.dart';
import 'package:flutter/widgets.dart';

class EventParticipantsController with ChangeNotifier {
  List<Map<String, dynamic>> participantList = [];
  String statusCheck(int? status) {
    if (status == null) {
      return "Unknown"; // or any default value
    }
    return status == 1 ? "Will participate" : "Will not participate";
  }

  Future<void> fetchParticipant() async {
    try {
      final response = await supabase
          .from("tbl_participate")
          .select("*, tbl_child(*), tbl_event(*)");

      if (response != null) {
        participantList = List<Map<String, dynamic>>.from(response);
        notifyListeners();
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
