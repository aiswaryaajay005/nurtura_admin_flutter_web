import 'package:admin_app/components/form_validation.dart';
import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();
  TextEditingController _venueController = TextEditingController();

  Future<void> insertData() async {
    try {
      String ename = _nameController.text.trim();
      String edate = _dateController.text.trim();
      String etime = _timeController.text.trim();
      String edetails = _detailsController.text.trim();
      String evenue = _venueController.text.trim();

      if (ename.isEmpty || edate.isEmpty || etime.isEmpty || evenue.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("All fields are required!"),
              backgroundColor: Colors.red),
        );
        return;
      }

      await supabase.from('tbl_event').insert({
        'event_name': ename,
        'event_date': edate,
        'event_time': etime,
        'event_details': edetails,
        'event_venue': evenue,
      });

      _nameController.clear();
      _dateController.clear();
      _timeController.clear();
      _detailsController.clear();
      _venueController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Event added successfully!")),
      );
    } catch (e) {
      print("Error inserting event: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Failed to insert data. Please try again."),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                controller: _nameController,
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
                controller: _dateController,
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
                    _dateController.text = formattedDate;
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
                controller: _timeController,
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
                      _timeController.text =
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
                controller: _venueController,
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
                controller: _detailsController,
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
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    insertData();
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
