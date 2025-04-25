// // ignore_for_file: prefer_final_fields

// import 'package:admin_app/components/form_validation.dart';
// import 'package:admin_app/main.dart';
// import 'package:flutter/material.dart';

// class ManageStaff extends StatefulWidget {
//   const ManageStaff({super.key});

//   @override
//   State<ManageStaff> createState() => _ManageStaffState();
// }

// class _ManageStaffState extends State<ManageStaff> {
//   final _formKey = GlobalKey<FormState>();

//   TextEditingController _namecontroller = TextEditingController();
//   TextEditingController _emailcontroller = TextEditingController();
//   TextEditingController _contactcontroller = TextEditingController();
//   TextEditingController _passwordcontroller = TextEditingController();

//   Future<void> register() async {
//     try {
//       final auth = await supabase.auth.signUp(
//           password: _passwordcontroller.text, email: _emailcontroller.text);
//       final uid = auth.user!.id;
//       if (uid.isNotEmpty || uid != "") {
//         storeData(uid);
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   Future<void> storeData(final uid) async {
//     try {
//       await supabase.from("tbl_staff").insert({
//         'id': uid,
//         'staff_name': _namecontroller.text,
//         'staff_email': _emailcontroller.text,
//         'staff_contact': _contactcontroller.text,
//         'staff_password': _passwordcontroller.text,
//       });
//       _namecontroller.clear();
//       _emailcontroller.clear();
//       _contactcontroller.clear();
//       _passwordcontroller.clear();
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Data Inserted !")));
//     } catch (e) {
//       print("Error storing data: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             SizedBox(
//               height: 40,
//             ),
//             Text(
//               'Add staff',
//               style: TextStyle(
//                   fontSize: 40,
//                   fontFamily: 'Montserrat-Regular',
//                   color: Colors.deepPurple,
//                   fontWeight: FontWeight.w500),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: TextFormField(
//                 validator: (value) => FormValidation.validateName(value),
//                 controller: _namecontroller,
//                 decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Enter staff name',
//                     labelText: 'Staff Name',
//                     labelStyle: TextStyle(
//                       fontFamily: 'Montserrat-Regular',
//                     )),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: TextFormField(
//                 validator: (value) => FormValidation.validateEmail(value),
//                 controller: _emailcontroller,
//                 decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Enter staff email',
//                     labelText: 'Staff Email',
//                     labelStyle: TextStyle(
//                       fontFamily: 'Montserrat-Regular',
//                     )),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: TextFormField(
//                 validator: (value) => FormValidation.validateContact(value),
//                 controller: _contactcontroller,
//                 decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Enter staff contact number',
//                     labelText: 'Staff Contact Number',
//                     labelStyle: TextStyle(
//                       fontFamily: 'Montserrat-Regular',
//                     )),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: TextFormField(
//                 validator: (value) => FormValidation.validatePassword(value),
//                 controller: _passwordcontroller,
//                 decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Enter password',
//                     labelText: 'Password',
//                     labelStyle: TextStyle(
//                       fontFamily: 'Montserrat-Regular',
//                     )),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (_formKey.currentState!.validate()) {
//                   register();
//                 }
//               },
//               child: Text('Submit',
//                   style: TextStyle(
//                     fontFamily: 'Montserrat-Regular',
//                   )),
//             )
//           ],
//         ));
//   }
// }
// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ManageStaff extends StatefulWidget {
  const ManageStaff({super.key});

  @override
  State<ManageStaff> createState() => _ManageStaffState();
}

class _ManageStaffState extends State<ManageStaff> {
  List<Map<String, dynamic>> staffList = [];

  @override
  void initState() {
    super.initState();
    fetchStaff();
  }

  Future<void> acceptStaff(String staffId) async {
    try {
      await supabase.from('tbl_staff').update({
        'staff_status': 1,
      }).eq('id', staffId);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Staff Accepted!")));
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> rejectStaff(String staffId) async {
    TextEditingController reasonController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reject Staff Application"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Please enter a reason for rejection:"),
              SizedBox(height: 10),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter reason",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String reason = reasonController.text.trim();
                if (reason.isNotEmpty) {
                  try {
                    await supabase.from('tbl_staff').update({
                      'staff_status': 2,
                      'rejection_reason': reason
                    }).eq('id', staffId);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Rejected: $reason")),
                    );
                  } catch (e) {
                    print("Error: $e");
                  }
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a rejection reason.")),
                  );
                }
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchStaff() async {
    try {
      final response =
          await supabase.from("tbl_staff").select().eq('staff_status', 0);
      setState(() {
        staffList = response;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void showStaffDetails(Map<String, dynamic> staff) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Staff Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Name: ${staff['staff_name'] ?? ''}"),
              Text("Email: ${staff['staff_email'] ?? ''}"),
              Text("Contact: ${staff['staff_contact'] ?? ''}"),
              Text("Address: ${staff['staff_address'] ?? ''}"),
              SizedBox(height: 10),
              if (staff['staff_cv'] != null)
                ElevatedButton(
                  onPressed: () async {
                    final url = staff['staff_cv'];
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Cannot open CV")),
                      );
                    }
                  },
                  child: Text("View CV"),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return staffList.isEmpty
        ? Center(child: Text('No new staff applications'))
        : SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "New Staff Applications",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                DataTable(
                  columns: [
                    DataColumn(label: Text("S.No")),
                    DataColumn(label: Text("Staff Name")),
                    DataColumn(label: Text("Actions")),
                  ],
                  rows: staffList.map((staff) {
                    int index = staffList.indexOf(staff) + 1;
                    return DataRow(
                      cells: [
                        DataCell(Text(index.toString())),
                        DataCell(Text(staff['staff_name'] ?? '')),
                        DataCell(
                          Row(
                            children: [
                              TextButton(
                                onPressed: () => showStaffDetails(staff),
                                child: Text("View Details"),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  acceptStaff(staff['id']);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: Text("Accept"),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  rejectStaff(staff['id']);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: Text("Reject"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          );
  }
}
