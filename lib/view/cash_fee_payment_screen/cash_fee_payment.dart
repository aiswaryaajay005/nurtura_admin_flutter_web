import 'package:admin_app/controller/cash_fee_payement_controller.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CashFeePayment extends StatefulWidget {
  const CashFeePayment({super.key});

  @override
  State<CashFeePayment> createState() => _CashFeePaymentState();
}

class _CashFeePaymentState extends State<CashFeePayment> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<CashFeePayementController>().fetchChildren();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CashFeePayementController>();
    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (provider.children.isEmpty) {
      return Center(child: Text("No children found"));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: provider.children.length,
      itemBuilder: (context, index) {
        int childId = provider.children[index]['id'];
        String childName = provider.children[index]['child_name'];

        return FutureBuilder<int>(
          future:
              context.read<CashFeePayementController>().getPendingFees(childId),
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
                          context
                              .read<CashFeePayementController>()
                              .markCashPayment(childId, pendingFees, context);
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
