import 'package:admin_app/controller/view_payments_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewPayments extends StatefulWidget {
  const ViewPayments({super.key});

  @override
  State<ViewPayments> createState() => _ViewPaymentsState();
}

class _ViewPaymentsState extends State<ViewPayments> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<ViewPaymentsController>().fetchPaymentDetails();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ViewPaymentsController>();
    return provider.payments.isEmpty
        ? Center(
            child: Text("No data Available"),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "View Payments",
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontFamily: 'Montserrat-Bold',
                        fontSize: 30),
                  ),
                ),
                SizedBox(height: 20),
                DataTable(
                  columnSpacing: 30,
                  headingRowHeight: 50,
                  border: TableBorder(
                    top: BorderSide(color: Colors.grey[300]!, width: 1),
                    bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                    left: BorderSide(color: Colors.grey[300]!, width: 1),
                    right: BorderSide(color: Colors.grey[300]!, width: 1),
                    horizontalInside: BorderSide.none, // Removes row lines
                  ),
                  headingTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  columns: [
                    DataColumn(
                        label: Text(
                      "P.No",
                      style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                      ),
                    )),
                    DataColumn(
                        label: Text(
                      "Child Name",
                      style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                      ),
                    )),
                    DataColumn(
                        label: Text(
                      "Paid Amount",
                      style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                      ),
                    )),
                    DataColumn(
                        label: Text(
                      "Paid Date",
                      style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                      ),
                    )),
                  ],
                  rows: provider.payments.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    DateTime dateTime = DateTime.parse(
                        provider.payments[entry.key]['created_at']);
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(dateTime);
                    Map<String, dynamic> pay = entry.value;
                    return DataRow(cells: [
                      DataCell(Text(index.toString())),
                      DataCell(
                          Text(pay['tbl_child']?['child_name'] ?? 'Unknown')),
                      DataCell(Text(pay['amount_due'].toString())),
                      DataCell(Text(formattedDate))
                    ]);
                  }).toList(),
                ),
              ],
            ),
          );
  }
}
