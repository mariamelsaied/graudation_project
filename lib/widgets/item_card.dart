import 'package:flutter/material.dart';
import 'package:graduation_app/core/constants/colors_app.dart';

Widget itemCard(
  String text,
  String title,
  String sub,
  Color color,
  Image image,
) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: ColorsApp.darknavyblueColor,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: ColorsApp.WhiteColor.withOpacity(0.05)),
    ),
    // ⬇️ تم إزالة الـ Expanded من هنا وجعل الـ Column هو الابن المباشر
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 35, 
          width: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color.withValues(alpha: 0.15),
          ),
          child: Padding(padding: const EdgeInsets.all(8.0), child: image),
        ),
        const SizedBox(height: 20),
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: ColorsApp.lightgreyColor, fontSize: 10),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: ColorsApp.WhiteColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          sub,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: ColorsApp.lightgreyColor, fontSize: 10),
        ),
      ],
    ),
  );
}