import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:graduation_app/models/attendance_model.dart';
import 'package:graduation_app/cubit/attendance_cubit.dart';
import '../core/constants/colors_app.dart';

class AttendanceHistoryList extends StatelessWidget {
  final List<AttendanceRecord>? logs;
  final Pagination? pagination;

  const AttendanceHistoryList({super.key, this.logs, this.pagination});

  String _formatDate(String isoDate) {
    try {
      return DateFormat('dd-MM-yyyy').format(DateTime.parse(isoDate));
    } catch (e) {
      return '-';
    }
  }

  String _formatTime(String isoDate) {
    try {
      return DateFormat('hh:mm a').format(DateTime.parse(isoDate));
    } catch (e) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF161D2D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(flex: 3, child: _buildHeader("Date")),
              Expanded(flex: 3, child: _buildHeader("Check-in")),
              Expanded(flex: 3, child: _buildHeader("Status")),
            ],
          ),
          const SizedBox(height: 16),
          if (logs == null || logs!.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text("No records", style: TextStyle(color: Colors.grey)),
            )
          else ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: logs!.length,
              separatorBuilder:
                  (_, __) => Divider(color: Colors.white.withOpacity(0.05)),
              itemBuilder: (context, index) {
                final item = logs![index];
                return Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        _formatDate(item.date),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        _formatTime(item.checkIn),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        item.status,
                        style: TextStyle(
                          color:
                              item.status == "On Time"
                                  ? Colors.green
                                  : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            if (pagination != null) ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      color:
                          pagination!.currentPage > 1
                              ? Colors.white
                              : Colors.grey,
                    ),
                    onPressed:
                        pagination!.currentPage > 1
                            ? () =>
                                AttendanceCubit.get(context).getAttendanceLogs(
                                  page: pagination!.currentPage - 1,
                                )
                            : null,
                  ),
                  Row(
                    children: List.generate(
                      pagination!.totalPages > 3 ? 3 : pagination!.totalPages,
                      (index) {
                        int page = index + 1;
                        if (pagination!.currentPage > 2) {
                          page = pagination!.currentPage - 1 + index;
                          if (page > pagination!.totalPages)
                            page = pagination!.totalPages - (2 - index);
                        }
                        bool isActive = pagination!.currentPage == page;

                        return GestureDetector(
                          onTap:
                              () => AttendanceCubit.get(
                                context,
                              ).getAttendanceLogs(page: page),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  isActive
                                      ? ColorsApp.blueColor
                                      : Colors.transparent,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "$page",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.chevron_right,
                      color:
                          pagination!.currentPage < pagination!.totalPages
                              ? Colors.white
                              : Colors.grey,
                    ),
                    onPressed:
                        pagination!.currentPage < pagination!.totalPages
                            ? () =>
                                AttendanceCubit.get(context).getAttendanceLogs(
                                  page: pagination!.currentPage + 1,
                                )
                            : null,
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(String title) =>
      Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12));
}
