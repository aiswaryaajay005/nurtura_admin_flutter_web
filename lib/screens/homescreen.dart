import 'package:admin_app/components/appbar.dart';
import 'package:admin_app/components/sidebar.dart';
import 'package:admin_app/screens/accepted_children.dart';
import 'package:admin_app/screens/admin_attendence_view.dart';
import 'package:admin_app/screens/cash_fee_payment.dart';
import 'package:admin_app/screens/complaints_view.dart';
import 'package:admin_app/screens/dashboard.dart';
import 'package:admin_app/screens/event_participation.dart';
import 'package:admin_app/screens/eventpage.dart';
import 'package:admin_app/screens/important_notes.dart';
import 'package:admin_app/screens/manage_staff.dart';
import 'package:admin_app/screens/mealmanagement.dart';
import 'package:admin_app/screens/rejected_children.dart';
import 'package:admin_app/screens/staff_leave.dart';
import 'package:admin_app/screens/view_children.dart';
import 'package:admin_app/screens/view_payments.dart';
import 'package:admin_app/screens/viewevent.dart';
import 'package:admin_app/screens/viewmeal.dart';
import 'package:admin_app/screens/viewstaff.dart';
import 'package:admin_app/staff_attendence.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Dashboard(),
    ManageStaff(),
    ViewStaff(),
    ViewStaffLeave(),
    StaffAttendence(),
    EventPage(),
    ViewEvent(),
    EventParticipation(),
    MealPage(),
    ViewMeal(),
    ViewChildren(),
    AcceptedChildren(),
    // RejectedChildren(),
    AdminAttendanceCalendar(),
    AddNotePage(),
    AdminComplaintsPage(),
    ViewPayments(),
    CashFeePayment()
  ];

  void onSidebarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: Row(
          children: [
            Expanded(
                flex: 1,
                child: MySideBar(
                  onItemSelected: onSidebarItemTapped,
                )),
            Expanded(
              flex: 5,
              child: ListView(
                children: [
                  MyAppbar(),
                  _pages[_selectedIndex],
                ],
              ),
            )
          ],
        ));
  }
}
