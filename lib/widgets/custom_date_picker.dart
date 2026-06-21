import 'package:flutter/material.dart';

class CustomDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const CustomDatePicker({
    super.key,
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
        fillColor: const Color(0xFF0D121F),
        filled: true,
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.white, size: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: Color(0xFF2D62ED),
                  onPrimary: Colors.white,
                  surface: Color(0xFF161D2D), 
                  onSurface: Colors.white, 
                ),
                dialogBackgroundColor: const Color(0xFF0F172A), 
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          controller.text = "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
        }
      },
    );
  }
}