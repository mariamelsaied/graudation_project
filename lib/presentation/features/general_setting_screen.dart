import 'package:flutter/material.dart';
import 'package:graduation_app/core/constants/colors_app.dart';

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen({super.key});

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  bool enableNotifications = true;
  bool notificationSound = true;
  bool doNotDisturb = false;
  bool emailNotifications = true;
  bool smsNotifications = false;
  bool inAppNotifications = true;
  bool pushNotifications = true;
  bool systemTheme = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.darknavyblueColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "General",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("General notifications"),
              _buildSwitchTile("Enable Notifications", "Turn all notifications on or off", enableNotifications, (val) {
                setState(() => enableNotifications = val);
              }),
              _buildSwitchTile("Notification Sound", "Play a sound when a new alert is received", notificationSound, (val) {
                setState(() => notificationSound = val);
              }),
              _buildSwitchTile("Do Not Disturb Mode", "Set quiet hours to mute notifications", doNotDisturb, (val) {
                setState(() => doNotDisturb = val);
              }),

              const Divider(color: Colors.white10, height: 40),
              _buildSectionHeader("Delivery methods"),
              _buildSwitchTile("Email Notifications", "Receive important system updates via email", emailNotifications, (val) {
                setState(() => emailNotifications = val);
              }),
              _buildSwitchTile("SMS Notifications", "Get critical alerts via text messages", smsNotifications, (val) {
                setState(() => smsNotifications = val);
              }),
              _buildSwitchTile("In-App Notifications", "View notifications directly within dashboard", inAppNotifications, (val) {
                setState(() => inAppNotifications = val);
              }),
              _buildSwitchTile("Push Notifications", "Receive real-time alerts on your mobile", pushNotifications, (val) {
                setState(() => pushNotifications = val);
              }),

              const Divider(color: Colors.white10, height: 40),
              _buildSectionHeader("Language & region"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("System Language", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                      Text("Choose the default language.", style: TextStyle(color: ColorsApp.greyColor, fontSize: 12)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFF1E2732), borderRadius: BorderRadius.circular(20)),
                    child: const Row(
                      children: [
                        Text("🇺🇸  English", style: TextStyle(color: Colors.white, fontSize: 13)),
                        Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18),
                      ],
                    ),
                  )
                ],
              ),

              const Divider(color: Colors.white10, height: 40),
              _buildSectionHeader("Theme"),
              _buildSwitchTile("System Theme", "Choose the theme dark/light mode", systemTheme, (val) {
                setState(() => systemTheme = val);
              }),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: ColorsApp.greyColor, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: ColorsApp.blueColor,
            inactiveTrackColor: Colors.grey.withOpacity(0.3),
          )
        ],
      ),
    );
  }
}