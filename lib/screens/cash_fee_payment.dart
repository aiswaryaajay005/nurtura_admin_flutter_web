import 'dart:developer';

import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';

class CashFeePayment extends StatefulWidget {
  const CashFeePayment({super.key});

  @override
  State<CashFeePayment> createState() => _CashFeePaymentState();
}

class _CashFeePaymentState extends State<CashFeePayment> {
  List<Map<String, dynamic>> children = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChildren();
  }

  Future<void> fetchChildren() async {
    try {
      final response = await supabase.from('tbl_child').select();

      log("Fetched children: $response");

      if (response.isEmpty) {
        log("No children found in database.");
      }

      setState(() {
        children = response;
        isLoading = false;
      });
    } catch (e) {
      log("Error fetching children: $e");
      setState(() {
        isLoading = false;
      });
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

  Future<void> markCashPayment(int childId, int amount) async {
    try {
      await supabase.from('tbl_payment').insert({
        'child_id': childId,
        'amount_due': amount,
        'payment_mode': 'Cash',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment updated successfully")),
      );

      setState(() {
        fetchChildren();
      });
    } catch (e) {
      print("Error updating payment: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating payment")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (children.isEmpty) {
      return Center(child: Text("No children found"));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: children.length,
      itemBuilder: (context, index) {
        int childId = children[index]['id'];
        String childName = children[index]['child_name'];

        return FutureBuilder<int>(
          future: getPendingFees(childId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return ListTile(
                title: Text(childName),
                subtitle: Text("Checking pending fees..."),
              );
            }

            int pendingFees = snapshot.data ?? 0;
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text(childName,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: pendingFees > 0
                    ? Text("Pending Fees: ₹$pendingFees",
                        style: TextStyle(color: Colors.red))
                    : Text("No pending fees",
                        style: TextStyle(color: Colors.green)),
                trailing: pendingFees > 0
                    ? ElevatedButton(
                        onPressed: () {
                          markCashPayment(childId, pendingFees);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Mark as Paid"),
                      )
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}
