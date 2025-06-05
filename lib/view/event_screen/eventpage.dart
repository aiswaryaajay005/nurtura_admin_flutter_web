import 'package:admin_app/app_utils/form_validation.dart';
import 'package:admin_app/controller/event_page_controller.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventPageController>();
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              'Event Form',
              style: TextStyle(
                fontSize: 36,
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat-Regular',
              ),
            ),
            SizedBox(height: 20),

            // Event Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: TextFormField(
                validator: (value) => FormValidation.validateValue(value),
                controller: provider.nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Enter event name',
                  labelText: 'Event Name',
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat-Regular',
                      color: Colors.deepPurple),
                ),
              ),
            ),

            // Event Date
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: TextFormField(
                validator: (value) => FormValidation.validateValue(value),
                readOnly: true,
                controller: provider.dateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Select event date',
                  labelText: 'Event Date',
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat-Regular',
                      color: Colors.deepPurple),
                  suffixIcon:
                      Icon(Icons.calendar_today, color: Colors.deepPurple),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    provider.dateController.text = formattedDate;
                  }
                },
              ),
            ),

            // Event Time
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: TextFormField(
                validator: (value) => FormValidation.validateValue(value),
                readOnly: true,
                controller: provider.timeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Select event time',
                  labelText: 'Event Time',
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat-Regular',
                      color: Colors.deepPurple),
                  suffixIcon: Icon(Icons.access_time, color: Colors.deepPurple),
                ),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime != null) {
                    final now = DateTime.now();
                    final formattedTime = DateTime(now.year, now.month, now.day,
                            pickedTime.hour, pickedTime.minute)
                        .toIso8601String()
                        .substring(11, 19); // Extracts HH:mm:ss

                    setState(() {
                      provider.timeController.text =
                          formattedTime; // Example: "14:30:00"
                    });
                  }
                },
              ),
            ),

            // Venue
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: TextFormField(
                validator: (value) => FormValidation.validateValue(value),
                controller: provider.venueController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Enter event venue',
                  labelText: 'Venue',
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat-Regular',
                      color: Colors.deepPurple),
                ),
              ),
            ),

            // Event Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: TextFormField(
                validator: (value) => FormValidation.validateValue(value),
                controller: provider.detailsController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Enter event details',
                  labelText: 'Event Details',
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat-Regular',
                      color: Colors.deepPurple),
                ),
              ),
            ),

            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: GestureDetector(
                onTap: context.read<EventPageController>().pickFile,
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: true,
                    controller: provider.noticeController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Click here to upload Event',
                      prefixIcon:
                          Icon(Icons.upload_file, color: Colors.deepPurple),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<EventPageController>().insertData(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: Text('Submit',
                    style: TextStyle(fontFamily: 'Montserrat-Regular')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
