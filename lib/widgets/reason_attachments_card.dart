import 'package:flutter/material.dart';

class ReasonAttachmentsCard extends StatelessWidget {
  const ReasonAttachmentsCard({Key? key}) : super(key: key);

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
            'Reason & Attachments',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(color: Colors.grey, height: 24),
          Row(
            children: [
              Text('Reason for Leave', style: TextStyle(color: Colors.grey[300], fontSize: 14)),
              const Text(' *', style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            maxLines: 4,
            maxLength: 500,
            style: const TextStyle(color: Colors.white),
            buildCounter: (context, {required currentLength, required isFocused, maxLength}) => Text(
              '$currentLength/$maxLength characters',
              style: TextStyle(color: Colors.grey[500], fontSize: 11),
            ),
            decoration: InputDecoration(
              hintText: 'Please describe the reason for your leave request...',
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              fillColor: inputColor,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Attachments (Optional)',
            style: TextStyle(color: Colors.grey[300], fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: inputColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.3), style: BorderStyle.solid),
            ),
            child: Column(
              children: [
                Icon(Icons.cloud_upload_outlined, color: Colors.grey[400], size: 32),
                const SizedBox(height: 12),
                Text(
                  'Click to upload or drag and drop',
                  style: TextStyle(color: Colors.grey[300], fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  'SVG, PNG, JPG OR PDF (MAX. 5MB)',
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}