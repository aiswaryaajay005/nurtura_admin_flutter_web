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
        ? Center(child: CircularProgressIndicator(color: Colors.deepPurple))
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
                      fontSize: 30,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: meallist.length,
                  itemBuilder: (context, index) {
                    final meal = meallist[index];
                    final mealIndex = index + 1;

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4,
                      child: ExpansionTile(
                        title: Text(
                          'Meal $mealIndex - ${meal['meal_day'] ?? 'No Day'}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description: ${meal['meal_description'] ?? 'No Description'}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete,
                                          color: Colors.deepPurple),
                                      onPressed: () => deleteMeal(meal['id']),
                                      tooltip: 'Delete Meal',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
  }
}
