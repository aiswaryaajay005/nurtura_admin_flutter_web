import 'package:admin_app/main.dart';
import 'package:flutter/widgets.dart';

class ViewMealController with ChangeNotifier {
  List<Map<String, dynamic>> meallist = [];
  Future<void> fetchmeal() async {
    try {
      final response = await supabase.from("tbl_mealmanagement").select();
      meallist = response;
      notifyListeners();
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> deleteMeal(int mealId) async {
    try {
      await supabase.from("tbl_mealmanagement").delete().match({'id': mealId});
      meallist.removeWhere((meal) => meal['id'] == mealId);
      notifyListeners();
    } catch (e) {
      print("Error deleting meal: $e");
    }
  }
}
