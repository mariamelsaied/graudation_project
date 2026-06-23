import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/core/constants/colors_app.dart';
import 'package:graduation_app/cubit/auth_cubit.dart';
import 'package:graduation_app/cubit/auth_state.dart';
import 'package:graduation_app/presentation/features/RequestDetailsPage.dart';
import 'package:graduation_app/presentation/features/new_request.dart';
import 'package:graduation_app/widgets/side_menu.dart';
import 'package:graduation_app/cubit/request_cubit.dart';
import 'package:graduation_app/cubit/request_state.dart';

// استيراد الموديلز للتأكد من التعرف على الموديل داخل الـ States
// import '../models/request_model.dart';

class MyRequestsPage extends StatefulWidget {
  const MyRequestsPage({super.key});

  @override
  State<MyRequestsPage> createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    context.read<RequestCubit>().getAllRequests();
    context.read<RequestCubit>().getMonthlyStats(
      month: _selectedDate.month,
      year: _selectedDate.year,
    );
  }

  IconData _getIconForType(String type) {
    final cleanType = type.trim().toLowerCase();
    if (cleanType.contains('hr')) {
      return Icons.calendar_month_outlined;
    } else if (cleanType.contains('it')) {
      return Icons.laptop_mac_outlined;
    } else if (cleanType.contains('complaint')) {
      return Icons.gavel_rounded;
    } else if (cleanType.contains('payroll') || cleanType.contains('inquiry')) {
      return Icons.payments_outlined;
    } else {
      return Icons.medical_services_outlined;
    }
  }

  Color _getColorForType(String type) {
    final cleanType = type.trim().toLowerCase();
    if (cleanType.contains('hr')) {
      return const Color(0xFFF59E0B);
    } else if (cleanType.contains('it')) {
      return const Color(0xFF10B981);
    } else if (cleanType.contains('payroll') || cleanType.contains('inquiry')) {
      return const Color(0xFF3B82F6);
    } else {
      return const Color(0xFFEF4444);
    }
  }

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

  void _showActionBottomSheet(BuildContext context, dynamic req) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111622),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 10.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.visibility_outlined,
                    color: Colors.blueAccent,
                  ),
                  title: const Text(
                    "View Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestDetailsPage(request: req),
                      ),
                    );
                  },
                ),
                const Divider(color: Colors.white10, indent: 60),
                ListTile(
                  leading: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF10B981),
                  ),
                  title: const Text(
                    "Edit Request",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);

                    final String currentStatus =
                        req.status?.toString().toUpperCase() ?? 'PENDING';

                    if (currentStatus == 'PENDING') {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewRequestScreen(request: req),
                        ),
                      );

                      if (!context.mounted) return;
                      if (result == true) {
                        _fetchData();
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "You cannot edit a request that is already $currentStatus.",
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                ),
                const Divider(color: Colors.white10, indent: 60),
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFEF4444),
                  ),
                  title: const Text(
                    "Delete Request",
                    style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    if (req.status?.toString().toUpperCase() == 'PENDING') {
                      context.read<RequestCubit>().deleteRequest(req.id);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "You can only delete requests that are still Pending.",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.amber,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.darknavyblueColor,
      drawer: const SideMenu(currentPage: "My Requests"),
      appBar: AppBar(
        backgroundColor: ColorsApp.darknavyblueColor,
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.menu, color: ColorsApp.WhiteColor),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
        title: Text(
          "My Requests",
          style: TextStyle(
            color: ColorsApp.WhiteColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0, right: 8.0),
            child: Badge(
              isLabelVisible: true,
              backgroundColor: ColorsApp.redColor,
              smallSize: 9,
              alignment: AlignmentDirectional(0.5, -0.5),
              child: IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: ColorsApp.WhiteColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/notification');
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: BlocBuilder<LoginCubit, AuthState>(
              builder: (context, state) {
                String? avatarUrl;
                if (state is AuthSuccess) {
                  avatarUrl = state.loginResponse.data?.user?.general?.avatar;
                }

                return CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[800],
                  backgroundImage:
                      (avatarUrl != null && avatarUrl.isNotEmpty)
                          ? NetworkImage(avatarUrl)
                          : const AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
                );
              },
            ),
          ),
        ],
      ),
      body: BlocConsumer<RequestCubit, RequestState>(
        listener: (context, state) {
          if (state is DeleteRequestSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Request deleted successfully",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
              ),
            );
            _fetchData();
          }
          if (state is DeleteRequestErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          // جلب الداتا المخزنة بشكل احتياطي داخل الكيوبيت
          var stats = context.read<RequestCubit>().monthlyStats;
          final serverRequests = context.read<RequestCubit>().requests;

          // تحديث متغير الـ stats محلياً إذا كان الستيت الحالي يحمل إحصائيات جديدة بنجاح
          if (state is GetRequestStatsSuccessState) {
            stats = state.stats;
          }

          return Column(
            children: [
              _buildHorizontalCalendar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1️⃣ هندلة حالة الـ Loading الخاصة بالـ Cards
                      if (state is GetRequestStatsLoadingState && stats == null)
                        const SizedBox(
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          ),
                        )
                      else if (state is GetRequestStatsErrorState &&
                          stats == null)
                        SizedBox(
                          height: 100,
                          child: Center(
                            child: Text(
                              state.error,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                              // textAlign: center,
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              _buildSummaryCard(
                                "TOTAL",
                                "${stats?.total ?? 0}",
                                Colors.white,
                              ),
                              const SizedBox(width: 12),
                              _buildSummaryCard(
                                "APPROVED",
                                "${stats?.approved ?? 0}",
                                const Color(0xFF10B981),
                              ),
                              const SizedBox(width: 12),
                              _buildSummaryCard(
                                "PENDING",
                                "${stats?.pending ?? 0}",
                                const Color(0xFFF59E0B),
                              ),
                              const SizedBox(width: 12),
                              _buildSummaryCard(
                                "REJECTED",
                                "${stats?.rejected ?? 0}",
                                const Color(0xFFEF4444),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsApp.blueColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NewRequestScreen(),
                              ),
                            );
                            if (result == true) {
                              _fetchData();
                            }
                          },
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 20),
                                SizedBox(width: 5),
                                Text(
                                  "New Request",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // 2️⃣ هندلة حالة الـ Loading الخاصة بقائمة الطلبات السفليّة
                      if (state is GetRequestsLoadingState &&
                          serverRequests.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          ),
                        )
                      else if (state is GetRequestsErrorState &&
                          serverRequests.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              state.error,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        )
                      else ...[
                        if (serverRequests.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: serverRequests.length,
                            itemBuilder: (context, index) {
                              final req = serverRequests[index];

                              String requestType = '';
                              try {
                                requestType =
                                    req.type?.toString() ??
                                    req.title?.toString() ??
                                    '';
                              } catch (_) {
                                requestType = '';
                              }

                              final Color currentIconColor = _getColorForType(
                                requestType,
                              );
                              final IconData currentIcon = _getIconForType(
                                requestType,
                              );
                              final Color currentStatusColor = _getStatusColor(
                                req.status?.toString() ?? 'PENDING',
                              );
                              final String formattedCardDate =
                                  _getFormattedDate(req);

                              return _buildRequestCard(
                                icon: currentIcon,
                                iconColor: currentIconColor,
                                title: req.title ?? "No Title",
                                priority: req.priority ?? "Medium",
                                status: req.status ?? "PENDING",
                                statusColor: currentStatusColor,
                                date: formattedCardDate,
                                onTap:
                                    () => _showActionBottomSheet(context, req),
                              );
                            },
                          )
                        else
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.0),
                              child: Text(
                                "No requests found",
                                style: TextStyle(color: Colors.white60),
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHorizontalCalendar() {
    final List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: ColorsApp.darknavyblueColor,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 12,
        itemBuilder: (context, index) {
          final isSelected = _selectedDate.month == (index + 1);
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = DateTime(_selectedDate.year, index + 1, 1);
              });
              _fetchData();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 75,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color:
                    isSelected ? ColorsApp.blueColor : const Color(0xFF161D2D),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? ColorsApp.blueColor : Colors.white10,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    months[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[400],
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "${_selectedDate.year}",
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Colors.grey[600],
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getFormattedDate(dynamic req) {
    final List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    try {
      final rawDate = req.createdAt ?? req.date;
      if (rawDate != null) {
        final parsedDate = DateTime.parse(rawDate.toString());
        return "${months[parsedDate.month - 1]} ${parsedDate.day}";
      }
    } catch (_) {}
    return "${months[_selectedDate.month - 1]} 01";
  }

  Widget _buildSummaryCard(String title, String count, Color valueColor) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161D2D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              color: valueColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String priority,
    required String status,
    required Color statusColor,
    required String date,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF161D2D),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: statusColor.withOpacity(0.15), width: 1),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1521),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: Colors.white10, height: 1),
              ),
              Row(
                children: [
                  Icon(
                    Icons.flag_outlined,
                    color: statusColor.withOpacity(0.7),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "Priority: ",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    priority,
                    style: TextStyle(
                      color:
                          priority.toLowerCase() == 'high'
                              ? Colors.redAccent
                              : Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
