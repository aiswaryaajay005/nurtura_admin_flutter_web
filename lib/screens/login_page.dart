import 'package:admin_app/components/form_validation.dart';
import 'package:admin_app/main.dart';
import 'package:admin_app/screens/homescreen.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  Future<void> login() async {
    try {
      final auth = await supabase.auth.signInWithPassword(
          password: _passwordcontroller.text, email: _emailcontroller.text);
      final admin = await supabase
          .from('tbl_admin')
          .select()
          .eq('id', auth.user!.id)
          .single();
      if (admin.isNotEmpty) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Homepage(),
            ));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Enter Valid Credentials")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Enter Valid Credentials")));
      print("Error: $e");
    }
  }

  bool _obscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            key: _formKey,
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
                                  validator: (value) =>
                                      FormValidation.validateEmail(value),
                                  controller: _emailcontroller,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter your email ID',
                                      suffixIcon: Icon(Icons.email_outlined),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.purple))),
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
                                  obscureText: _obscure,
                                  validator: (value) =>
                                      FormValidation.validateValue(value),
                                  controller: _passwordcontroller,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter your password',
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscure
                                              ? Icons.visibility_off
                                              : Icons.remove_red_eye_outlined,
                                          color: Colors.deepPurple,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscure = !_obscure;
                                          });
                                        },
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.purple))),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                  ),
                                  onPressed: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => Homepage(),
                                    //     ));
                                    if (_formKey.currentState!.validate()) {
                                      login();
                                    }
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
