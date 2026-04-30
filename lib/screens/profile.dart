import 'package:flutter/material.dart';
import 'package:graduation_app/widgets/side_menu.dart';
import '../core/constants/colors_app.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_tab_bar.dart';
import '../widgets/personal_info_card.dart';
import '../widgets/contact_details_card.dart';
import '../widgets/address_card.dart';
import '../widgets/employment_card.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          ColorsApp.darknavyblueColor, 
      drawer: const SideMenu(
        currentPage: "My Profile",
      ),
      appBar: AppBar(
        backgroundColor: ColorsApp.darknavyblueColor,
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.menu, color: ColorsApp.WhiteColor),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
        title: Text(
          "My Profile",
          style: TextStyle(
            color: ColorsApp.WhiteColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: ColorsApp.WhiteColor),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[800], 
              backgroundImage: const AssetImage(
                'images/profile.png',
              ), 
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeaderCard(), 
            const ProfileTabBar(), 
            const PersonalInfoCard(), 
            const ContactDetailsCard(), 
            const AddressCard(), 
            const EmploymentCard(), 
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
