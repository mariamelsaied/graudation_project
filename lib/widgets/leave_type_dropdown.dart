import 'package:flutter/material.dart';

class LeaveTypeDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const LeaveTypeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: value,
      onSelected: onChanged,
      expandedInsets: EdgeInsets.zero, 
      menuHeight: 200,
      textStyle: const TextStyle(color: Colors.white),
      trailingIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
      selectedTrailingIcon: const Icon(Icons.keyboard_arrow_up, color: Colors.white), // السهم يتقلب لفوق لما تفتح
      hintText: "Select leave type",
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
        fillColor: const Color(0xFF0D121F),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(const Color(0xFF1A2235)),
      ),
      dropdownMenuEntries: ["Annual", "Sick", "Casual","Unpaid"].map((type) {
        return DropdownMenuEntry<String>(
          value: type,
          label: type,
          style: MenuItemButton.styleFrom(
            foregroundColor: Colors.white, 
          ),
        );
      }).toList(),
    );
  }
}