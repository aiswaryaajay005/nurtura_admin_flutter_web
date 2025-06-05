import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddScheduleController with ChangeNotifier {
  String? selectedValue;
  TextEditingController descriptioncontroller = TextEditingController();
  TextEditingController stimecontroller = TextEditingController();
  TextEditingController etimecontroller = TextEditingController();
  Future<void> insertData(
      {required var id, required BuildContext context}) async {
    try {
      await supabase.from('tbl_schedule').insert({
        'task_description': descriptioncontroller.text,
        'start_time': stimecontroller.text,
        'end_time': etimecontroller.text,
        'age_category': selectedValue,
        'staff_id': id
      });

      descriptioncontroller.clear();
      stimecontroller.clear();
      etimecontroller.clear();
      selectedValue = null;
      notifyListeners();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Inserted!")));
    } catch (e) {
      print("Error inserting event: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to insert data. Please try again."),
        backgroundColor: Colors.red,
      ));
    }
  }
}
