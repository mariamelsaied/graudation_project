import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/core/constants/colors_app.dart';
import 'package:graduation_app/cubit/payroll_cubit.dart';
import 'package:graduation_app/cubit/payroll_state.dart';

class PayrollSummaryCards extends StatelessWidget {
  const PayrollSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PayrollCubit, PayrollState>(
      buildWhen: (previous, current) =>
          current is PayrollMonthlySummaryLoadingState ||
          current is PayrollMonthlySummarySuccessState ||
          current is PayrollMonthlySummaryErrorState,
      builder: (context, state) {
        if (state is PayrollMonthlySummarySuccessState) {
          final data = state.summaryData; 
          final netData = data['summaryCards']['totalNetSalaries'];
          double netValue = (netData['value'] ?? 0).toDouble();
          double netPercentage = (netData['changePercentage'] ?? 0).toDouble();
          bool netIsIncrease = netData['isIncrease'] ?? false;
          final dedData = data['summaryCards']['totalDeductions'];
          double dedValue = (dedData['value'] ?? 0).toDouble();
          double dedPercentage = (dedData['changePercentage'] ?? 0).toDouble();
          bool dedIsIncrease = dedData['isIncrease'] ?? false;
          String paymentStatus = data['paymentStatus'] ?? "Pending";

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildSummaryCard(
                  title: "Net Salary",
                  amount: "\$${netValue.toInt()}", 
                  percentage: "${netPercentage.toStringAsFixed(1)}%",
                  hasArrow: true,
                  isIncrease: netIsIncrease,
                ),
                const SizedBox(width: 12),
                _buildSummaryCard(
                  title: "Deductions",
                  amount: "\$${dedValue.toInt()}", 
                  percentage: "${dedPercentage.toStringAsFixed(1)}%",
                  hasArrow: false,
                  isIncrease: dedIsIncrease,
                ),
                const SizedBox(width: 12),
                _buildStatusCard(status: paymentStatus),
              ],
            ),
          );
        } else if (state is PayrollMonthlySummaryErrorState) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildLoadingCard(),
              const SizedBox(width: 12),
              _buildLoadingCard(),
              const SizedBox(width: 12),
              _buildLoadingCard(),
            ],
          ),
        );
      },
    );
  }
  Widget _buildSummaryCard({
    required String title,
    required String amount,
    required String percentage,
    bool hasArrow = false,
    required bool isIncrease,
  }) {
    Color trendColor = isIncrease ? Colors.green : Colors.red;
    IconData trendIcon = isIncrease ? Icons.north_east : Icons.south_east;

    return Container(
      width: 175,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161D2D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              if (hasArrow) Icon(Icons.arrow_outward, color: ColorsApp.blueColor, size: 16)
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(trendIcon, color: trendColor, size: 12),
              const SizedBox(width: 4),
              Text(
                percentage,
                style: TextStyle(color: trendColor, fontSize: 12, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildStatusCard({required String status}) {
    bool isPaid = status.toLowerCase() == 'paid';
    Color statusColor = isPaid ? Colors.green : Colors.orange;
    IconData statusIcon = isPaid ? Icons.check_circle_outline : Icons.hourglass_empty_rounded;

    return Container(
      width: 175,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161D2D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Payment Status", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            status,
            style: TextStyle(color: statusColor, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 14),
              const SizedBox(width: 4),
              Text(
                isPaid ? "Completed" : "Action Required",
                style: TextStyle(color: statusColor.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildLoadingCard() {
    return Container(
      width: 175,
      height: 114,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161D2D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(color: Colors.blue, strokeWidth: 2),
        ),
      ),
    );
  }
}