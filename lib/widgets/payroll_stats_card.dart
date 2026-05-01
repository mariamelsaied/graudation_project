import 'package:flutter/material.dart';
import 'package:graduation_app/core/constants/colors_app.dart';

class PayrollStatsCard extends StatelessWidget {
  const PayrollStatsCard({super.key, required this.title, required this.amount});

  final String title;
  final String amount;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsApp.darknavyblueColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsApp.WhiteColor.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: ColorsApp.greyColor, fontSize: 13),
          ),
          SizedBox(height: 12,),
          Text(amount,style: TextStyle(
            color: ColorsApp.WhiteColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),)
        ],
      ),
    );
  }
}
