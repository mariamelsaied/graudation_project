import 'package:flutter/material.dart';
import '../core/constants/colors_app.dart';

class LeaveSearchBar extends StatelessWidget {
  final Function(String)? onChanged;

  const LeaveSearchBar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: ColorsApp.secondaryBlueColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search leave requests...",
          hintStyle: TextStyle(color: ColorsApp.greyColor, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: ColorsApp.greyColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
