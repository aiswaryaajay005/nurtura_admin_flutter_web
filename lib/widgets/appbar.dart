import 'package:admin_app/main.dart';

import 'package:admin_app/view/login_screen/login_page.dart';
import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget {
  const MyAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.deepPurple.shade200], // Light gradient
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () async {
              await supabase.auth.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
                (Route<dynamic> route) => false,
              );
            },
            child: CircleAvatar(
              child: Icon(Icons.logout),
              backgroundColor: Colors.white,
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}
