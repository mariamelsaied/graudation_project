import 'package:flutter/material.dart';
import '../core/constants/colors_app.dart';

class AddressCard extends StatefulWidget {
  const AddressCard({super.key});

  @override
  State<AddressCard> createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  bool isEditing = false;

  final TextEditingController
  residentialAddressController = TextEditingController(
    text:
        "123 Innovation Drive, Apt 4B\nSan Francisco, CA 94103\nUnited States",
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
                "Address",
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

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "CURRENT RESIDENTIAL ADDRESS",
                style: TextStyle(
                  color: ColorsApp.greyColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              isEditing
                  ? TextField(
                    controller: residentialAddressController,
                    maxLines: null,
                    style: TextStyle(color: ColorsApp.WhiteColor, fontSize: 15),
                    decoration: InputDecoration(
                      isDense: true,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorsApp.blueColor),
                      ),
                    ),
                  )
                  : Text(
                    residentialAddressController.text,
                    style: TextStyle(
                      color: ColorsApp.WhiteColor,
                      fontSize: 15,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
