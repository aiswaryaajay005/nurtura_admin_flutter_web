import 'package:flutter/widgets.dart';
import 'dart:io';

import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data'; // Import for web compatibility
import 'package:flutter/foundation.dart' show kIsWeb; // Detect platform

class EventPageController with ChangeNotifier {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController venueController = TextEditingController();
  TextEditingController noticeController = TextEditingController();

  File? selectedFile; // Define it here for mobile use

  Uint8List? selectedFileBytes; // Use Uint8List for Web
  String? selectedFileName; // Store file name

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      selectedFileName = result.files.first.name; // Store file name

      if (kIsWeb) {
        selectedFileBytes = result.files.first.bytes; // Get bytes for Web
      } else {
        selectedFile = File(result.files.single.path!); // Use File for Mobile
      }

      noticeController.text = selectedFileName!;
      notifyListeners();
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

  Future<void> insertData(BuildContext context) async {
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

      String ename = nameController.text.trim();
      String edate = dateController.text.trim();
      String etime = timeController.text.trim();
      String edetails = detailsController.text.trim();
      String evenue = venueController.text.trim();

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

      nameController.clear();
      dateController.clear();
      timeController.clear();
      detailsController.clear();
      venueController.clear();
      noticeController.clear();

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
}
