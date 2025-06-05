import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';

class ViewEventController with ChangeNotifier {
  List<Map<String, dynamic>> eventlist = [];
  Future<void> fetchevent() async {
    try {
      final response = await supabase.from("tbl_event").select();
      eventlist = response;
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");
    }
  }
}
