import 'package:admin_app/main.dart';
import 'package:admin_app/view/home_screen/homescreen.dart';
import 'package:flutter/material.dart';

class LoginScreenController with ChangeNotifier {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  Future<void> login(BuildContext context) async {
    try {
      final auth = await supabase.auth.signInWithPassword(
          password: passwordcontroller.text, email: emailcontroller.text);
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

  bool obscure = true;
}
