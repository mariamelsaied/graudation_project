import 'package:flutter/material.dart';
import '../core/constants/colors_app.dart';

class CustomTabsWidget extends StatelessWidget {
  final bool isMyTasksSelected;
  final ValueChanged<bool> onTabChanged;

  const CustomTabsWidget({
    Key? key,
    required this.isMyTasksSelected,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: ColorsApp.secondaryBlueColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(false),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !isMyTasksSelected ? ColorsApp.blueColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'All',
                  style: TextStyle(
                    color: !isMyTasksSelected ? ColorsApp.WhiteColor : ColorsApp.greyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(true),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isMyTasksSelected ? ColorsApp.blueColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'My',
                  style: TextStyle(
                    color: isMyTasksSelected ? ColorsApp.WhiteColor : ColorsApp.greyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}