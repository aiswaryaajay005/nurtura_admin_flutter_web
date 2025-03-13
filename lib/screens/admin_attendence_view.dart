import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AdminAttendanceCalendar extends StatefulWidget {
  const AdminAttendanceCalendar({super.key});

  @override
  State<AdminAttendanceCalendar> createState() =>
      _AdminAttendanceCalendarState();
}

class _AdminAttendanceCalendarState extends State<AdminAttendanceCalendar> {
  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> attendanceRecords = [];
  List<Map<String, dynamic>> childrenResponse = [];
  @override
  void initState() {
    super.initState();
    fetchAttendanceRecords(_selectedDate);
  }

  Future<void> fetchAttendanceRecords(DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    try {
      final children = await supabase.from('tbl_child').select();
      final response = await supabase
          .from('tbl_childattendence')
          .select('child_id, attendence_status, checkin_time, checkout_time')
          .eq('attendence_date', formattedDate);

      setState(() {
        attendanceRecords = response;
        childrenResponse = children;
      });
    } catch (e) {
      print("Error fetching attendance: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Building the widget"); // Debug print
    return SizedBox(
      height: 800,
      width: double.infinity,
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: _selectedDate,
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) {
              print("Selected date: $_selectedDate"); // Debug print
              setState(() {
                _selectedDate = selectedDay;
                fetchAttendanceRecords(selectedDay);
              });
            },
          ),
          Expanded(
            child: attendanceRecords.isEmpty
                ? Center(child: Text("No Data or Holiday")) // Debug UI
                : ListView.builder(
                    itemCount: attendanceRecords.length,
                    itemBuilder: (context, index) {
                      print(
                          "Rendering attendance record: ${attendanceRecords[index]}"); // Debug print
                      final record = attendanceRecords[index];
                      final child = childrenResponse[index];
                      return Card(
                        child: ListTile(
                          title: Text("Child ID: ${record['child_id']}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Child Name: ${child['child_name']}"),
                              Text(
                                  "Check-In: ${record['checkin_time'] ?? 'Not Checked In'}"),
                              Text(
                                  "Check-Out: ${record['checkout_time'] ?? 'Not Checked Out'}"),
                              Text(
                                  "Status: ${record['attendence_status'] == 1 ? 'Present' : 'Absent'}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
