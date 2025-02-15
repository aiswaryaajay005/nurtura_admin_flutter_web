import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  TextEditingController _datecontroller = TextEditingController();
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _detailscontroller = TextEditingController();

  Future<void> insertData() async {
    try {
      String ename = _namecontroller.text;
      await supabase.from('tbl_event').insert({
        'event_name': ename,
        'event_date': _datecontroller.text,
        'event_details': _detailscontroller.text
      });
      _namecontroller.clear();
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

  @override
  Widget build(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
        // Allows scrolling if content overflows
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: TextFormField(
                controller: _namecontroller,
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
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: TextFormField(
                readOnly: true, // Prevents the keyboard from opening
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Enter event date',
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
                    initialDate: DateTime.now(), // Default date is today
                    firstDate: DateTime(2000), // Minimum date
                    lastDate: DateTime(2100), // Maximum date
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    _datecontroller.text = formattedDate;
                  }
                },
                controller: _datecontroller, // Link the controller here
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: TextFormField(
                controller: _detailscontroller,
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
                onPressed: insertData,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: Text('Submit',
                    style: TextStyle(
                      fontFamily: 'Montserrat-Regular',
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
