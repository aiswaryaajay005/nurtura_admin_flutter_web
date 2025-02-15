// ignore_for_file: prefer_final_fields

import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';

class ManageStaff extends StatefulWidget {
  const ManageStaff({super.key});

  @override
  State<ManageStaff> createState() => _ManageStaffState();
}

class _ManageStaffState extends State<ManageStaff> {
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _contactcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

  Future<void> register() async {
    try {
      final auth = await supabase.auth.signUp(
          password: _passwordcontroller.text, email: _emailcontroller.text);
      final uid = auth.user!.id;
      if (uid.isNotEmpty || uid != "") {
        storeData(uid);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> storeData(final uid) async {
    try {
      await supabase.from("tbl_staff").insert({
        'id': uid,
        'staff_name': _namecontroller.text,
        'staff_email': _emailcontroller.text,
        'staff_contact': _contactcontroller.text,
        'staff_password': _passwordcontroller.text,
      });
      _namecontroller.clear();
      _emailcontroller.clear();
      _contactcontroller.clear();
      _passwordcontroller.clear();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Inserted !")));
    } catch (e) {
      print("Error storing data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: [
        SizedBox(
          height: 40,
        ),
        Text(
          'Staff Form',
          style: TextStyle(
              fontSize: 40,
              fontFamily: 'Montserrat-Regular',
              color: Colors.deepPurple,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextFormField(
            controller: _namecontroller,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter staff name',
                labelText: 'Staff Name',
                labelStyle: TextStyle(
                  fontFamily: 'Montserrat-Regular',
                )),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextFormField(
            controller: _emailcontroller,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter staff email',
                labelText: 'Staff Email',
                labelStyle: TextStyle(
                  fontFamily: 'Montserrat-Regular',
                )),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextFormField(
            controller: _contactcontroller,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter staff contact number',
                labelText: 'Staff Contact Number',
                labelStyle: TextStyle(
                  fontFamily: 'Montserrat-Regular',
                )),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextFormField(
            controller: _passwordcontroller,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter password',
                labelText: 'Password',
                labelStyle: TextStyle(
                  fontFamily: 'Montserrat-Regular',
                )),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            register();
          },
          child: Text('Submit',
              style: TextStyle(
                fontFamily: 'Montserrat-Regular',
              )),
        )
      ],
    ));
  }
}
