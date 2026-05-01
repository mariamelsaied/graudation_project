import 'package:flutter/material.dart';
import '../core/constants/colors_app.dart';

class SideMenu extends StatelessWidget {
  final String currentPage;

  const SideMenu({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorsApp.darknavyblueColor,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 20, bottom: 30),
                child: Row(
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('images/staffly.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: "Staff",
                            style: TextStyle(color: ColorsApp.blueColor),
                          ),
                          TextSpan(
                            text: "ly",
                            style: TextStyle(color: ColorsApp.WhiteColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              _buildMenuItem(
                context,
                Icons.grid_view_rounded,
                "Dashboard",
                currentPage == "Dashboard",
              ),
              _buildMenuItem(
                context,
                Icons.account_circle_outlined,
                "My Profile",
                currentPage == "My Profile",
              ),
              _buildMenuItem(
                context,
                Icons.calendar_today_outlined,
                "Attendance",
                currentPage == "Attendance",
              ),
              _buildMenuItem(
                context,
                Icons.date_range_outlined,
                "Leaves",
                currentPage == "Leaves",
              ),
              _buildMenuItem(
                context,
                Icons.assignment_outlined,
                "My Requests",
                currentPage == "My Requests",
              ),
              _buildMenuItem(
                context,
                Icons.check_circle_outline,
                "Tasks",
                currentPage == "Tasks",
              ),
              _buildMenuItem(
                context,
                Icons.notifications_none_outlined,
                "Notifications",
                currentPage == "Notifications",
              ),

              const SizedBox(height: 20), 
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    bool isActive,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color:
            isActive
                ? ColorsApp.blueColor.withOpacity(0.15)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? ColorsApp.blueColor : ColorsApp.greyColor,
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? ColorsApp.blueColor : ColorsApp.greyColor,
            fontSize: 15,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
