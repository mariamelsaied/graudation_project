import 'package:flutter/material.dart';
import '../core/constants/colors_app.dart';

class ProfileHeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ColorsApp.midnightBlueColor, ColorsApp.darknavyblueColor],
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 40),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: ColorsApp.secondaryBlueColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: ColorsApp.borderGrey.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: ColorsApp.borderGrey,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/profile.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),
                Text(
                  "Alex Johnson",
                  style: TextStyle(
                    color: ColorsApp.WhiteColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Senior Product Designer",
                  style: TextStyle(
                    color: ColorsApp.blueColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildChip(Icons.badge_outlined, "#EMP-2023-045"),
                    SizedBox(width: 10),
                    _buildChip(Icons.location_on_outlined, "San Francisco, CA"),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorsApp.borderGrey.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: ColorsApp.greyColor),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: ColorsApp.greyColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
