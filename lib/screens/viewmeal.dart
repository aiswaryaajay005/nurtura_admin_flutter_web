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
              ],
            ),
          );
  }
}
