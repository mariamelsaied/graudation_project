import 'package:flutter/material.dart';
import 'package:graduation_app/core/constants/colors_app.dart';

class RequestItem extends StatelessWidget {
  RequestItem({
    super.key,
    required this.bgColor,
    required this.statusColor,
    required this.status,
    required this.date,
    required this.title,
    required this.image,
  });

  final Color bgColor;
  final Image image;
  final Color statusColor;
  final String status;
  final String date;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: image,
          ),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorsApp.WhiteColor,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 5),
              Text(
                date,
                style: TextStyle(color: ColorsApp.greyColor, fontSize: 12),
              ),
            ],
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                status,style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
