import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/core/constants/colors_app.dart';
import 'package:graduation_app/cubit/auth_cubit.dart';
import 'package:graduation_app/cubit/auth_state.dart';
import 'package:graduation_app/cubit/payroll_cubit.dart';
import 'package:graduation_app/cubit/payroll_state.dart';
import 'package:graduation_app/widgets/payroll_chart_card.dart';
import 'package:graduation_app/widgets/payroll_list_card.dart';
import 'package:graduation_app/widgets/payroll_summary_cards.dart';
import 'package:graduation_app/widgets/side_menu.dart';

class PayrollPage extends StatefulWidget {
  const PayrollPage({super.key});

  @override
  State<PayrollPage> createState() => _PayrollPageState();
}

class _PayrollPageState extends State<PayrollPage>
    with SingleTickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  late TabController _tabController;

  final List<String> _shortMonthsNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final List<String> _tabsStatus = ["All", "Paid", "Pending"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      PayrollCubit.get(
        context,
      ).getMonthlySummary(month: _selectedDate.month, year: _selectedDate.year);
      PayrollCubit.get(context).getYearlyChart(year: _selectedDate.year);
      PayrollCubit.get(context).getPayrolls(page: 1, status: "All");
    });

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        PayrollCubit.get(
          context,
        ).getPayrolls(page: 1, status: _tabsStatus[_tabController.index]);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: ColorsApp.blueColor,
              onPrimary: Colors.white,
              surface: ColorsApp.secondaryBlueColor,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });

      PayrollCubit.get(
        context,
      ).getMonthlySummary(month: _selectedDate.month, year: _selectedDate.year);
      PayrollCubit.get(context).getYearlyChart(year: _selectedDate.year);
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        "${_selectedDate.day} ${_shortMonthsNames[_selectedDate.month - 1]} ${_selectedDate.year}";

    return Scaffold(
      backgroundColor: ColorsApp.darknavyblueColor,
      drawer: const SideMenu(currentPage: "Payroll"),
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
          "Payroll",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PayrollSummaryCards(),
            const SizedBox(height: 30),

            InkWell(
              onTap: () => _selectDate(context),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF161D2D),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: ColorsApp.blueColor,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            BlocBuilder<PayrollCubit, PayrollState>(
              buildWhen:
                  (previous, current) =>
                      current is PayrollChartLoadingState ||
                      current is PayrollChartSuccessState ||
                      current is PayrollChartErrorState,
              builder: (context, state) {
                if (state is PayrollChartSuccessState) {
                  return PayrollChartCard(chartData: state.chartData);
                } else if (state is PayrollChartErrorState) {
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
                  child: const CircularProgressIndicator(color: Colors.blue),
                );
              },
            ),

            const SizedBox(height: 30),

            TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicatorColor: ColorsApp.blueColor,
              labelColor: ColorsApp.blueColor,
              unselectedLabelColor: ColorsApp.greyColor,
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: EdgeInsets.zero,
              labelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: "All"),
                Tab(text: "Paid"),
                Tab(text: "Pending"),
              ],
            ),
            const SizedBox(height: 20),

            SizedBox(
              height: 530,
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: const [
                  PayrollListCard(statusFilter: "All"),
                  PayrollListCard(statusFilter: "Paid"),
                  PayrollListCard(statusFilter: "Pending"),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
        "Payroll",
        style: TextStyle(
          color: ColorsApp.WhiteColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_none, color: ColorsApp.WhiteColor),
          onPressed: () {},
        ),
        const Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
        ),
      ],
    );
  }
}
