import 'package:flutter/material.dart';
import 'package:graduation_app/core/constants/colors_app.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String title;

  MainLayout({required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu, color: ColorsApp.WhiteColor),
        ),
        title: Text(title, style: TextStyle(color: ColorsApp.WhiteColor)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications, color: ColorsApp.WhiteColor),
          ),
          CircleAvatar(
            radius: 14,
            backgroundColor: ColorsApp.purpleColor,
            child: Text(
              'JH',
              style: TextStyle(color: ColorsApp.WhiteColor, fontSize: 10),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [ColorsApp.darkblueColor, ColorsApp.darknavyblueColor],
          ),
        ),
        child: child,
      ),
    );
  }
}
