import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 1000,
            height: double.infinity,
            child: Image.asset(
              "assets/images/jelly.jpg",
              fit: BoxFit.contain,
            ),
          ),
          Container(
            width: 500,
            height: 500,
            child: Form(
                child: Form(
                    child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your email ID',
                    suffixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                Padding(padding: EdgeInsets.all(20)),
                Text(
                  'Password',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your password',
                      suffixIcon: Icon(Icons.visibility)),
                ),
                Padding(padding: EdgeInsets.all(20)),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Login'),
                )
              ],
            ))),
          )
        ],
      ),
    );
  }
}
