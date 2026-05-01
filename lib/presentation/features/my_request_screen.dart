import 'package:flutter/material.dart';
import 'package:graduation_app/core/constants/colors_app.dart';
import 'package:graduation_app/widgets/main_layout.dart';

class MyRequestScreen extends StatelessWidget {
  const MyRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'My Requests',
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsApp.blueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: ColorsApp.WhiteColor,
                        size: 28,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "New Request",
                        style: TextStyle(
                          fontSize: 20,
                          color: ColorsApp.WhiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(),
          ],
        ),
      ),
    );
  }
}
