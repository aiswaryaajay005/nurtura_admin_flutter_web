import 'package:flutter/material.dart';

class MySideBar extends StatefulWidget {
  final Function(int) onItemSelected;
  const MySideBar({super.key, required this.onItemSelected});

  @override
  State<MySideBar> createState() => _MySideBarState();
}

class _MySideBarState extends State<MySideBar> {
  int selectedIndex = 0;
  Map<String, List<Map<String, dynamic>>> menuItems = {
    "Dashboard": [
      {"title": "Dashboard", "icon": Icons.dashboard},
    ],
    "Staff Management": [
      {"title": "Manage Staff Registrations", "icon": Icons.person},
      {"title": "View Staff", "icon": Icons.people},
      {"title": "View Leave Details", "icon": Icons.people},
      {"title": "Staff Attendance", "icon": Icons.person_search_sharp},
    ],
    "Events": [
      {"title": "Add Event", "icon": Icons.event},
      {"title": "View Event", "icon": Icons.calendar_today},
      {"title": "Event Participants", "icon": Icons.groups},
    ],
    "Meal Management": [
      {"title": "Add Meal", "icon": Icons.fastfood},
      {"title": "View Meal Details", "icon": Icons.food_bank_outlined},
    ],
    "Admissions": [
      {"title": "New Admissions", "icon": Icons.child_care},
      {"title": "Accepted Children", "icon": Icons.check_circle},
    ],
    "Attendance & Notes": [
      {"title": "Attendance", "icon": Icons.check_box_sharp},
      {"title": "Add Important Notes", "icon": Icons.import_contacts_rounded},
    ],
    "Complaints & Payments": [
      {"title": "View & Reply Complaints", "icon": Icons.label_important},
      {"title": "Payment View", "icon": Icons.payments_outlined},
      {"title": "Cash Payments", "icon": Icons.wallet},
    ],
  };

  Map<String, bool> expandedState = {};

  @override
  void initState() {
    super.initState();
    for (var key in menuItems.keys) {
      expandedState[key] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.deepPurple.shade200],
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Nurtura",
              style: TextStyle(
                fontFamily: 'Amsterdam',
                color: Color(0xFF4A148C),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: menuItems.keys.map((category) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      color: Colors.deepPurple.shade100,
                      child: ListTile(
                        title: Text(
                          category,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple.shade900,
                          ),
                        ),
                        trailing: Icon(
                          expandedState[category]!
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: Colors.deepPurple.shade900,
                        ),
                        onTap: () {
                          setState(() {
                            expandedState[category] = !expandedState[category]!;
                          });
                        },
                      ),
                    ),
                    if (expandedState[category]!)
                      ...menuItems[category]!.map((item) {
                        int itemIndex = menuItems.values
                            .expand((i) => i)
                            .toList()
                            .indexOf(item);
                        bool isSelected = selectedIndex == itemIndex;
                        return ListTile(
                          onTap: () {
                            setState(() {
                              selectedIndex = itemIndex;
                            });
                            widget.onItemSelected(itemIndex);
                          },
                          leading: Icon(
                            item['icon'],
                            color: isSelected
                                ? Colors.deepPurple
                                : Colors.grey[700],
                          ),
                          title: Text(
                            item['title'],
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.deepPurple
                                  : Colors.grey[800],
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                          ),
                          tileColor: isSelected ? Colors.deepPurple[50] : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        );
                      }).toList(),
                  ],
                );
              }).toList(),
            ),
          ),
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
