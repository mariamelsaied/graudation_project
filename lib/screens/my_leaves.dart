import 'package:flutter/material.dart';
import '../core/constants/colors_app.dart';
import '../widgets/side_menu.dart';
import '../widgets/leave_balance_list.dart';
import '../widgets/apply_leave_button.dart';
import '../widgets/leave_search_bar.dart';
import '../widgets/leave_request_card.dart';

class MyLeavesPage extends StatefulWidget {
  const MyLeavesPage({super.key});

  @override
  State<MyLeavesPage> createState() => _MyLeavesPageState();
}

class _MyLeavesPageState extends State<MyLeavesPage> {
  final List<Map<String, dynamic>> allLeavesData = [
    {
      "title": "Annual Leave",
      "date": "Oct 12 - Oct 15, 2023",
      "days": "3 Days Total",
      "status": "PENDING",
      "statusColor": Colors.orange,
    },
    {
      "title": "Sick Leave",
      "date": "Sep 05 - Sep 06, 2023",
      "days": "2 Days Total",
      "status": "APPROVED",
      "statusColor": Colors.green,
    },
    {
      "title": "Personal Leave",
      "date": "Aug 20, 2023",
      "days": "1 Day Total",
      "status": "REJECTED",
      "statusColor": Colors.red,
    },
    {
      "title": "Annual Leave",
      "date": "Jul 12 - Jul 20, 2023",
      "days": "8 Days Total",
      "status": "APPROVED",
      "statusColor": Colors.green,
    },
  ];

  List<Map<String, dynamic>> displayedLeaves = [];

  @override
  void initState() {
    super.initState();
    displayedLeaves = allLeavesData;
  }

  void _runSearch(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = allLeavesData;
    } else {
      results =
          allLeavesData
              .where(
                (leave) => leave["title"].toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
              )
              .toList();
    }

    setState(() {
      displayedLeaves = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
            IconButton(
              icon: Icon(Icons.notifications_none, color: ColorsApp.WhiteColor),
              onPressed: () {},
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage('images/profile.png'),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const LeaveBalanceList(),
              const SizedBox(height: 20),
              const ApplyLeaveButton(),
              const SizedBox(height: 15),

              LeaveSearchBar(onChanged: (value) => _runSearch(value)),

              const SizedBox(height: 20),
              TabBar(
                isScrollable: false,
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
                  Tab(text: "All Leaves"),
                  Tab(text: "Pending"),
                  Tab(text: "Approved"),
                  Tab(text: "Rejected"),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildLeaveListView(displayedLeaves),
                    _buildLeaveListView(
                      displayedLeaves
                          .where((l) => l["status"] == "PENDING")
                          .toList(),
                    ),
                    _buildLeaveListView(
                      displayedLeaves
                          .where((l) => l["status"] == "APPROVED")
                          .toList(),
                    ),
                    _buildLeaveListView(
                      displayedLeaves
                          .where((l) => l["status"] == "REJECTED")
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveListView(List<Map<String, dynamic>> dataList) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            LeaveRequestCard(
              title: dataList[index]["title"],
              date: dataList[index]["date"],
              days: dataList[index]["days"],
              status: dataList[index]["status"],
              statusColor: dataList[index]["statusColor"],
            ),
            if (index == dataList.length - 1) const SizedBox(height: 150),
          ],
        );
      },
    );
  }
}
