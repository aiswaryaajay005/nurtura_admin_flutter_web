import 'package:admin_app/controller/view_event_controller.dart';
import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewEvent extends StatefulWidget {
  const ViewEvent({super.key});

  @override
  State<ViewEvent> createState() => _ViewEventState();
}

class _ViewEventState extends State<ViewEvent> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<ViewEventController>().fetchevent();
      },
    );
    super.initState();

    // fetchevent();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ViewEventController>();
    return provider.eventlist.isEmpty
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Staff Details",
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
                    DataColumn(label: Text("E.No")),
                    DataColumn(label: Text("Event Name")),
                    DataColumn(label: Text("Event Date")),
                    DataColumn(label: Text("Event details")),
                    DataColumn(label: Text("Status"))
                  ],
                  rows: provider.eventlist.asMap().entries.map((entry) {
                    int index = entry.key + 1; // Event index
                    Map<String, dynamic> event = entry.value;

                    DateTime eventDate = DateTime.parse(event['event_date']);
                    DateTime today = DateTime.now();

                    String eventStatus;
                    Color statusColor;

                    if (eventDate.isAtSameMomentAs(today) ||
                        (eventDate.year == today.year &&
                            eventDate.month == today.month &&
                            eventDate.day == today.day)) {
                      eventStatus = "Happening Now";
                      statusColor = Colors.orange;
                    } else if (eventDate.isAfter(today)) {
                      eventStatus = "Happening Soon";
                      statusColor = Colors.blue;
                    } else {
                      eventStatus = "Completed";
                      statusColor = Colors.grey;
                    }

                    return DataRow(cells: [
                      DataCell(Text(index.toString())), // Serial Number
                      DataCell(Text(event['event_name'] ?? 'No Name')),
                      DataCell(Text(event['event_date'] ?? 'No Date')),
                      DataCell(Text(event['event_details'] ?? 'No Details')),
                      DataCell(
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            eventStatus,
                            style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ],
            ),
          );
  }
}
