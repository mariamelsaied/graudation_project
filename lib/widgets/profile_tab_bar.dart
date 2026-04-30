import 'package:flutter/material.dart';
import '../core/constants/colors_app.dart';

class ProfileTabBar extends StatelessWidget {
  const ProfileTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: ColorsApp.darknavyblueColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 15),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Personal",
                    style: TextStyle(
                      color: ColorsApp.blueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 2.5, 
                    width:
                        double
                            .infinity, 
                    decoration: BoxDecoration(
                      color: ColorsApp.blueColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1.5,
            width: double.infinity,
            color: ColorsApp.borderGrey.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}
