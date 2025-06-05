import 'package:admin_app/controller/home_screen_controller.dart';
import 'package:admin_app/widgets/appbar.dart';
import 'package:admin_app/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeScreenController>();
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: Row(
          children: [
            Expanded(
                flex: 1,
                child: MySideBar(
                  onItemSelected:
                      context.read<HomeScreenController>().onSidebarItemTapped,
                )),
            Expanded(
              flex: 5,
              child: ListView(
                children: [
                  MyAppbar(),
                  provider.pages[provider.selectedIndex],
                ],
              ),
            )
          ],
        ));
  }
}
