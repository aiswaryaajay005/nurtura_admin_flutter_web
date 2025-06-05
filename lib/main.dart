import 'package:admin_app/controller/accepted_children_controller.dart';
import 'package:admin_app/controller/add_schedule_controller.dart';
import 'package:admin_app/controller/admin_attendence_calender_controller.dart';
import 'package:admin_app/controller/cash_fee_payement_controller.dart';
import 'package:admin_app/controller/complaints_page_controller.dart';
import 'package:admin_app/controller/event_page_controller.dart';
import 'package:admin_app/controller/event_participants_controller.dart';
import 'package:admin_app/controller/home_screen_controller.dart';
import 'package:admin_app/controller/important_notes_controller.dart';
import 'package:admin_app/controller/login_screen_controller.dart';
import 'package:admin_app/controller/manage_staff_controller.dart';
import 'package:admin_app/controller/meal_management_controller.dart';
import 'package:admin_app/controller/staff_leave_controller.dart';
import 'package:admin_app/controller/view_children_controller.dart';
import 'package:admin_app/controller/view_event_controller.dart';
import 'package:admin_app/controller/view_meal_controller.dart';
import 'package:admin_app/controller/view_payments_controller.dart';
import 'package:admin_app/controller/view_staff_controller.dart';
import 'package:admin_app/view/login_screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://gflbqmzjujxsdbidtyhk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdmbGJxbXpqdWp4c2RiaWR0eWhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc0NDc1MzUsImV4cCI6MjA1MzAyMzUzNX0.Zo7c3j74r5YTwhvwoaE0ukuWs87JyZtWyuVTtn8KTwI',
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => AcceptedChildrenController(),
    ),
    ChangeNotifierProvider(
      create: (context) => AddScheduleController(),
    ),
    ChangeNotifierProvider(
      create: (context) => AdminAttendenceCalenderController(),
    ),
    ChangeNotifierProvider(
      create: (context) => CashFeePayementController(),
    ),
    ChangeNotifierProvider(
      create: (context) => ComplaintsPageController(),
    ),
    ChangeNotifierProvider(
      create: (context) => EventParticipantsController(),
    ),
    ChangeNotifierProvider(
      create: (context) => EventPageController(),
    ),
    ChangeNotifierProvider(
      create: (context) => HomeScreenController(),
    ),
    ChangeNotifierProvider(
      create: (context) => ImportantNotesController(),
    ),
    ChangeNotifierProvider(
      create: (context) => LoginScreenController(),
    ),
    ChangeNotifierProvider(
      create: (context) => ManageStaffController(),
    ),
    ChangeNotifierProvider(
      create: (context) => MealManagementController(),
    ),
    ChangeNotifierProvider(
      create: (context) => StaffLeaveController(),
    ),
    ChangeNotifierProvider(
      create: (context) => ViewChildrenController(),
    ),
    ChangeNotifierProvider(
      create: (context) => ViewPaymentsController(),
    ),
    ChangeNotifierProvider(
      create: (context) => ViewEventController(),
    ),
    ChangeNotifierProvider(
      create: (context) => ViewMealController(),
    ),
    ChangeNotifierProvider(
      create: (context) => ViewStaffController(),
    )
  ], child: MainApp()));
}

// Get a reference your Supabase client
final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: LoginPage());
  }
}
