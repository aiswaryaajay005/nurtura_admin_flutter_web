import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';

class EventParticipation extends StatefulWidget {
  const EventParticipation({super.key});

  @override
  State<EventParticipation> createState() => _EventParticipationState();
}

class _EventParticipationState extends State<EventParticipation> {
  List<Map<String, dynamic>> participantList = [];
  @override
  void initState() {
    super.initState();
    fetchParticipant();
  }

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
        setState(() {
          participantList = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return participantList.isEmpty
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Event participants",
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
                    color: Colors.deepPurple,
                  ),
                  columns: [
                    DataColumn(label: Text("P.No")),
                    DataColumn(label: Text("Child Name")),
                    DataColumn(label: Text("Event Name")),
                    DataColumn(label: Text("Participation Status")),
                  ],
                  rows: participantList.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    Map<String, dynamic> event = entry.value;
                    print("Status: ${event['participate_status']}");
                    String status =
                        statusCheck(event['participate_status'] as int?);

                    return DataRow(cells: [
                      DataCell(Text(index.toString())),
                      DataCell(
                          Text(event['tbl_child']?['child_name'] ?? 'N/A')),
                      DataCell(
                          Text(event['tbl_event']?['event_name'] ?? 'N/A')),
                      DataCell(Text(status)),
                    ]);
                  }).toList(),
                ),
              ],
            ),
          );
  }
}
