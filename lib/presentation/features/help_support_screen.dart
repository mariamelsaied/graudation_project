import 'package:flutter/material.dart';
import 'package:graduation_app/core/constants/colors_app.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  
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
          "Help & support",
          style: TextStyle(
            color: Colors.white, 
            fontSize: 18, 
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Frequently Asked Questions",
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const FaqItem(
                question: "What is the Stafly App Dashboard?",
                answer: "The Stafly App Dashboard is an HR management platform designed to simplify employee administration processes, including attendance, leave requests, payroll, performance evaluation, and employee data — all in one integrated system.",
                initiallyExpanded: true,
              ),
              const FaqItem(
                question: "How do I log in to the Stafly Dashboard?",
                answer: "You can log in using your company email and the password provided by your HR department.",
              ),
              const FaqItem(
                question: "What are the main features of the HR dashboard?",
                answer: "Main features include real-time attendance tracking, automated payroll, and leave management.",
              ),
              const FaqItem(
                question: "How do I add a new employee?",
                answer: "Go to the Employees section and click the '+' button to add details.",
              ),
              const FaqItem(
                question: "Can I import employee data in bulk?",
                answer: "Yes, you can upload a CSV or Excel file through the Import Data section.",
              ),

              const SizedBox(height: 30),
              const Text(
                "Can't find what you're looking for?",
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildContactCard(
                icon: Icons.phone_enabled,
                title: "Call us",
                subtitle: "Need assistance? Call us now, We're here to assist you.",
                onTap: () {},
              ),
              _buildContactCard(
                icon: Icons.chat_bubble_rounded,
                title: "Chat us",
                subtitle: "Need quick answers? We're here to help in real time.",
                onTap: () {},
              ),
              _buildContactCard(
                icon: Icons.email_rounded,
                title: "Mail us",
                subtitle: "Have questions? Reach out us via email, we'll fast respond.",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildContactCard({
    required IconData icon, 
    required String title, 
    required String subtitle, 
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2732),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: ColorsApp.blueColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, 
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle, 
                    style: TextStyle(
                      color: ColorsApp.greyColor, 
                      fontSize: 13, 
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FaqItem extends StatefulWidget {
  final String question;
  final String answer;
  final bool initiallyExpanded;

  const FaqItem({
    super.key,
    required this.question,
    required this.answer,
    this.initiallyExpanded = false,
  });

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: widget.initiallyExpanded,
        onExpansionChanged: (bool expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        title: Text(
          widget.question,
          style: const TextStyle(
            color: Colors.white, 
            fontSize: 15, 
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          _isExpanded ? Icons.remove : Icons.add,
          color: Colors.white,
          size: 20,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 16, right: 16),
            child: Text(
              widget.answer,
              style: TextStyle(
                color: ColorsApp.greyColor, 
                fontSize: 13, 
                height: 1.5,
              ),
            ),
          ),
          const Divider(color: Colors.white10, height: 1),
        ],
      ),
    );
  }
}