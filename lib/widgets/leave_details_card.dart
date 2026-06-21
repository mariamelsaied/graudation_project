import 'package:flutter/material.dart';

class LeaveDetailsCard extends StatelessWidget {
  const LeaveDetailsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF1E293B);
    const inputColor = Color(0xFF0F172A);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Leave Details',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(color: Colors.grey, height: 24),
          _buildLabel('Leave Type'),
          DropdownButtonFormField<String>(
            dropdownColor: cardColor,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Select leave type'),
            items: const [], 
            onChanged: (value) {},
          ),
          const SizedBox(height: 16),
          _buildLabel('Start Date'),
          TextFormField(
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('mm/dd/yyyy'),
          ),
          const SizedBox(height: 16),
          _buildLabel('End Date'),
          TextFormField(
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('mm/dd/yyyy'),
          ),
          const SizedBox(height: 16),
          Text(
            'Estimated Duration',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: inputColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey[500], size: 18),
                const SizedBox(width: 8),
                Text(
                  'Select dates to calculate',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(text, style: TextStyle(color: Colors.grey[300], fontSize: 14)),
          const Text(' *', style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[600]),
      fillColor: const Color(0xFF0F172A),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
    );
  }
}