import 'package:flutter/material.dart';
import '../core/constants/colors_app.dart';

class ApplyLeaveButton extends StatelessWidget {
  const ApplyLeaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsApp.blueColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add, color: Colors.white, size: 22),
            SizedBox(width: 8),
            Text(
              "Apply New Leave",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
