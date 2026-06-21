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

class MyRequestsPage extends StatefulWidget {
  const MyRequestsPage({super.key});

  @override
  State<MyRequestsPage> createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage> {

  @override
  void initState() {
    super.initState();
    context.read<RequestCubit>().getAllRequests();
    context.read<RequestCubit>().getMonthlyStats();
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
    } else if (cleanType.contains('payroll') ||  cleanType.contains('inquiry')) {
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
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
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
                  leading: const Icon(Icons.visibility_outlined, color: Colors.blueAccent),
                  title: const Text("View Details", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
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
                  leading: const Icon(Icons.edit_outlined, color: Color(0xFF10B981)),
                  title: const Text("Edit Request", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                  onTap: () async {
                    Navigator.pop(context); 
                    
                    final String currentStatus = req.status?.toString().toUpperCase() ?? 'PENDING';
                    
                    if (currentStatus == 'PENDING') {
                      final result = await Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => NewRequestScreen(request: req),
                        ),
                      );
                      
                      if (!context.mounted) return; 
                      if (result == true) {
                        context.read<RequestCubit>().getAllRequests(); 
                        context.read<RequestCubit>().getMonthlyStats(); 
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("You cannot edit a request that is already $currentStatus."),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                ),
                const Divider(color: Colors.white10, indent: 60),

                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
                  title: const Text("Delete Request", style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pop(context); 
                    if (req.status?.toString().toUpperCase() == 'PENDING') {
                      context.read<RequestCubit>().deleteRequest(req.id);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("You can only delete requests that are still Pending.", style: TextStyle(color: Colors.white)),
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
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: ColorsApp.WhiteColor),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Text(
            "My Requests",
            style: TextStyle(color: ColorsApp.WhiteColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_none, color: ColorsApp.WhiteColor),
              onPressed: () {},
            ),
            BlocBuilder<LoginCubit, AuthState>(
              builder: (context, state) {
                String? userImageUrl;
                String userName = "Employee";
                if (state is AuthSuccess) {
                  userImageUrl = state.loginResponse.data?.user?.general?.avatar;
                  userName = state.loginResponse.data?.user?.general?.firstName ?? "Employee";
                  debugPrint("✅ تم العثور على حالة AuthSuccess ورابط الصورة هو: $userImageUrl");
                } else {
                  debugPrint("⚠️ الحالة الحالية للـ LoginCubit هي: ${state.runtimeType} وليست AuthSuccess!");
                }

                final String shortName = userName.isNotEmpty 
                    ? userName.trim().substring(0, 1).toUpperCase() 
                    : "E";
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0, top: 8.0, bottom: 8.0), 
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorsApp.blueColor.withOpacity(0.2),
                    ),
                    clipBehavior: Clip.antiAlias, 
                    child: (userImageUrl != null && userImageUrl.trim().isNotEmpty)
                        ? Image.network(
                            userImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text(
                                  shortName,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              shortName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      body: BlocConsumer<RequestCubit, RequestState>(
        listener: (context, state) {
          if (state is DeleteRequestSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Request deleted successfully", style: TextStyle(color: Colors.white)), 
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is DeleteRequestErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error, style: const TextStyle(color: Colors.white)), 
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        buildWhen: (previous, current) => true,
        builder: (context, state) {
          
          final stats = context.read<RequestCubit>().monthlyStats;
          final serverRequests = context.read<RequestCubit>().requests;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100, 
                  child: ListView(
                    scrollDirection: Axis.horizontal, 
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildSummaryCard("TOTAL", "${stats?.total ?? 0}", Colors.white),
                      const SizedBox(width: 12),
                      _buildSummaryCard("APPROVED", "${stats?.approved ?? 0}", const Color(0xFF10B981)),
                      const SizedBox(width: 12),
                      _buildSummaryCard("PENDING", "${stats?.pending ?? 0}", const Color(0xFFF59E0B)),
                      const SizedBox(width: 12),
                      _buildSummaryCard("REJECTED", "${stats?.rejected ?? 0}", const Color(0xFFEF4444)),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () async {
                      final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const NewRequestScreen()));
                      if (result == true) {
                        if (context.mounted) {
                          context.read<RequestCubit>().getAllRequests(); 
                          context.read<RequestCubit>().getMonthlyStats(); 
                        }
                      }
                    },
                    child: Center(
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 20),
                          SizedBox(width: 5,),
                          Text("New Request", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                if (state is GetRequestsLoadingState && serverRequests.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Center(child: CircularProgressIndicator(color: Colors.blue)),
                  )
                else if (state is GetRequestsErrorState && serverRequests.isEmpty)
                  Center(child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(state.error, style: const TextStyle(color: Colors.red)),
                  ))
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
                          requestType = req.type?.toString() ?? req.title?.toString() ?? ''; 
                        } catch (_) {
                          requestType = '';
                        }

                        final Color currentIconColor = _getColorForType(requestType);
                        final IconData currentIcon = _getIconForType(requestType);
                        final Color currentStatusColor = _getStatusColor(req.status?.toString() ?? 'PENDING');

                        return _buildRequestCard(
                          icon: currentIcon,
                          iconColor: currentIconColor,
                          title: req.title ?? "No Title",
                          priority: req.priority ?? "Medium", 
                          status: req.status ?? "PENDING",
                          statusColor: currentStatusColor,
                          date: "Oct 12", 
                          onTap: () => _showActionBottomSheet(context, req),
                        );
                      },
                    )
                  else
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: Text("No requests found", style: TextStyle(color: Colors.white60)),
                      ),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(String title, String count, Color valueColor) {
    return Container(
      width: 110, 
      padding: const EdgeInsets.all(16), 
      decoration: BoxDecoration(color: const Color(0xFF161D2D), borderRadius: BorderRadius.circular(12)), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.w600)), 
          const SizedBox(height: 8), 
          Text(count, style: TextStyle(color: valueColor, fontSize: 24, fontWeight: FontWeight.bold)),
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
            border: Border.all(
              color: statusColor.withOpacity(0.15), 
              width: 1,
            ),
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
                          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
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
                  Icon(Icons.flag_outlined, color: statusColor.withOpacity(0.7), size: 16),
                  const SizedBox(width: 6),
                  const Text("Priority: ", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text(
                    priority, 
                    style: TextStyle(
                      color: priority.toLowerCase() == 'high' ? Colors.redAccent : Colors.white70, 
                      fontSize: 12, 
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 12),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}