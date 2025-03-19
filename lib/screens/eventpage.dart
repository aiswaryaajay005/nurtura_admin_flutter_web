import 'dart:io';

import 'package:admin_app/components/form_validation.dart';
import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data'; // Import for web compatibility
import 'package:flutter/foundation.dart' show kIsWeb; // Detect platform

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
  TextEditingController _noticeController = TextEditingController();

  File? selectedFile; // Define it here for mobile use

  Uint8List? selectedFileBytes; // Use Uint8List for Web
  String? selectedFileName; // Store file name

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      setState(() {
        selectedFileName = result.files.first.name; // Store file name

        if (kIsWeb) {
          selectedFileBytes = result.files.first.bytes; // Get bytes for Web
        } else {
          selectedFile = File(result.files.single.path!); // Use File for Mobile
        }

        _noticeController.text = selectedFileName!;
      });
    }
  }

  Future<String?> uploadFile() async {
    if (selectedFileBytes == null && selectedFile == null) {
      return null;
    }

    try {
      String fileExt = selectedFileName!.split('.').last;
      String fileName =
          'proofs/${DateTime.now().millisecondsSinceEpoch}.$fileExt';

      if (kIsWeb) {
        // Upload using `uploadBinary()` for Web
        await supabase.storage
            .from('noticefile')
            .uploadBinary(fileName, selectedFileBytes!);
      } else {
        // Upload using `upload()` for Mobile
        await supabase.storage
            .from('noticefile')
            .upload(fileName, selectedFile!);
      }

      String fileUrl =
          supabase.storage.from('noticefile').getPublicUrl(fileName);
      print("File Uploaded: $fileUrl");

      return fileUrl;
    } catch (e) {
      print("Upload Error: $e");
      return null;
    }
  }

  Future<void> insertData() async {
    try {
      String? noticeUrl = await uploadFile();

      if (noticeUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("File upload failed!"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      String ename = _nameController.text.trim();
      String edate = _dateController.text.trim();
      String etime = _timeController.text.trim();
      String edetails = _detailsController.text.trim();
      String evenue = _venueController.text.trim();

      if (ename.isEmpty || edate.isEmpty || etime.isEmpty || evenue.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("All fields are required!"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      await supabase.from('tbl_event').insert({
        'event_name': ename,
        'event_date': edate,
        'event_time': etime,
        'event_details': edetails,
        'event_venue': evenue,
        'event_notice': noticeUrl,
      });

      _nameController.clear();
      _dateController.clear();
      _timeController.clear();
      _detailsController.clear();
      _venueController.clear();
      _noticeController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Event added successfully!")),
      );
    } catch (e) {
      print("Error inserting event: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to insert data. Please try again."),
          backgroundColor: Colors.red,
        ),
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
              child: GestureDetector(
                onTap: pickFile,
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: true,
                    controller: _noticeController,
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
