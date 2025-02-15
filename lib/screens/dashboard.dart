import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 80),
            Text(
              'Welcome Admin!',
              style: TextStyle(
                  fontFamily: 'Montserrat-Regular',
                  fontSize: 50,
                  color: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }
}
