import 'package:flutter/material.dart';
import '../core/constants/colors_app.dart';

class PersonalInfoCard extends StatefulWidget {
  const PersonalInfoCard({super.key});

  @override
  State<PersonalInfoCard> createState() => _PersonalInfoCardState();
}

class _PersonalInfoCardState extends State<PersonalInfoCard> {
  bool isEditing = false;

  final TextEditingController nameController = TextEditingController(
    text: "Alex James Johnson",
  );
  final TextEditingController dobController = TextEditingController(
    text: "October 24, 1990",
  );
  final TextEditingController genderController = TextEditingController(
    text: "Male",
  );
  final TextEditingController nationalityController = TextEditingController(
    text: "American",
  );
  final TextEditingController maritalController = TextEditingController(
    text: "Single",
  );
  final TextEditingController ssnController = TextEditingController(
    text: "****-**-6789",
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
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
                "Personal Information",
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

          _buildInfoField("FULL NAME", nameController),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(child: _buildInfoField("DATE OF BIRTH", dobController)),
              Expanded(child: _buildInfoField("GENDER", genderController)),
            ],
          ),
          const SizedBox(height: 20),

          _buildInfoField("NATIONALITY", nationalityController),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildInfoField("MARITAL STATUS", maritalController),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SSN (LAST 4)",
                      style: TextStyle(
                        color: ColorsApp.greyColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold, 
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          ssnController.text,
                          style: TextStyle(
                            color: ColorsApp.WhiteColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.lock_outline,
                          color: ColorsApp.greyColor,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller) {
    return Column(
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
        const SizedBox(height: 8),
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
    );
  }
}
