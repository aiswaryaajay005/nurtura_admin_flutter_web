import 'package:admin_app/controller/view_meal_controller.dart';
import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewMeal extends StatefulWidget {
  const ViewMeal({super.key});

  @override
  State<ViewMeal> createState() => _ViewMealState();
}

class _ViewMealState extends State<ViewMeal> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<ViewMealController>().fetchmeal();
      },
    );
    super.initState();
    // fetchmeal();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ViewMealController>();
    return provider.meallist.isEmpty
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
                  itemCount: provider.meallist.length,
                  itemBuilder: (context, index) {
                    final meal = provider.meallist[index];
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
                                      onPressed: () =>
                                          provider.deleteMeal(meal['id']),
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
