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
            IconButton(
              icon: Icon(Icons.notifications_none, color: ColorsApp.WhiteColor),
              onPressed: () {},
            ),
            BlocBuilder<LoginCubit, AuthState>(
              builder: (context, state) {
                String? userImageUrl;
                String userName = "Employee";
                if (state is AuthSuccess) {
                  userImageUrl = state.loginResponse.data?.user?.general?.avatar;
                  userName = state.loginResponse.data?.user?.general?.firstName ?? "Employee";
                  debugPrint("✅ تم العثور على حالة AuthSuccess ورابط الصورة هو: $userImageUrl");
                } else {
                  debugPrint("⚠️ الحالة الحالية للـ LoginCubit هي: ${state.runtimeType} وليست AuthSuccess!");
                }

                final String shortName = userName.isNotEmpty 
                    ? userName.trim().substring(0, 1).toUpperCase() 
                    : "E";

                return Padding(
                  padding: const EdgeInsets.only(right: 12.0, top: 8.0, bottom: 8.0), // إعطاء مساحة مريحة على اليمين حافة الشاشة
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorsApp.blueColor.withOpacity(0.2),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: (userImageUrl != null && userImageUrl.trim().isNotEmpty)
                        ? Image.network(
                            userImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text(
                                  shortName,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              shortName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                );
              },
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
            icon: Icons.person_outline,
            title: "Account & security",
            subtitle: "Profile, password, privacy",
            onTap: () {
              
            },
          ),
          BuildSettingItem(
            icon: Icons.layers_outlined,
            title: "Access",
            subtitle: "Permission, roles, integration",
            onTap: () {},
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