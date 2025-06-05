import 'package:admin_app/controller/admin_attendence_calender_controller.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AdminAttendanceCalendar extends StatefulWidget {
  const AdminAttendanceCalendar({super.key});

  @override
  State<AdminAttendanceCalendar> createState() =>
      _AdminAttendanceCalendarState();
}

class _AdminAttendanceCalendarState extends State<AdminAttendanceCalendar> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final provider = context.read<AdminAttendenceCalenderController>();
        context
            .read<AdminAttendenceCalenderController>()
            .fetchAttendanceRecords(provider.selectedDate);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AdminAttendenceCalenderController>();
    print("Building the widget");
    return SizedBox(
      height: 800,
      width: double.infinity,
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: provider.selectedDate,
            selectedDayPredicate: (day) =>
                isSameDay(provider.selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) {
              print("Selected date: ${provider.selectedDate}"); // Debug print
              setState(() {
                provider.selectedDate = selectedDay;
                context
                    .read<AdminAttendenceCalenderController>()
                    .fetchAttendanceRecords(selectedDay);
              });
            },
          ),
          Expanded(
            child: provider.attendanceRecords.isEmpty
                ? Center(child: Text("No Data or Holiday")) // Debug UI
                : ListView.builder(
                    itemCount: provider.attendanceRecords.length,
                    itemBuilder: (context, index) {
                      print(
                          "Rendering attendance record: ${provider.attendanceRecords[index]}"); // Debug print
                      final record = provider.attendanceRecords[index];
                      final child = provider.childrenResponse[index];
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
