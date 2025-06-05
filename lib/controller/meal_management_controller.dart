import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MealManagementController with ChangeNotifier {
  TextEditingController datecontroller = TextEditingController();
  TextEditingController detailscontroller = TextEditingController();
  Future<void> insertData(BuildContext context) async {
    try {
      await supabase.from('tbl_mealmanagement').insert({
        'meal_day': week,
        'meal_description': detailscontroller.text,
      });

      datecontroller.clear();
      detailscontroller.clear();
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

  String? week;
}
