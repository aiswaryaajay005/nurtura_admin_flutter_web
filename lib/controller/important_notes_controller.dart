import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImportantNotesController with ChangeNotifier {
  final TextEditingController contentController = TextEditingController();
  Future<void> addNotes(BuildContext context) async {
    try {
      await supabase
          .from('tbl_notification')
          .insert({"notification_content": contentController.text});
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Notification added suucessfully")));
      contentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Try Again $e")));
    }
  }
}
