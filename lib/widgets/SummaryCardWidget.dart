import 'package:flutter/material.dart';
import '../core/constants/colors_app.dart';

class SummaryCardWidget extends StatelessWidget {
  final String title;
  final String count;

  const SummaryCardWidget({Key? key, required this.title, required this.count})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsApp.pimaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: ColorsApp.greyColor, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              color: ColorsApp.WhiteColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}