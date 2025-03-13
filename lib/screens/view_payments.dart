import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewPayments extends StatefulWidget {
  const ViewPayments({super.key});

  @override
  State<ViewPayments> createState() => _ViewPaymentsState();
}

class _ViewPaymentsState extends State<ViewPayments> {
  List<Map<String, dynamic>> payments = [];
  Future<void> fetchPaymentDetails() async {
    try {
      final response =
          await supabase.from('tbl_payment').select('*, tbl_child(*)');
      setState(() {
        payments = response;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPaymentDetails();
  }

  @override
  Widget build(BuildContext context) {
    return payments.isEmpty
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
                  rows: payments.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    DateTime dateTime =
                        DateTime.parse(payments[entry.key]['created_at']);
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
