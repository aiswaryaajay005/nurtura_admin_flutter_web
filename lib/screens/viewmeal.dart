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
      print("Error: $e");
    }
  }

  Future<void> deleteMeal(int mealId) async {
    try {
      await supabase.from("tbl_mealmanagement").delete().match({'id': mealId});
      setState(() {
        meallist.removeWhere((meal) => meal['id'] == mealId);
      });
    } catch (e) {
      print("Error deleting meal: $e");
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
                  border: TableBorder.all(color: Colors.grey[300]!),
                  headingTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.deepPurple,
                  ),
                  columns: [
                    DataColumn(label: Text("M.No")),
                    DataColumn(label: Text("Meal day")),
                    DataColumn(label: Text("Meal description")),
                    DataColumn(label: Text("Actions")),
                  ],
                  rows: meallist.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    Map<String, dynamic> meal = entry.value;
                    return DataRow(cells: [
                      DataCell(Text(index.toString())),
                      DataCell(Text(meal['meal_day'] ?? 'No Day')),
                      DataCell(
                          Text(meal['meal_description'] ?? 'No Description')),
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.deepPurple),
                          onPressed: () => deleteMeal(meal['id']),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ],
            ),
          );
  }
}
