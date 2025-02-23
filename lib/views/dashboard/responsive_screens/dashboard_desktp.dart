import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:admin_dashboard_v3/views/orders/all_orders/table/order_table.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                const Row(
                  children: [
                    Expanded(
                        child: TDashBoardCard(
                      stats: 25,
                      title: 'Sales Total',
                      subTitle: '\$365.6',
                    )),
                    const SizedBox(
                      width: TSizes.spaceBtwItems,
                    ),
                    Expanded(
                        child: TDashBoardCard(
                      stats: 25,
                      title: 'Sales Total',
                      subTitle: '\$365.6',
                    )),
                    const SizedBox(
                      width: TSizes.spaceBtwItems,
                    ),
                    Expanded(
                        child: TDashBoardCard(
                      stats: 25,
                      title: 'Sales Total',
                      subTitle: '\$365.6',
                    )),
                    const SizedBox(
                      width: TSizes.spaceBtwItems,
                    ),
                    Expanded(
                        child: TDashBoardCard(
                      stats: 25,
                      title: 'Sales Total',
                      subTitle: '\$365.6',
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
                          const SizedBox(height: TSizes.spaceBtwSections,),
                          //Orders Table
                          TRoundedContainer(
                              padding: const EdgeInsets.all(TSizes.defaultSpace/2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Recent Orders',
                                    style:
                                    Theme.of(context).textTheme.headlineSmall,
                                  ),
                                  const SizedBox(height: TSizes.spaceBtwItems,),
                                  const OrderTable(),
                                ],
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwSections,),
                    //PIE CHART
                    const Expanded(child: TRoundedContainer())
                  ],
                )
              ],
            ),
          ),
        ),
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
          showTitles: true,
          interval: 1, // Set this to a non-zero value
          reservedSize: 50,
        ),
      ),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}
