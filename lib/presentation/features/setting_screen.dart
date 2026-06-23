import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/core/constants/colors_app.dart';
import 'package:graduation_app/core/constants/strings.dart';
import 'package:graduation_app/cubit/auth_cubit.dart';
import 'package:graduation_app/cubit/auth_state.dart';
import 'package:graduation_app/widgets/build_setting_item.dart';
import 'package:graduation_app/widgets/side_menu.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.darknavyblueColor,
      drawer: const SideMenu(currentPage: "Setting"),
      appBar:AppBar(
        backgroundColor: ColorsApp.darknavyblueColor,
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: ColorsApp.WhiteColor),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          "Setting",
          style: TextStyle(color: ColorsApp.WhiteColor, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          // تم تعديل هذا الجزء لإضافة الـ Badge بناءً على حالة الإشعارات
          Padding(
  padding: const EdgeInsets.only(top: 4.0, right: 8.0),
  child: Badge(
    // استخدمي isLabelVisible للتحكم في ظهورها بدلاً من التعديل في الـ alignment لو أمكن
    isLabelVisible: true, 
    backgroundColor: ColorsApp.redColor,
    smallSize: 9,
     alignment: AlignmentDirectional(0.5, -0.5), 
    // الـ Badge هنا تغلف الـ IconButton مباشرةً
    child: IconButton(
      icon: Icon(Icons.notifications_none, color: ColorsApp.WhiteColor),
      onPressed: () {
        Navigator.of(context).pushNamed('/notification');
      },
    ),
  ),
),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: BlocBuilder<LoginCubit, AuthState>(
              builder: (context, state) {
                String? avatarUrl;
                if (state is AuthSuccess) {
                  avatarUrl = state.loginResponse.data?.user?.general?.avatar;
                }

                return CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[800],
                  backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                      ? NetworkImage(avatarUrl)
                      : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                );
              },
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        children: [
          BuildSettingItem(
            icon: Icons.settings_outlined,
            title: "General",
            subtitle: "Language, theme, preferences",
            onTap: () {
             Navigator.pushNamed(context, '/gsetting');
            },
          ),
          BuildSettingItem(
            icon: Icons.help_outline_rounded,
            title: "Help & support",
            subtitle: "FAQs, contact support",
            onTap: () {
              Navigator.pushNamed(context, Strings.helpAndSupportSetting);
            },
          ),
          BuildSettingItem(
            icon: Icons.info_outline,
            title: "Legal & app information",
            subtitle: "Help center",
            onTap: () {
              Navigator.pushNamed(context, Strings.legalAppSetting);
            },
          ),
        ],
      ),
    );
  }
}