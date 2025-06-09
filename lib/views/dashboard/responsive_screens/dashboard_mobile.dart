import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/icons/t_circular_icon.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/orders/all_orders/table/order_table.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../controllers/dashboard/dashboard_controoler.dart';
import '../widgets/dashbord_card.dart';

class DashboardMobile extends StatelessWidget {
  const DashboardMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.find<DashboardController>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Heading
              Text(
                'DashBoard',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),

              //Cards in a column for mobile
              TDashBoardCard(
                isLoading: dashboardController.isLoading.value,
                iconWidget: const TCircularIcon(
                  width: 40,
                  height: 40,
                  backgroundColor: TColors.primary,
                  icon: Iconsax.box,
                  color: TColors.white,
                ),
                value:
                    'Rs ${dashboardController.currentMonthSales.value.toStringAsFixed(2)}',
                stats: dashboardController.card1Percentage.value,
                title: 'Sales Total',
                subTitle: 'Compared to ${dashboardController.lastMonth.value}',
                icon: (dashboardController.isCard1Profit.value)
                    ? Iconsax.arrow_up_3
                    : Iconsax.arrow_down,
                color: (dashboardController.isCard1Profit.value)
                    ? Colors.green
                    : Colors.red,
                cardState: dashboardController.salesCardState,
              ),

              const SizedBox(height: TSizes.spaceBtwItems),

              TDashBoardCard(
                isLoading: dashboardController.isLoading.value,
                iconWidget: const TCircularIcon(
                  width: 40,
                  height: 40,
                  backgroundColor: Colors.purple,
                  icon: Iconsax.receipt_item,
                  color: TColors.white,
                ),
                value:
                    'Rs ${dashboardController.averageOrderValue.value.toStringAsFixed(2)}',
                stats: dashboardController.averageOrderPercentage.value,
                title: 'Average Order Value',
                subTitle: 'Compared to ${dashboardController.lastMonth.value}',
                color: (dashboardController.isAverageOrderIncrease.value)
                    ? Colors.green
                    : Colors.red,
                icon: (dashboardController.isAverageOrderIncrease.value)
                    ? Iconsax.arrow_up_3
                    : Iconsax.arrow_down,
                cardState: dashboardController.avgOrderState,
              ),

              const SizedBox(height: TSizes.spaceBtwItems),

              TDashBoardCard(
                isLoading: dashboardController.isLoading.value,
                iconWidget: const TCircularIcon(
                  width: 40,
                  height: 40,
                  backgroundColor: CupertinoColors.systemYellow,
                  icon: Iconsax.money,
                  color: TColors.white,
                ),
                value:
                    'Rs ${dashboardController.currentMonthProfit.value.toStringAsFixed(2)}',
                stats: dashboardController.card2Percentage.value,
                title: 'Profit',
                subTitle: 'Compared to ${dashboardController.lastMonth.value}',
                icon: (dashboardController.isCard2Profit.value)
                    ? Iconsax.arrow_up_3
                    : Iconsax.arrow_down,
                color: (dashboardController.isCard2Profit.value)
                    ? Colors.green
                    : Colors.red,
                cardState: dashboardController.profitCardState,
              ),

              const SizedBox(height: TSizes.spaceBtwItems),

              TDashBoardCard(
                isLoading: dashboardController.isLoading.value,
                iconWidget: const TCircularIcon(
                  width: 40,
                  height: 40,
                  backgroundColor: Colors.green,
                  icon: Iconsax.people,
                  color: TColors.white,
                ),
                value: dashboardController.customerCount.value.toString(),
                stats: dashboardController.card4Percentage.value,
                title: 'Customers',
                subTitle: 'Compared to ${dashboardController.lastMonth.value}',
                icon: (dashboardController.isCustomerIncrease.value)
                    ? Iconsax.arrow_up_3
                    : Iconsax.arrow_down,
                color: (dashboardController.isCustomerIncrease.value)
                    ? Colors.green
                    : Colors.red,
                cardState: dashboardController.customerCardState,
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              // Bar Graph
              TRoundedContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Title
                    Text(
                      'Weekly Sales',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),

                    //Graph
                    SizedBox(
                      height: 250,
                      child: Obx(() {
                        // Check if data is still loading
                        if (dashboardController.chartState.value ==
                            DataFetchState.loading) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text("Loading chart data...")
                              ],
                            ),
                          );
                        }

                        // Chart data is ready
                        return BarChart(BarChartData(
                            titlesData: builtFlTitlesData(),
                            borderData: FlBorderData(
                                show: true,
                                border: const Border(
                                    top: BorderSide.none,
                                    right: BorderSide.none)),
                            gridData: const FlGridData(
                              show: true,
                              drawHorizontalLine: true,
                              drawVerticalLine: false,
                              horizontalInterval: 200,
                            ),
                            barGroups: dashboardController.weeklySales
                                .asMap()
                                .entries
                                .map((entry) =>
                                    BarChartGroupData(x: entry.key, barRods: [
                                      BarChartRodData(
                                          width: 15,
                                          color: TColors.primary,
                                          borderRadius:
                                              BorderRadius.circular(TSizes.sm),
                                          toY: entry.value)
                                    ]))
                                .toList(),
                            groupsSpace: TSizes.spaceBtwItems,
                            barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(
                                  getTooltipColor: (_) => TColors.secondary),
                            )));
                      }),
                    )
                  ],
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              // Pie Chart
              TRoundedContainer(
                padding: const EdgeInsets.all(TSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with custom icon
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFF6E0),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Iconsax.status_up,
                            color: Color(0xFFFFB800),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Orders Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Pie Chart
                    Obx(() {
                      // Check if data is still loading
                      if (dashboardController.pieChartState.value ==
                          DataFetchState.loading) {
                        return const SizedBox(
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text("Loading order statistics...")
                              ],
                            ),
                          ),
                        );
                      }

                      // If all order counts are zero
                      if (dashboardController.pendingOrders.value == 0 &&
                          dashboardController.completedOrders.value == 0 &&
                          dashboardController.cancelledOrders.value == 0) {
                        return const SizedBox(
                          height: 200,
                          child: Center(
                            child: Text("No order data available"),
                          ),
                        );
                      }

                      return SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 50,
                            sections: [
                              // Pending Orders (Blue)
                              PieChartSectionData(
                                value: dashboardController.pendingOrders.value
                                    .toDouble(),
                                title: '${dashboardController.pendingOrders}',
                                color: const Color(0xFF2196F3),
                                radius: 70,
                                titleStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              // Completed Orders (Green)
                              PieChartSectionData(
                                value: dashboardController.completedOrders.value
                                    .toDouble(),
                                title: '${dashboardController.completedOrders}',
                                color: const Color(0xFF4CAF50),
                                radius: 70,
                                titleStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              // Cancelled Orders (Red)
                              PieChartSectionData(
                                value: dashboardController.cancelledOrders.value
                                    .toDouble(),
                                title: '${dashboardController.cancelledOrders}',
                                color: const Color(0xFFF44336),
                                radius: 70,
                                titleStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 20),

                    // Table style legend
                    Column(
                      children: [
                        // Headers
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Status',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Orders',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Total',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Divider(),

                        // Status rows
                        Obx(() {
                          if (dashboardController.pieChartState.value ==
                              DataFetchState.loading) {
                            return const Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Loading order status data..."),
                                ),
                              ],
                            );
                          }

                          return Column(
                            children: [
                              _buildStatusRow(
                                'Pending',
                                const Color(0xFF2196F3),
                                dashboardController.pendingOrders.value,
                                dashboardController.pendingAmount.value,
                              ),
                              const Divider(),
                              _buildStatusRow(
                                'Completed',
                                const Color(0xFF4CAF50),
                                dashboardController.completedOrders.value,
                                dashboardController.completedAmount.value,
                              ),
                              const Divider(),
                              _buildStatusRow(
                                'Cancelled',
                                const Color(0xFFF44336),
                                dashboardController.cancelledOrders.value,
                                dashboardController.cancelledAmount.value,
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              // Orders Table
              TRoundedContainer(
                  padding: const EdgeInsets.all(TSizes.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Orders',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),
                      const OrderTable(),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow(String status, Color color, int count, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  status,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              count.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Rs ${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  FlTitlesData builtFlTitlesData() {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
            final index = value.toInt() % days.length;
            final day = days[index];
            return SideTitleWidget(space: 0, meta: meta, child: Text(day));
          },
        ),
      ),
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
          interval: 1,
          reservedSize: 40,
        ),
      ),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}
