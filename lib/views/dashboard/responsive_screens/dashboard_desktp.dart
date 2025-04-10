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
                          iconWidget: const TCircularIcon(
                            width: 40,
                            height: 40,
                            backgroundColor: TColors.primary,
                            icon: Iconsax.box,
                            color: TColors.white,
                          ),

                          value: 'Rs ${dashboardController.currentMonthSales.value.toStringAsFixed(2)}',
                      stats: dashboardController.card1Percentage.value ,
                      title: 'Sales Total',
                      subTitle: 'Compared to ${dashboardController.lastMonth.value}' ,
                          icon: (dashboardController.isCard1Profit.value ) ? Iconsax.arrow_up_3 : Iconsax.arrow_down,
                          color:(dashboardController.isCard1Profit.value) ? Colors.green : Colors.red ,
                    )),
                    const SizedBox(
                      width: TSizes.spaceBtwItems,
                    ),
                    Expanded(

                        child: TDashBoardCard(
                          iconWidget: const TCircularIcon(
                            width: 40,
                            height: 40,
                            backgroundColor: Colors.purple,
                            icon: Iconsax.receipt_item,
                            color: TColors.white,
                          ),
                          value: '',

                      stats: 25,
                      title: 'Average Order Value',
                      subTitle: '\$365.6',
                          color: (dashboardController.isCard1Profit.value )?Colors.green:Colors.red ,
                          icon: (dashboardController.isCard1Profit.value  ) ? Iconsax.arrow_up_3 : Iconsax.arrow_down,
                    )),
                    const SizedBox(
                      width: TSizes.spaceBtwItems,
                    ),
                    Expanded(
                      child: TDashBoardCard(
                        iconWidget: const TCircularIcon(
                          width: 40,
                          height: 40,
                          backgroundColor: CupertinoColors.systemYellow,
                          icon: Iconsax.money,
                          color: TColors.white,
                        ),



                        value: 'Rs ${dashboardController.currentMonthProfit.value.toStringAsFixed(2)}', // ✅ Two decimal places
                        stats: dashboardController.card2Percentage.value,
                        title: 'Profit',
                        subTitle: 'Compared to ${dashboardController.lastMonth.value}',
                        icon: (dashboardController.isCard2Profit.value) ? Iconsax.arrow_up_3 : Iconsax.arrow_down,
                        color: (dashboardController.isCard2Profit.value) ? Colors.green : Colors.red,
                      ),
                    ),

                    const SizedBox(
                      width: TSizes.spaceBtwItems,
                    ),
                     Expanded(
                        child: TDashBoardCard(
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
                          icon: (dashboardController.isCustomerIncrease.value) ? Iconsax.arrow_up_3 : Iconsax.arrow_down,
                          color: (dashboardController.isCustomerIncrease.value) ? Colors.green : Colors.red,
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
