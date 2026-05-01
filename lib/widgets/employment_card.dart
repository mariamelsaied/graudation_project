import 'package:flutter/material.dart';
import '../core/constants/colors_app.dart';

class EmploymentCard extends StatelessWidget {
  const EmploymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorsApp.secondaryBlueColor, 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorsApp.borderGrey.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Employment",
            style: TextStyle(
              color: ColorsApp.WhiteColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),

          Text(
            "DEPARTMENT",
            style: TextStyle(
              color: ColorsApp.greyColor,
              fontSize: 11,
              fontWeight: FontWeight.bold, 
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: ColorsApp.blueColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Product & Design",
                style: TextStyle(
                  color: ColorsApp.WhiteColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "DATE JOINED",
                      style: TextStyle(
                        color: ColorsApp.greyColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Aug 15, 2021",
                      style: TextStyle(
                        color: ColorsApp.WhiteColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CONTRACT",
                      style: TextStyle(
                        color: ColorsApp.greyColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ColorsApp.greenColor.withOpacity(
                          0.1,
                        ), 
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: ColorsApp.greenColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "Full-Time",
                        style: TextStyle(
                          color: ColorsApp.greenColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
