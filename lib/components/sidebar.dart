import 'package:flutter/material.dart';

class MySideBar extends StatefulWidget {
  final Function(int) onItemSelected;
  const MySideBar({super.key, required this.onItemSelected});

  @override
  State<MySideBar> createState() => _MySideBarState();
}

class _MySideBarState extends State<MySideBar> {
  int selectedIndex = 0;

  final List<String> pages = [
    "Dashboard",
    "Manage Staff",
    "View Staff",
    "Staff Attendence",
    "Add Event",
    "View Event",
    "Event Participants",
    "Add Meal",
    "View Meal Details",
    "View Children",
    "Accepted Children",
    // "Rejected Children",
    "Attendence",
    "Add Important Notes",
    "View & Reply complaints",
    "Payment View"
  ];

  final List<IconData> icons = [
    Icons.dashboard,
    Icons.person,
    Icons.people,
    Icons.person_search_sharp,
    Icons.event,
    Icons.calendar_today,
    Icons.groups,
    Icons.fastfood,
    Icons.food_bank_outlined,
    Icons.child_care,
    Icons.check_circle,
    // Icons.cancel,
    Icons.check_box_sharp,
    Icons.import_contacts_rounded,
    Icons.label_important,
    Icons.payments_outlined
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.deepPurple.shade200], // Light gradient
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo/Header Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Nurtura",
              style: TextStyle(
                fontFamily: 'Amsterdam',
                color: Color(0xFF4A148C), // Deep Purple
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView.builder(
              itemCount: pages.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedIndex == index;
                return ListTile(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    widget.onItemSelected(index);
                  },
                  leading: Icon(
                    icons[index],
                    color: isSelected ? Colors.deepPurple : Colors.grey[700],
                  ),
                  title: Text(
                    pages[index],
                    style: TextStyle(
                      color: isSelected ? Colors.deepPurple : Colors.grey[800],
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  tileColor: isSelected ? Colors.deepPurple[50] : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                );
              },
            ),
          ),

          // Profile Section (Bottom)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(),
                title: Text(
                  "Admin",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  "admin123@gmail.com",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
