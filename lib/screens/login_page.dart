import 'package:admin_app/screens/homescreen.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 211, 211, 211)),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/nurtura2.png'))),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                              fontFamily: 'Montserrat-Regular',
                              fontWeight: FontWeight.w700,
                              fontSize: 30,
                              color: Colors.deepPurple),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Form(
                            child: ListView(
                          shrinkWrap: true,
                          children: [
                            Text(
                              "Email",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Montserrat-Regular',
                              ),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter your email ID',
                                  suffixIcon: Icon(Icons.email_outlined),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.purple))),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Password',
                              style: TextStyle(
                                  fontFamily: 'Montserrat-Regular',
                                  fontWeight: FontWeight.bold),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter your password',
                                  suffixIcon: Icon(Icons.visibility),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.purple))),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Homepage(),
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-Regular',
                                      color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
