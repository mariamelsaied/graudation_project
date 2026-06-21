import 'package:flutter/material.dart';
import 'package:graduation_app/core/constants/colors_app.dart';
import 'package:graduation_app/widgets/legal_info.dart';

class LegalInfoScreen extends StatelessWidget {
  const LegalInfoScreen({super.key});

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
          "Legal & app information",
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
              LegalWidgets.sectionTitle("App information"),
              LegalWidgets.subHeader("Description"),
              LegalWidgets.paragraph(
                "The Waretrack Dashboard App is designed to streamline warehouse operations by providing real-time tracking, inventory management, order processing, and crew scheduling. It helps businesses improve efficiency, reduce errors, and enhance overall productivity.",
              ),
              const SizedBox(height: 20),
              
              Row(
                children: [
                  LegalWidgets.infoItem("App Name", "Waretrack Dashboard App"),
                  LegalWidgets.infoItem("Version", "5.02.221"),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  LegalWidgets.infoItem("Platform", "Dashboard & Phone"),
                  LegalWidgets.infoItem("Release Date", "20 Desember, 2024"),
                ],
              ),
              
              LegalWidgets.subHeader("Feature"),
              LegalWidgets.bulletItem("Employee Data Management"),
              LegalWidgets.bulletItem("Attendance & Time Tracking"),
              LegalWidgets.bulletItem("Leave & Time-Off Management"),
              LegalWidgets.bulletItem("Shift & Schedule Management"),
              LegalWidgets.bulletItem("Payroll Management"),
              const Divider(color: Colors.white10, height: 40),
              LegalWidgets.sectionTitle("Privacy policy"),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: ColorsApp.greyColor, fontSize: 13, height: 1.5),
                  children: [
                    const TextSpan(text: "Welcome to "),
                    const TextSpan(text: "Staffly Dashboard App.", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const TextSpan(text: "\nYour privacy is important, and this policy outlines how we collect, use, and protect your information."),
                  ],
                ),
              ),

              LegalWidgets.subHeader("Information we collect"),
              LegalWidgets.bulletItem("Personal: Name, email, phone number, login details."),
              LegalWidgets.bulletItem("Warehouse Data: Inventory, orders, shipments, crew schedules."),
              LegalWidgets.bulletItem("Device & Usage: IP address, browser type, analytics data."),

              LegalWidgets.subHeader("How we use your information"),
              LegalWidgets.bulletItem("Manage staffly operations."),
              LegalWidgets.bulletItem("Enhance security and system performance."),
              LegalWidgets.bulletItem("Provide notifications and support."),

              LegalWidgets.subHeader("Data sharing"),
              LegalWidgets.bulletItem("Authorized employee."),
              LegalWidgets.bulletItem("Third-party providers (hosting, analytics, support)."),
              LegalWidgets.bulletItem("Legal authorities if required."),

              LegalWidgets.subHeader("Security & retention"),
              LegalWidgets.bulletItem("Encryption, access controls, and regular audits."),
              LegalWidgets.bulletItem("Data retained as needed for operations and compliance."),

              LegalWidgets.subHeader("Your rights"),
              LegalWidgets.bulletItem("Access, update, or request data deletion."),
              LegalWidgets.bulletItem("Manage cookie preferences."),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}