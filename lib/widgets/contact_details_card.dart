import 'package:flutter/material.dart';
import '../core/constants/colors_app.dart';

class ContactDetailsCard extends StatefulWidget {
  const ContactDetailsCard({super.key});

  @override
  State<ContactDetailsCard> createState() => _ContactDetailsCardState();
}

class _ContactDetailsCardState extends State<ContactDetailsCard> {
  bool isEditing = false;

  final TextEditingController workEmailController = TextEditingController(
    text: "alex.johnson@company.com",
  );
  final TextEditingController personalEmailController = TextEditingController(
    text: "alex.j.design@gmail.com",
  );
  final TextEditingController phoneController = TextEditingController(
    text: "+1 (555) 123-4567",
  );
  final TextEditingController mobileController = TextEditingController(
    text: "Not provided",
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorsApp.secondaryblueColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorsApp.borderGrey.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Contact Details",
                style: TextStyle(
                  color: ColorsApp.WhiteColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(
                  isEditing ? Icons.check : Icons.edit,
                  color: isEditing ? ColorsApp.greenColor : ColorsApp.greyColor,
                  size: 20,
                ),
                onPressed: () => setState(() => isEditing = !isEditing),
              ),
            ],
          ),
          const SizedBox(height: 25),

          _buildContactField(
            Icons.email_outlined,
            "WORK EMAIL",
            workEmailController,
            iconColor: ColorsApp.blueColor,
            boxColor: ColorsApp.blueColor.withOpacity(0.1), 
          ),
          const SizedBox(height: 22),

          _buildContactField(
            Icons.mail_outline,
            "PERSONAL EMAIL",
            personalEmailController,
          ),
          const SizedBox(height: 22),

          _buildContactField(
            Icons.phone_outlined,
            "PHONE NUMBER",
            phoneController,
          ),
          const SizedBox(height: 22),

          _buildContactField(
            Icons.smartphone_outlined,
            "WORK MOBILE",
            mobileController,
          ),
        ],
      ),
    );
  }

  Widget _buildContactField(
    IconData icon,
    String label,
    TextEditingController controller, {
    Color? iconColor,
    Color? boxColor,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment
              .center, 
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: boxColor ?? Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  (boxColor != null)
                      ? iconColor!.withOpacity(0.3)
                      : ColorsApp.borderGrey.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: iconColor ?? ColorsApp.greyColor,
            size: 22, 
          ),
        ),

        const SizedBox(width: 18),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: ColorsApp.greyColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              isEditing
                  ? TextField(
                    controller: controller,
                    style: TextStyle(color: ColorsApp.WhiteColor, fontSize: 15),
                    decoration: InputDecoration(
                      isDense: true,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorsApp.blueColor),
                      ),
                    ),
                  )
                  : Text(
                    controller.text,
                    style: TextStyle(
                      color: ColorsApp.WhiteColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
