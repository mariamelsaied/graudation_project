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
        child: Column(
          children: [
            Expanded(
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
                                image: AssetImage('assets/images/staffly.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(text: "Staff", style: TextStyle(color: ColorsApp.blueColor)),
                                TextSpan(text: "ly", style: TextStyle(color: ColorsApp.WhiteColor)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildMenuItem(context, Icons.grid_view_rounded, "Dashboard", currentPage == "Dashboard", routeName: '/dashboard'),
                    _buildMenuItem(context, Icons.account_circle_outlined, "My Profile", currentPage == "My Profile", routeName: '/profile'),
                    _buildMenuItem(context, Icons.calendar_today_outlined, "Attendance", currentPage == "Attendance", routeName: '/attendance'),
                    _buildMenuItem(context, Icons.assignment_outlined, "My Requests", currentPage == "My Requests", routeName: '/request'),
                    _buildMenuItem(context, Icons.drafts, "Leaves", currentPage == "Leaves", routeName: '/leaves'),
                    _buildMenuItem(context, Icons.check_circle_outline, "My Tasks", currentPage == "My Tasks", routeName: '/tasks'),
                    _buildMenuItem(context, Icons.wallet, "Payroll", currentPage == "Payroll", routeName: '/payroll'),
                    _buildMenuItem(context, Icons.trending_up, "Performance", currentPage == "Performance", routeName: '/performance'),
                    _buildMenuItem(context, Icons.settings, "Setting", currentPage == "Setting", routeName: '/setting'),
                  ],
                ),
              ),
            ),
            const Divider(color: Colors.white10, thickness: 1),
            _buildMenuItem(
              context, 
              Icons.logout_rounded, 
              "Logout", 
              false, 
              routeName: '/login', 
              isLogout: true, // أضفنا باراميتر لتمييز لون الخروج
            ),
            const SizedBox(height: 15), // مسافة بسيطة من الحافة السفلية
          ],
        ),
      ),
    );
  }

  // الدالة المعدلة لتدعم لون تسجيل الخروج
  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    bool isActive, {
    required String? routeName,
    bool isLogout = false,
  }) {
    // تحديد الألوان بناءً على حالة الزر (نشط، خروج، أو عادي)
    Color contentColor;
    if (isLogout) {
      contentColor = Colors.redAccent;
    } else {
      contentColor = isActive ? ColorsApp.blueColor : ColorsApp.greyColor;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? ColorsApp.blueColor.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: contentColor, size: 22),
        title: Text(
          title,
          style: TextStyle(
            color: contentColor,
            fontSize: 15,
            fontWeight: isActive || isLogout ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        onTap: () {
          Navigator.pop(context); // غلق المنيو أولاً
          if (isActive || routeName == null) return;

          if (isLogout) {
            // عند الخروج نستخدم pushNamedAndRemoveUntil لمسح ذاكرة التنقل
            Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
          } else {
            Navigator.pushReplacementNamed(context, routeName);
          }
        },
      ),
    );
  }
}