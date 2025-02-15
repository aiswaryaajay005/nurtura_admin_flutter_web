import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget {
  const MyAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.deepPurple, // Deep Purple background
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.person,
            color: Colors.white, // White color for the icon
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Admin",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          SizedBox(
            width: 40,
          ),
        ],
      ),
    );
  }
}
