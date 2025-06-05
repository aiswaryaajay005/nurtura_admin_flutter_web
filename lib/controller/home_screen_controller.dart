import 'package:admin_app/view/important_notes_screen/important_notes.dart';
import 'package:admin_app/view/manage_staff_screen/manage_staff.dart';
import 'package:admin_app/view/meal_management_screen/mealmanagement.dart';
import 'package:admin_app/view/staff_leave_screen/staff_leave.dart';
import 'package:admin_app/view/view_children_Screen/view_children.dart';
import 'package:admin_app/view/view_event_screen/viewevent.dart';
import 'package:admin_app/view/view_meal_screen/viewmeal.dart';
import 'package:admin_app/view/view_payment_screen/view_payments.dart';
import 'package:admin_app/view/view_staff_screen/viewstaff.dart';
import 'package:flutter/widgets.dart';
import 'package:admin_app/view/accepted_children_screen/accepted_children.dart';
import 'package:admin_app/view/admin_attendence_view_screen/admin_attendence_view.dart';
import 'package:admin_app/view/cash_fee_payment_screen/cash_fee_payment.dart';
import 'package:admin_app/view/compliants_view_screen/complaints_view.dart';
import 'package:admin_app/view/admin_dashboard/dashboard.dart';
import 'package:admin_app/view/event_particpants_screen/event_participation.dart';
import 'package:admin_app/view/event_screen/eventpage.dart';
import 'package:admin_app/widgets/staff_attendence.dart';
import 'package:flutter/material.dart';

class HomeScreenController with ChangeNotifier {
  int selectedIndex = 0;

  final List<Widget> pages = [
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
    AdminAttendanceCalendar(),
    AddNotePage(),
    AdminComplaintsPage(),
    ViewPayments(),
    CashFeePayment()
  ];

  void onSidebarItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
