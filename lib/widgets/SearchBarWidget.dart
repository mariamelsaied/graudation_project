import 'package:flutter/material.dart';
import '../core/constants/colors_app.dart'; 

class SearchBarWidget extends StatelessWidget {
  final Function(String)? onChanged;

  const SearchBarWidget({Key? key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorsApp.secondaryBlueColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        onChanged: onChanged, 
        style: TextStyle(color: ColorsApp.WhiteColor),
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          hintStyle: TextStyle(color: ColorsApp.greyColor),
          prefixIcon: Icon(Icons.search, color: ColorsApp.greyColor, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}