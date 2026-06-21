import 'package:flutter/material.dart';
import 'package:graduation_app/core/constants/colors_app.dart';
import 'package:graduation_app/models/request_model.dart';
import 'package:intl/intl.dart';

class RequestDetailsPage extends StatelessWidget {
  final RequestModel request;
  const RequestDetailsPage({super.key, required this.request});
  Color _getStatusColor(String status) {
    switch (status.trim().toUpperCase()) {
      case 'PENDING':
        return const Color(0xFFF59E0B);
      case 'REJECTED':
      case 'REFUSED':
        return const Color(0xFFEF4444); 
      case 'APPROVED':
      case 'SUCCESS':
      case 'ACCEPTED':
        return const Color(0xFF10B981); 
      default:
        return const Color(0xFFF59E0B);
    }
  }
  String _formatDate(String? isoString) {
    if (isoString == null) return "Unknown Date";
    try {
      final dateTime = DateTime.parse(isoString);
      return DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime);
    } catch (_) {
      return isoString.split('T').first; 
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(request.status ?? 'PENDING');

    return Scaffold(
      backgroundColor: ColorsApp.darknavyblueColor,
      appBar: AppBar(
        backgroundColor: ColorsApp.darknavyblueColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Request Details",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF161D2D),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: statusColor.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: ColorsApp.blueColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          request.type ?? "General",
                          style: TextStyle(color: ColorsApp.blueColor, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          (request.status ?? "PENDING").toUpperCase(),
                          style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    request.title ?? "No Title",
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.outlined_flag, color: Colors.grey, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "Priority: ${request.priority ?? 'Medium'}",
                        style: TextStyle(
                          color: request.priority?.toLowerCase() == 'high' ? Colors.redAccent : Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text("Description", style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF161D2D),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                request.description ?? "No details provided.",
                style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
              ),
            ),
            const SizedBox(height: 20),
            const Text("HR Response", style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: request.hrResponse?.text != null 
                    ? const Color(0xFF0F271E) 
                    : const Color(0xFF161D2D),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: request.hrResponse?.text != null ? const Color(0xFF10B981).withOpacity(0.3) : Colors.transparent,
                ),
              ),
              child: request.hrResponse?.text != null
                  ? Text(
                      request.hrResponse!.text!,
                      style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                    )
                  : const Row(
                      children: [
                        Icon(Icons.hourglass_empty_rounded, color: Colors.amber, size: 18),
                        SizedBox(width: 8),
                        Text(
                          "No response from HR yet.",
                          style: TextStyle(color: Colors.grey, fontSize: 14, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 24),
            Divider(color: Colors.white.withOpacity(0.05)),
            const SizedBox(height: 8),
            _buildTimelineDate("Created At", _formatDate(request.createdAt)),
            if (request.updatedAt != null) ...[
              const SizedBox(height: 10),
              _buildTimelineDate("Last Update", _formatDate(request.updatedAt)),
            ],
          ],
        ),
      ),
    );
  }
  Widget _buildTimelineDate(String label, String dateValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(dateValue, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}