import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';

class AcceptedChildrenController with ChangeNotifier {
  List<Map<String, dynamic>> childlist = [];
  Future<void> fetchChild() async {
    try {
      final response =
          await supabase.from("tbl_child").select().eq('child_status', 3);
      childlist = response;
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");
    }
  }
}
