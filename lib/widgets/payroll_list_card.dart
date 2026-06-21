import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/core/constants/colors_app.dart';
import 'package:graduation_app/cubit/payroll_cubit.dart';
import 'package:graduation_app/cubit/payroll_state.dart';

class PayrollListCard extends StatelessWidget {
  final String statusFilter; 

  const PayrollListCard({super.key, required this.statusFilter});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PayrollCubit, PayrollState>(
      builder: (context, state) {
        if (state is PayrollLoadingState) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }

        if (state is PayrollErrorState) {
          return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
        }

        if (state is PayrollSuccessState) {
          final payrolls = state.payrolls;
          final pagination = state.pagination;

          if (payrolls.isEmpty) {
            return const Center(
              child: Text("No payroll entries found", style: TextStyle(color: Colors.grey)),
            );
          }

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF161D2D),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: const [
                      Text(
                        "Payroll list",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: const [
                      Expanded(flex: 3, child: Text("Date", style: TextStyle(color: Colors.grey, fontSize: 13))),
                      Expanded(flex: 3, child: Text("Deduction", style: TextStyle(color: Colors.grey, fontSize: 13), textAlign: TextAlign.center)),
                      Expanded(flex: 3, child: Text("Net Salary", style: TextStyle(color: Colors.grey, fontSize: 13), textAlign: TextAlign.center)),
                      Expanded(flex: 3, child: Text("Status", style: TextStyle(color: Colors.grey, fontSize: 13), textAlign: TextAlign.center)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: payrolls.length,
                    itemBuilder: (context, index) {
                      final item = payrolls[index];
                      String period = "${item.month} / ${item.year}";
                      
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: index % 2 == 0 ? Colors.white.withOpacity(0.03) : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(period, style: const TextStyle(color: Colors.white, fontSize: 14)),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "\$${item.deductions.toInt()}", 
                                style: TextStyle(color: item.deductions > 0 ? Colors.redAccent : Colors.grey, fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "\$${item.netSalary.toInt()}", 
                                style: TextStyle(color: ColorsApp.blueColor, fontSize: 14, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: _buildStatusBadge(item.status),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 15),

                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    children: [
                      const TextSpan(text: "Showing: "),
                      TextSpan(
                        text: "${payrolls.length} ",
                        style: TextStyle(color: ColorsApp.blueColor, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: "of ${pagination.totalRecords} payroll entries"),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                _buildDynamicPaginationBar(context, pagination),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
  Widget _buildStatusBadge(String status) {
    Color baseColor;
    if (status.toLowerCase() == 'paid') {
      baseColor = const Color(0xFF00cc99);
    } else {
      baseColor = ColorsApp.blueColor; 
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: baseColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(100), 
        border: Border.all(color: baseColor.withOpacity(0.7), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: baseColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: baseColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicPaginationBar(BuildContext context, dynamic pagination) {
    int currentPage = pagination.currentPage;
    int totalPages = pagination.totalPages;

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
          icon: Icon(Icons.chevron_left, color: currentPage > 1 ? Colors.white : Colors.grey, size: 20),
          onPressed: currentPage > 1
              ? () => PayrollCubit.get(context).getPayrolls(page: currentPage - 1, status: statusFilter)
              : null,
        ),
        const SizedBox(width: 5),
        ...List.generate(endPage - startPage + 1, (index) {
          int pageNum = startPage + index;
          bool isActive = currentPage == pageNum;

          return GestureDetector(
            onTap: () {
              if (!isActive) {
                PayrollCubit.get(context).getPayrolls(page: pageNum, status: statusFilter);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: isActive ? ColorsApp.blueColor : Colors.transparent,
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
          icon: Icon(Icons.chevron_right, color: currentPage < totalPages ? Colors.white : Colors.grey, size: 20),
          onPressed: currentPage < totalPages
              ? () => PayrollCubit.get(context).getPayrolls(page: currentPage + 1, status: statusFilter)
              : null,
        ),
      ],
    );
  }
}