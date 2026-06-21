import 'package:flutter/material.dart';

class FileUploadArea extends StatelessWidget {
  final String? pickedFileName;
  final VoidCallback onTap;

  const FileUploadArea({
    super.key,
    required this.pickedFileName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          color: const Color(0xFF0D121F),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Icon(
              pickedFileName == null ? Icons.cloud_upload_outlined : Icons.check_circle_outline,
              color: pickedFileName == null ? Colors.white.withOpacity(0.5) : Colors.green,
              size: 40,
            ),
            const SizedBox(height: 10),
            Text(
              pickedFileName ?? "Click to upload or drag and drop",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 5),
            if (pickedFileName == null)
              Text(
                "SVG, PNG, JPG OR PDF (MAX. 5MB)",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 10,
                ),
              ),
          ],
        ),
      ),
    );
  }
}