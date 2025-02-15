import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';

class ViewMeal extends StatefulWidget {
  const ViewMeal({super.key});

  @override
  State<ViewMeal> createState() => _ViewMealState();
}

class _ViewMealState extends State<ViewMeal> {
  List<Map<String, dynamic>> meallist = [];
  @override
  void initState() {
    super.initState();
    fetchmeal();
  }

  Future<void> fetchmeal() async {
    try {
      final response = await supabase.from("tbl_mealmanagement").select();

      setState(() {
        meallist = response;
      });
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return meallist.isEmpty
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: DataTable(
              columns: [
                DataColumn(
                    label: Text(
                  "M.No",
                  style: TextStyle(
                      fontFamily: 'Montserrat-Regular',
                      color: Colors.deepPurple),
                )),
                DataColumn(
                    label: Text(
                  "Meal day",
                  style: TextStyle(
                      fontFamily: 'Montserrat-Regular',
                      color: Colors.deepPurple),
                )),
                DataColumn(
                    label: Text(
                  "Meal description",
                  style: TextStyle(
                      fontFamily: 'Montserrat-Regular',
                      color: Colors.deepPurple),
                )),
              ],
              rows: meallist.asMap().entries.map((entry) {
                int index = entry.key + 1; // Staff index
                Map<String, dynamic> meal = entry.value;
                return DataRow(cells: [
                  DataCell(Text(index.toString())), // Serial Number
                  DataCell(Text(
                    meal['meal_day'] ?? 'No Day',
                    style: TextStyle(
                      fontFamily: 'Montserrat-Regular',
                    ),
                  )),
                  DataCell(Text(
                    meal['meal_description'] ?? 'No Description',
                    style: TextStyle(
                      fontFamily: 'Montserrat-Regular',
                    ),
                  )),
                ]);
              }).toList(),
            ),
          );
  }
}
