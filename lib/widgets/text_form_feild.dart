import 'package:flutter/material.dart';
import 'package:graduation_app/core/constants/colors_app.dart';

class TextFormFeild extends StatelessWidget {
  const TextFormFeild({super.key, required this.text});

  final String text;
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: ColorsApp.WhiteColor),
      decoration: InputDecoration(
        // icon: Icon(Icons.search,color: ColorsApp.lightgreyColor,size: 22,),
        prefixIcon: Icon(Icons.search,color: ColorsApp.lightgreyColor,size: 20,),
        hintText: text,
        hintStyle: TextStyle(
        color: ColorsApp.lightgreyColor,
        fontSize: 16
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: ColorsApp.WhiteColor.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: ColorsApp.WhiteColor.withOpacity(0.1),
            width: 1.5,
          )
        )
      ),
    );
  }
}