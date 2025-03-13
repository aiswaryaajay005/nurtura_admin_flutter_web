import 'package:admin_app/components/form_validation.dart';
import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';

class MealPage extends StatefulWidget {
  const MealPage({super.key});

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _datecontroller = TextEditingController();
  TextEditingController _detailscontroller = TextEditingController();
  Future<void> insertData() async {
    try {
      await supabase.from('tbl_mealmanagement').insert({
        'meal_day': week,
        'meal_description': _detailscontroller.text,
      });

      _datecontroller.clear();
      _detailscontroller.clear();
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

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          SizedBox(height: 40),
          Text(
            'Meal Form',
            style: TextStyle(
              fontSize: 36,
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: DropdownButtonFormField(
                validator: (value) => FormValidation.validateDropdown(value),
                value: week,
                items: [
                  DropdownMenuItem(
                    value: "Monday",
                    child: Text("Monday"),
                  ),
                  DropdownMenuItem(
                    value: "Tuesday",
                    child: Text("Tuesday"),
                  ),
                  DropdownMenuItem(
                    value: "Wednesday",
                    child: Text("Wednesday"),
                  ),
                  DropdownMenuItem(
                    value: "Thursday",
                    child: Text("Thursday"),
                  ),
                  DropdownMenuItem(
                    value: "Friday",
                    child: Text("Friday"),
                  ),
                  DropdownMenuItem(
                    value: "Saturday",
                    child: Text("Saturday"),
                  ),
                ],
                onChanged: (value) {
                  week = value;
                },
              )
              //  TextFormField(
              //   readOnly: true, // Prevents the keyboard from opening
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     hintText: 'Enter meal day',
              //     labelText: 'Meal Day',
              //     labelStyle: TextStyle(
              //       color: Colors.deepPurple,
              //       fontFamily: 'Montserrat-Regular',
              //     ),
              //     suffixIcon: Icon(Icons.calendar_today, color: Colors.deepPurple),
              //   ),
              //   onTap: () async {
              //     DateTime? pickedDate = await showDatePicker(
              //       context: context,
              //       initialDate: DateTime.now(), // Default date is today
              //       firstDate: DateTime(2000), // Minimum date
              //       lastDate: DateTime(2100), // Maximum date
              //     );

              //     if (pickedDate != null) {
              //       String formattedDate =
              //           "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
              //       _datecontroller.text = formattedDate;
              //     }
              //   },
              //   controller: _datecontroller, // Link the controller here
              // ),
              ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: TextFormField(
              validator: (value) => FormValidation.validateValue(value),
              controller: _detailscontroller,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Enter meal description',
                labelText: 'Meal Description',
                labelStyle: TextStyle(
                  color: Colors.deepPurple,
                  fontFamily: 'Montserrat-Regular',
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  insertData;
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text(
                'Submit',
                style: TextStyle(
                  fontFamily: 'Montserrat-Regular',
                ),
              ),
            ),
          )
        ]));
  }
}
