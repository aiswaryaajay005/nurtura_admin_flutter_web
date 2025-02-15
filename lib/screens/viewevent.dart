import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';

class ViewEvent extends StatefulWidget {
  const ViewEvent({super.key});

  @override
  State<ViewEvent> createState() => _ViewEventState();
}

class _ViewEventState extends State<ViewEvent> {
  List<Map<String, dynamic>> eventlist = [];
  @override
  void initState() {
    super.initState();
    fetchevent();
  }

  Future<void> fetchevent() async {
    try {
      final response = await supabase.from("tbl_event").select();

      setState(() {
        eventlist = response;
      });
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return eventlist.isEmpty
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: DataTable(
              columns: [
                DataColumn(label: Text("E.No")),
                DataColumn(label: Text("Event Name")),
                DataColumn(label: Text("Event Date")),
                DataColumn(label: Text("Event details")),
              ],
              rows: eventlist.asMap().entries.map((entry) {
                int index = entry.key + 1; // Staff index
                Map<String, dynamic> event = entry.value;
                return DataRow(cells: [
                  DataCell(Text(index.toString())), // Serial Number
                  DataCell(Text(event['event_name'] ?? 'No Name')),
                  DataCell(Text(event['event_date'] ?? 'No Date')),
                  DataCell(Text(event['event_details'] ?? 'No Details')),
                ]);
              }).toList(),
            ),
          );
  }
}
