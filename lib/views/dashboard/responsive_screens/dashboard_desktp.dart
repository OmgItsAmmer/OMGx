import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/icons/t_circular_icon.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:admin_dashboard_v3/views/orders/all_orders/table/order_table.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../controllers/dashboard/dashboard_controoler.dart';
import '../widgets/dashbord_card.dart';

class DashboardDesktop extends StatelessWidget {
  const DashboardDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.find<DashboardController>();

    return Expanded(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Heading
                Text(
                  'DashBoard',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),

                //Cards
                Row(
                  children: [
                    Expanded(
                        child: TDashBoardCard(
                      isLoading: dashboardController.isLoading,
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
                      subTitle:
                          'Compared to ${dashboardController.lastMonth.value}',
                      icon: (dashboardController.isCard1Profit.value)
                          ? Iconsax.arrow_up_3
                          : Iconsax.arrow_down,
                      color: (dashboardController.isCard1Profit.value)
                          ? Colors.green
                          : Colors.red,
                    )),
                    const SizedBox(
                      width: TSizes.spaceBtwItems,
                    ),
                    Expanded(
                        child: TDashBoardCard(
                      isLoading: dashboardController.isLoading,
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
                      subTitle:
                          'Compared to ${dashboardController.lastMonth.value}',
                      color: (dashboardController.isAverageOrderIncrease.value)
                          ? Colors.green
                          : Colors.red,
                      icon: (dashboardController.isAverageOrderIncrease.value)
                          ? Iconsax.arrow_up_3
                          : Iconsax.arrow_down,
                    )),
                    const SizedBox(
                      width: TSizes.spaceBtwItems,
                    ),
                    Expanded(
                      child: TDashBoardCard(
                        isLoading: dashboardController.isLoading,
                        iconWidget: const TCircularIcon(
                          width: 40,
                          height: 40,
                          backgroundColor: CupertinoColors.systemYellow,
                          icon: Iconsax.money,
                          color: TColors.white,
                        ),

                        value:
                            'Rs ${dashboardController.currentMonthProfit.value.toStringAsFixed(2)}', // ✅ Two decimal places
                        stats: dashboardController.card2Percentage.value,
                        title: 'Profit',
                        subTitle:
                            'Compared to ${dashboardController.lastMonth.value}',
                        icon: (dashboardController.isCard2Profit.value)
                            ? Iconsax.arrow_up_3
                            : Iconsax.arrow_down,
                        color: (dashboardController.isCard2Profit.value)
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    const SizedBox(
                      width: TSizes.spaceBtwItems,
                    ),
                    Expanded(
                        child: TDashBoardCard(
                      isLoading: dashboardController.isLoading,
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
                      subTitle:
                          'Compared to ${dashboardController.lastMonth.value}',
                      icon: (dashboardController.isCustomerIncrease.value)
                          ? Iconsax.arrow_up_3
                          : Iconsax.arrow_down,
                      color: (dashboardController.isCustomerIncrease.value)
                          ? Colors.green
                          : Colors.red,
                    )),
                    const SizedBox(
                      width: TSizes.spaceBtwItems,
                    ),
                  ],
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                //Graphs
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          //Bar Graph
                          TRoundedContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //TItle
                                Text(
                                  'Weekly Sales',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(
                                  height: TSizes.spaceBtwSections,
                                ),

                                //Graph
                                SizedBox(
                                  height: 400,
                                  child: BarChart(BarChartData(
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
                                          .map((entry) => BarChartGroupData(
                                                  x: entry.key,
                                                  barRods: [
                                                    BarChartRodData(
                                                        width: 30,
                                                        color: TColors.primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    TSizes.sm),
                                                        toY: entry.value)
                                                  ]))
                                          .toList(),
                                      groupsSpace: TSizes.spaceBtwItems,
                                      barTouchData: BarTouchData(
                                        touchTooltipData: BarTouchTooltipData(
                                            getTooltipColor: (_) =>
                                                TColors.secondary),
                                        touchCallback:
                                            TDeviceUtils.isDesktopScreen(
                                                    context)
                                                ? (barTouchEvent,
                                                    barTouchResponse) {}
                                                : null,
                                      ))),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: TSizes.spaceBtwSections,
                          ),
                          //Orders Table
                          TRoundedContainer(
                              padding:
                                  const EdgeInsets.all(TSizes.defaultSpace / 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Recent Orders',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
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
                    const SizedBox(
                      width: TSizes.spaceBtwSections,
                    ),
                    //PIE CHART
                    Expanded(
                      child: TRoundedContainer(
                        padding: const EdgeInsets.all(TSizes.defaultSpace),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title with custom icon
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFFF6E0),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Iconsax.status_up,
                                    color: Color(0xFFFFB800),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Orders Status',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // Pie Chart
                            Obx(() {
                              return SizedBox(
                                height: 280,
                                child: PieChart(
                                  PieChartData(
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 70,
                                    sections: [
                                      // Pending Orders (Blue)
                                      PieChartSectionData(
                                        value: dashboardController
                                            .pendingOrders.value
                                            .toDouble(),
                                        title:
                                            '${dashboardController.pendingOrders}',
                                        color: const Color(
                                            0xFF2196F3), // Bright blue
                                        radius: 100,
                                        titleStyle: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      // Completed Orders (Green)
                                      PieChartSectionData(
                                        value: dashboardController
                                            .completedOrders.value
                                            .toDouble(),
                                        title:
                                            '${dashboardController.completedOrders}',
                                        color: const Color(0xFF4CAF50), // Green
                                        radius: 100,
                                        titleStyle: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      // Cancelled Orders (Red)
                                      PieChartSectionData(
                                        value: dashboardController
                                            .cancelledOrders.value
                                            .toDouble(),
                                        title:
                                            '${dashboardController.cancelledOrders}',
                                        color: const Color(0xFFF44336), // Red
                                        radius: 100,
                                        titleStyle: const TextStyle(
                                          fontSize: 18,
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
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'Status',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'Orders',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'Total',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Divider(),

                                // Pending row
                                Obx(() => _buildStatusRow(
                                      'Pending',
                                      const Color(0xFF2196F3),
                                      dashboardController.pendingOrders.value,
                                      dashboardController.pendingAmount.value,
                                    )),

                                const Divider(),

                                // Completed row
                                Obx(() => _buildStatusRow(
                                      'Completed',
                                      const Color(0xFF4CAF50),
                                      dashboardController.completedOrders.value,
                                      dashboardController.completedAmount.value,
                                    )),

                                const Divider(),

                                // Cancelled row
                                Obx(() => _buildStatusRow(
                                      'Cancelled',
                                      const Color(0xFFF44336),
                                      dashboardController.cancelledOrders.value,
                                      dashboardController.cancelledAmount.value,
                                    )),

                                const Divider(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow(String status, Color color, int count, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  status,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
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
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '\$${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
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
            final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
            final index = value.toInt() % days.length;
            final day = days[index];
            return SideTitleWidget(space: 0, meta: meta, child: Text(day));
          },
        ),
      ),
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
          interval: 1, // Set this to a non-zero value
          reservedSize: 50,
        ),
      ),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}
