import 'package:flutter/material.dart';

class MySideBar extends StatefulWidget {
  final Function(int) onItemSelected;
  const MySideBar({super.key, required this.onItemSelected});

  @override
  State<MySideBar> createState() => _MySideBarState();
}

class _MySideBarState extends State<MySideBar> {
  final List<String> pages = [
    "Dashboard",
    "Manage Staff",
    "Add Event",
    "Add Meal",
    "View Staff",
    "View Event",
    "View Meal Details",
    "View Children",
    "Accepted",
    "Rejected"
  ];
  final List<IconData> icons = [
    Icons.house,
    Icons.person,
    Icons.event,
    Icons.food_bank,
    Icons.verified_user,
    Icons.schedule,
    Icons.food_bank_outlined,
    Icons.child_care,
    Icons.check,
    Icons.not_interested_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Sidebar width
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50),
              Center(
                child: Text(
                  "Nurtura",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(color: Colors.white38, thickness: 1),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      widget.onItemSelected(index);
                    },
                    leading: Icon(
                      icons[index],
                      color: Colors.white,
                      size: 28,
                    ),
                    title: Text(
                      pages[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    hoverColor: Colors.deepPurple[300], // Hover effect
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  );
                },
              ),
              Divider(color: Colors.white38, thickness: 1),
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 20.0),
          //   child: ListTile(
          //     leading:
          //         Icon(Icons.logout_outlined, color: Colors.white, size: 28),
          //     title: Text(
          //       "Logout",
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 16,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //     hoverColor: Colors.deepPurple[300], // Hover effect
          //     onTap: () {},
          //     contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //   ),
          // ),
        ],
      ),
    );
  }
}
