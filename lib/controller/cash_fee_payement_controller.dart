import 'dart:developer';

import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CashFeePayementController with ChangeNotifier {
  List<Map<String, dynamic>> children = [];
  bool isLoading = true;

  Future<void> fetchChildren() async {
    try {
      final response = await supabase.from('tbl_child').select();

      log("Fetched children: $response");

      if (response.isEmpty) {
        log("No children found in database.");
      }
      children = response;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      log("Error fetching children: $e");
      isLoading = false;
      notifyListeners();
    }
  }

  Future<int> getPendingFees(int childId) async {
    try {
      log("Fetching fees for child ID: $childId");

      DateTime now = DateTime.now();
      DateTime lastPaidDate;

      final latestPaymentResponse = await supabase
          .from('tbl_payment')
          .select('created_at')
          .eq('child_id', childId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (latestPaymentResponse == null) {
        final childResponse = await supabase
            .from('tbl_child')
            .select('child_doj, child_dob')
            .eq('id', childId)
            .single();

        if (childResponse['child_doj'] == null) {
          log(" Warning: `child_doj` is NULL for child ID $childId.");
          return 0; // No fee calculation possible
        }

        lastPaidDate = DateTime.parse(childResponse['child_doj']);
      } else {
        lastPaidDate = DateTime.parse(latestPaymentResponse['created_at']);
      }

      int unpaidMonths = (now.year - lastPaidDate.year) * 12 +
          (now.month - lastPaidDate.month);

      if (unpaidMonths <= 0) return 0;

      final childResponse = await supabase
          .from('tbl_child')
          .select('child_dob')
          .eq('id', childId)
          .single();

      DateTime childDob = DateTime.parse(childResponse['child_dob']);
      int childAge = now.difference(childDob).inDays ~/ 365;

      if (childAge < 0) {
        log(" Error: Invalid age calculated for child ID $childId.");
        return 0;
      }

      final feeResponse = await supabase
          .from('tbl_fees')
          .select('fees_amount')
          .eq('fees_age', childAge)
          .maybeSingle();

      if (feeResponse == null) {
        log(" Warning: No fee structure found for age $childAge.");
        return 0;
      }

      int monthlyFee = feeResponse['fees_amount'];
      int totalDue = unpaidMonths * monthlyFee;
      return totalDue;
    } catch (e) {
      log(" Error calculating fees for child $childId: $e");
      return 0;
    }
  }

  Future<void> markCashPayment(
      int childId, int amount, BuildContext context) async {
    try {
      await supabase.from('tbl_payment').insert({
        'child_id': childId,
        'amount_due': amount,
        'payment_mode': 'Cash',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment updated successfully")),
      );
      fetchChildren();
      notifyListeners();
    } catch (e) {
      print("Error updating payment: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating payment")),
      );
    }
  }
}
