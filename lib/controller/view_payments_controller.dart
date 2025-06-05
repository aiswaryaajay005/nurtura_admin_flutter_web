import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';

class ViewPaymentsController with ChangeNotifier {
  List<Map<String, dynamic>> payments = [];
  Future<void> fetchPaymentDetails() async {
    try {
      final response =
          await supabase.from('tbl_payment').select('*, tbl_child(*)');
      payments = response;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
