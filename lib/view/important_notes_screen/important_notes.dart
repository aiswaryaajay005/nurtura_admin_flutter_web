import 'package:admin_app/controller/important_notes_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ImportantNotesController>();
    return Container(
      color: Colors.deepPurple[50],
      padding: EdgeInsets.all(16),
      child: Center(
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add Important Note',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: provider.contentController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Content',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context
                            .read<ImportantNotesController>()
                            .addNotes(context);
                      }
                    },
                    child: Text('Save Note'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
