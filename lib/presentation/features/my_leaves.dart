import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/cubit/auth_cubit.dart';
import 'package:graduation_app/cubit/leave_cubit.dart';
import 'package:graduation_app/cubit/leave_state.dart';
import 'package:graduation_app/cubit/auth_state.dart';
import 'package:graduation_app/presentation/features/new_leave_application_screen.dart.dart';
import '../../core/constants/colors_app.dart';
import '../../widgets/side_menu.dart';
import '../../widgets/leave_balance_list.dart';
import '../../widgets/apply_leave_button.dart';
import '../../widgets/leave_request_card.dart';
import '../../widgets/leave_chart_cart.dart';
import 'leave_details_screen.dart'; // استيراد صفحة التفاصيل الجديدة

class MyLeavesPage extends StatefulWidget {
  const MyLeavesPage({super.key});

  @override
  State<MyLeavesPage> createState() => _MyLeavesPageState();
}

class _MyLeavesPageState extends State<MyLeavesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _statusFilters = [
    "All",
    "Pending",
    "Approved",
    "Rejected",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshAllData();
    });

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        LeaveCubit.get(
          context,
        ).getLeaves(page: 1, status: _statusFilters[_tabController.index]);
      }
    });
  }

  void _refreshAllData() {
    LeaveCubit.get(
      context,
    ).getLeaves(page: 1, status: _statusFilters[_tabController.index]);
    LeaveCubit.get(context).getYearlyChart(year: DateTime.now().year);
    LeaveCubit.get(context).getLeaveBalance();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(String isoDate) {
    if (isoDate.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(isoDate);
      return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return isoDate.split('T')[0];
    }
  }

  /// الـ Bottom Sheet الخاص بـ Approved و Rejected
  void _showDetailsBottomSheet(BuildContext context, dynamic leaveItem) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161D2D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.blue),
                  title: const Text(
                    "View Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx); // إغلاق الـ sheet
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                LeaveDetailsScreen(leaveItem: leaveItem),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showActionOptions(BuildContext context, dynamic leaveItem) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161D2D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.blue),
                  title: const Text(
                    "Edit Application",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                NewLeaveApplicationScreen(leaveItem: leaveItem),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text(
                    "Delete Request",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _confirmDelete(context, leaveItem);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, dynamic leaveItem) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1A2235),
            title: const Text(
              "Delete Request",
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              "Are you sure you want to delete this pending leave request?",
              style: TextStyle(color: Colors.grey),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(ctx);
                  LeaveCubit.get(
                    context,
                  ).deleteLeaveApplication(id: leaveItem.id ?? leaveItem.sId);
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LeaveCubit, LeaveState>(
      listenWhen:
          (previous, current) =>
              current is LeaveDeleteSuccessState ||
              current is LeaveDeleteErrorState,
      listener: (context, state) {
        if (state is LeaveDeleteSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          _refreshAllData();
        } else if (state is LeaveDeleteErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: ColorsApp.darknavyblueColor,
        drawer: const SideMenu(currentPage: "Leaves"),
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
            "My Leaves",
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
                            : const AssetImage(
                                  'assets/images/default_avatar.png',
                                )
                                as ImageProvider,
                  );
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                BlocBuilder<LeaveCubit, LeaveState>(
                  buildWhen:
                      (previous, current) =>
                          current is LeaveBalanceLoadingState ||
                          current is LeaveBalanceSuccessState ||
                          current is LeaveBalanceErrorState,
                  builder: (context, state) {
                    if (state is LeaveBalanceSuccessState) {
                      return LeaveBalanceList(balanceData: state.balanceData);
                    } else if (state is LeaveBalanceErrorState) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
                const ApplyLeaveButton(),
                const SizedBox(height: 20),
                BlocBuilder<LeaveCubit, LeaveState>(
                  buildWhen:
                      (previous, current) =>
                          current is LeaveChartLoadingState ||
                          current is LeaveChartSuccessState ||
                          current is LeaveChartErrorState,
                  builder: (context, state) {
                    if (state is LeaveChartSuccessState) {
                      return leaveChartCart(chartData: state.chartData);
                    } else if (state is LeaveChartErrorState) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    }
                    return Container(
                      height: 340,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF161D2D),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 25),

                TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  isScrollable: false,
                  indicatorColor: ColorsApp.blueColor,
                  labelColor: ColorsApp.blueColor,
                  unselectedLabelColor: ColorsApp.greyColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: EdgeInsets.zero,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: const [
                    Tab(text: "All Leaves"),
                    Tab(text: "Pending"),
                    Tab(text: "Approved"),
                    Tab(text: "Rejected"),
                  ],
                ),
                const SizedBox(height: 10),
                BlocBuilder<LeaveCubit, LeaveState>(
                  buildWhen: (previous, current) {
                    if (current is LeaveSubmitLoadingState ||
                        current is LeaveSubmitSuccessState ||
                        current is LeaveSubmitErrorState ||
                        current is LeaveChartLoadingState ||
                        current is LeaveChartSuccessState ||
                        current is LeaveChartErrorState ||
                        current is LeaveBalanceLoadingState ||
                        current is LeaveBalanceSuccessState ||
                        current is LeaveBalanceErrorState ||
                        current is LeaveDeleteLoadingState) {
                      return false;
                    }
                    return true;
                  },
                  builder: (context, state) {
                    if (state is LeaveLoadingState ||
                        state is LeaveInitialState) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );
                    }
                    if (state is LeaveErrorState) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    if (state is LeaveSuccessState) {
                      final leaves = state.leaves;
                      final pagination = state.pagination;

                      if (leaves.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Text(
                              "No leave requests found",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: leaves.length + 1,
                        itemBuilder: (context, index) {
                          if (index == leaves.length) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                top: 15,
                                bottom: 30,
                              ),
                              child: _buildDynamicPaginationBar(
                                context,
                                pagination,
                              ),
                            );
                          }

                          final item = leaves[index];

                          return GestureDetector(
                            onTap: () {
                              final currentStatus = item.status.toLowerCase();
                              if (currentStatus == 'pending') {
                                _showActionOptions(context, item);
                              } else if (currentStatus == 'approved' ||
                                  currentStatus == 'rejected') {
                                // هنا يفتح الـ bottom sheet الخاص بالتفاصيل
                                _showDetailsBottomSheet(context, item);
                              }
                            },
                            child: LeaveRequestCard(
                              title: "${item.type} Leave",
                              date: _formatDate(item.startDate),
                              days:
                                  "${item.duration} ${item.duration == 1 ? 'Day' : 'Days'} Total",
                              status: item.status,
                              statusColor:
                                  item.status.toLowerCase() == 'approved'
                                      ? Colors.green
                                      : item.status.toLowerCase() == 'pending'
                                      ? Colors.orange
                                      : Colors.red,
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicPaginationBar(BuildContext context, dynamic pagination) {
    int currentPage = pagination.currentPage;
    int totalPages = pagination.totalPages;

    if (totalPages <= 1) return const SizedBox.shrink();

    int startPage = currentPage - 1;
    if (startPage < 1) startPage = 1;

    int endPage = startPage + 2;
    if (endPage > totalPages) {
      endPage = totalPages;
      startPage = endPage - 2;
      if (startPage < 1) startPage = 1;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.chevron_left,
            color:
                currentPage > 1 ? Colors.white : Colors.grey.withOpacity(0.4),
            size: 20,
          ),
          onPressed:
              currentPage > 1
                  ? () => LeaveCubit.get(context).getLeaves(
                    page: currentPage - 1,
                    status: _statusFilters[_tabController.index],
                  )
                  : null,
        ),
        const SizedBox(width: 5),
        ...List.generate(endPage - startPage + 1, (index) {
          int pageNum = startPage + index;
          bool isActive = currentPage == pageNum;

          return GestureDetector(
            onTap: () {
              if (!isActive) {
                LeaveCubit.get(context).getLeaves(
                  page: pageNum,
                  status: _statusFilters[_tabController.index],
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: CircleAvatar(
                radius: 16,
                backgroundColor:
                    isActive ? ColorsApp.blueColor : Colors.transparent,
                child: Text(
                  "$pageNum",
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.grey,
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(width: 5),
        IconButton(
          icon: Icon(
            Icons.chevron_right,
            color:
                currentPage < totalPages
                    ? Colors.white
                    : Colors.grey.withOpacity(0.4),
            size: 20,
          ),
          onPressed:
              currentPage < totalPages
                  ? () => LeaveCubit.get(context).getLeaves(
                    page: currentPage + 1,
                    status: _statusFilters[_tabController.index],
                  )
                  : null,
        ),
      ],
    );
  }
}
