import 'package:admin_app/app_utils/form_validation.dart';
import 'package:admin_app/controller/add_schedule_controller.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddSchedule extends StatefulWidget {
  final String id;
  const AddSchedule({super.key, required this.id});

  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AddScheduleController>();
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          // Allows scrolling if content overflows
          child: Padding(
            padding: const EdgeInsets.all(80),
            child: Column(
              children: [
                SizedBox(height: 40),
                Text(
                  'Add Schedule',
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat-Regular',
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: TextFormField(
                    validator: (value) => FormValidation.validateValue(value),
                    controller: provider.descriptioncontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Task Description',
                      labelStyle: TextStyle(
                        color: Colors.deepPurple,
                        fontFamily: 'Montserrat-Regular',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: TextFormField(
                    validator: (value) => FormValidation.validateValue(value),
                    controller: provider.stimecontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Start Time',
                      labelStyle: TextStyle(
                        color: Colors.deepPurple,
                        fontFamily: 'Montserrat-Regular',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: TextFormField(
                    validator: (value) => FormValidation.validateValue(value),
                    controller: provider.etimecontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'End Time',
                      labelStyle: TextStyle(
                        color: Colors.deepPurple,
                        fontFamily: 'Montserrat-Regular',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Age Category',
                      labelStyle: TextStyle(
                        color: Colors.deepPurple,
                        fontFamily: 'Montserrat-Regular',
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: "1",
                        child: Text("1"),
                      ),
                      DropdownMenuItem(
                        value: "2",
                        child: Text("2"),
                      ),
                      DropdownMenuItem(
                        value: "3",
                        child: Text("3"),
                      ),
                    ],
                    value: provider.selectedValue,
                    onChanged: (value) {
                      setState(() {
                        provider.selectedValue = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select an age category' : null,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        provider.insertData(id: widget.id, context: context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                      ),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
