import 'package:flutter/material.dart';
import '../../core/constants/colors_app.dart';

class LeaveDetailsScreen extends StatelessWidget {
  final dynamic leaveItem; 

  const LeaveDetailsScreen({super.key, required this.leaveItem});

  String _formatDate(String isoDate) {
    if (isoDate == null || isoDate.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(isoDate);
      return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return isoDate.split('T')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    String hrName = "HR";
    String? status;
    String? type;
    int? duration;
    String? startDate;
    String? endDate;
    String? reason;
    String? rejectReason;

    try {
      // إذا كان القادم عبارة عن Map أو يمكن تحويله لـ Map
      final Map<String, dynamic> itemMap = leaveItem is Map ? leaveItem : leaveItem.toJson();
      
      status = itemMap['status'];
      type = itemMap['type'];
      duration = itemMap['duration'];
      startDate = itemMap['startDate'];
      endDate = itemMap['endDate'];
      reason = itemMap['reason'];
      rejectReason = itemMap['rejectReason'];

      final hrData = itemMap['hrApprovedBy'] ?? itemMap['hrRejectedBy'];
      if (hrData != null) {
        final String firstName = hrData['firstName'] ?? '';
        final String lastName = hrData['lastName'] ?? '';
        if ("$firstName $lastName".trim().isNotEmpty) {
          hrName = "$firstName $lastName".trim();
        }
      }
    } catch (e) {
      // طريقة احتياطية مباشرة في حال كان كلاس الموديل لا يحتوي على toJson ولكنه يحتوي على الـ getters الأساسية
      status = leaveItem.status;
      type = leaveItem.type;
      duration = leaveItem.duration;
      startDate = leaveItem.startDate;
      endDate = leaveItem.endDate;
      reason = leaveItem.reason;
      // في حال ضربت hrApprovedBy هنا، الـ try-catch سيحمي التطبيق ويترك الاسم الافتراضي "HR Manager"
      try { rejectReason = leaveItem.rejectReason; } catch(_) {}
    }

    final currentStatus = status ?? 'Pending';
    final bool isRejected = currentStatus.toLowerCase() == 'rejected';

    return Scaffold(
      backgroundColor: ColorsApp.darknavyblueColor,
      appBar: AppBar(
        backgroundColor: ColorsApp.darknavyblueColor,
        elevation: 0,
        title: const Text(
          "Leave Details",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // كارت الحالة ونوع الإجازة
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF161D2D),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Chip(
                    label: Text(
                      currentStatus.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    backgroundColor: currentStatus.toLowerCase() == 'approved'
                        ? Colors.green.withOpacity(0.8)
                        : Colors.red.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "${type ?? 'N/A'} Leave",
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${duration ?? 0} ${duration == 1 ? 'Day' : 'Days'} Total",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            const Text(
              "Request Information",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // كارت عرض تفاصيل التواريخ والـ HR والسبب لطلبك
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF161D2D),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildDetailRow(Icons.calendar_today, "Start Date", _formatDate(startDate ?? '')),
                  const Divider(color: Colors.white12, height: 24),
                  _buildDetailRow(Icons.calendar_today_outlined, "End Date", _formatDate(endDate ?? '')),
                  const Divider(color: Colors.white12, height: 24),
                  _buildDetailRow(Icons.admin_panel_settings_outlined, isRejected ? "Rejected By (HR)" : "Approved By (HR)", hrName),
                  const Divider(color: Colors.white12, height: 24),
                  _buildDetailRow(
                    Icons.chat_bubble_outline, 
                    "Your Reason", 
                    reason ?? "No reason provided",
                  ),
                  
                  // يظهر سبب الرفض فقط إذا رُفضت الإجازة
                  if (isRejected) ...[
                    const Divider(color: Colors.white12, height: 24),
                    _buildDetailRow(
                      Icons.backspace_outlined, 
                      "HR Rejection Reason", 
                      rejectReason ?? "No reason specified by HR",
                      valueColor: Colors.redAccent,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value, {Color valueColor = Colors.white}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: ColorsApp.blueColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(color: valueColor, fontSize: 15, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ],
    );
  }
}