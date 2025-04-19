import 'package:admin_dashboard_v3/Models/reports/sale_report_model.dart';
import 'package:admin_dashboard_v3/Models/reports/simple_pnl_report_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/controllers/salesman/salesman_controller.dart';
import 'package:admin_dashboard_v3/views/reports/specific_reports/pnl_report/pnLReportPage.dart';
import 'package:admin_dashboard_v3/views/reports/specific_reports/recovery_report_salesman/recovery_report_salesman.dart';
import 'package:admin_dashboard_v3/views/reports/specific_reports/simplePnLReport.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../Models/reports/pnl_report_model.dart';
import '../../Models/reports/recovey_salesman_report_model.dart';
import '../../Models/salesman/salesman_model.dart';
import '../../repositories/reports/reports_repository.dart';
import '../../views/reports/specific_reports/monthly_item_sale_report/monthly_item_sale_report.dart';
import '../../views/reports/specific_reports/products/all_product_report.dart';

class ReportController extends GetxController {
  static ReportController get instance => Get.find();
  final ReportsRepository reportsRepository = Get.put(ReportsRepository());
  final SalesmanController salesmanController = Get.find<SalesmanController>();
  final ProductController productController = Get.find<ProductController>();

  //Product Profitability Report
  final selectedProduct = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  //Monthly Sales Report
  RxList<SalesReportModel> salesReports = <SalesReportModel>[].obs;

  //Recovery Report
  RxList<SalesmanRecoveryModel> salesmanRecoveryData =
      <SalesmanRecoveryModel>[].obs;

  // Recovery Report for SalesmanReportPage
  RxList<RecoveryReportModel> salesmanDetailedReport =
      <RecoveryReportModel>[].obs;

  //PnL Report
  RxList<PnLReportModel> pnLreportList = <PnLReportModel>[].obs;

//Simple PnL Report
  RxList<SimplePnLReportModel> simplePnLReports = <SimplePnLReportModel>[].obs;

  //Monthly Sales Report
  void openMonthYearPicker(BuildContext context) {
    int selectedMonth = DateTime.now().month;
    int selectedYear = DateTime.now().year;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Month & Year'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: 150,
                width: 300,
                child: Column(
                  children: [
                    // Month Dropdown
                    DropdownButton<int>(
                      isExpanded: true,
                      value: selectedMonth,
                      items: List.generate(12, (index) {
                        return DropdownMenuItem(
                          value: index + 1,
                          child: Text(
                            DateFormat.MMMM().format(DateTime(0, index + 1)),
                          ),
                        );
                      }),
                      onChanged: (value) {
                        setState(() {
                          selectedMonth = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Year Dropdown
                    DropdownButton<int>(
                      isExpanded: true,
                      value: selectedYear,
                      items: List.generate(10, (index) {
                        final year = DateTime.now().year - index;
                        return DropdownMenuItem(
                          value: year,
                          child: Text(year.toString()),
                        );
                      }),
                      onChanged: (value) {
                        setState(() {
                          selectedYear = value!;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                showMonthlyItemSaleReport(
                  selectedMonth,
                  selectedYear,
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Confirm'),
              ),
            ),
          ],
        );
      },
    );
  }

  void showMonthlyItemSaleReport(int month, int year) async {
    try {
      await fetchMonthlySalesReport(month, year);

      Get.to(() => MonthlySalesReportPage(
            salesReport: salesReports,
            month: month.toString(),
            year: year.toString(),
          ));
    } catch (e) {
      TLoader.errorSnackBar(
          title: 'fetchMonthlySalesReport', message: e.toString());
    }
  }

  Future<void> fetchMonthlySalesReport(int month, int year) async {
    try {
      final salesReportData = await reportsRepository.fetchMonthlySalesReport(
        month: month,
        year: year,
      );

      salesReports.assignAll(salesReportData);
    } catch (e) {
      TLoader.errorSnackBar(
          title: 'fetchMonthlySalesReport', message: e.toString());
    }
  }

  void showDateRangePickerDialogSalesman(BuildContext context) {
    // Create initial values for start and end date (current date by default)
    DateTime currentDate = DateTime.now();
    DateTime? startDate;
    DateTime? endDate;
    String? selectedSalesmanId;

    // Show the date range picker dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Date Range"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: 300,
                height: 400, // Increased height to accommodate dropdown
                child: Column(
                  children: [
                    // Salesman Dropdown
                    DropdownButton<String?>(
                      // Change this to String?
                      value: selectedSalesmanId,
                      hint: const Text("Select Salesman"),
                      isExpanded: true,
                      items: salesmanController.allSalesman
                          .map((SalesmanModel salesman) {
                        return DropdownMenuItem<String?>(
                          value: salesman.salesmanId
                              .toString(), // Convert to String
                          child: Text(salesman.fullName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSalesmanId = value;
                        });
                      },
                    ),

                    const SizedBox(
                        height: 16), // Spacer between dropdown and picker
                    // Date Range Picker
                    SizedBox(
                      width: 300,
                      height: 250, // Adjust the height of the date picker
                      child: SfDateRangePicker(
                        view: DateRangePickerView.month,
                        selectionMode: DateRangePickerSelectionMode.range,
                        initialSelectedRange:
                            PickerDateRange(currentDate, currentDate),
                        onSelectionChanged:
                            (DateRangePickerSelectionChangedArgs args) {
                          if (args.value is PickerDateRange) {
                            setState(() {
                              startDate = args.value.startDate;
                              endDate = args.value.endDate;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without action
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Validate the selected salesman
                if (selectedSalesmanId == null) {
                  TLoader.errorSnackBar(title: "Please select a salesman.");
                  return;
                }

                // Validate the selected dates
                if (startDate == null || endDate == null) {
                  TLoader.errorSnackBar(
                      title: "Please select a valid date range.");
                  return;
                }

                if (startDate!.isAfter(endDate!)) {
                  TLoader.errorSnackBar(
                      title: "Start date cannot be after end date.");
                  return;
                }

                if (endDate!.isAfter(currentDate)) {
                  TLoader.errorSnackBar(
                      title: "End date cannot exceed the current date.");
                  return;
                }

                // Call the function with selected start and end dates and salesmanId
                showRecoverySalesmanReport(startDate!, endDate!,
                    int.parse(selectedSalesmanId!)); // Convert back if needed
                Get.back(); // Close the dialog after confirmation
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void showRecoverySalesmanReport(
      DateTime startDate, DateTime endDate, int salesmanId) async {
    try {
      // Fetch the detailed salesman report data
      await fetchSalesmanDetailedReport(startDate, endDate, salesmanId);

      // Navigate to the report page with the populated data
      Get.to(() => SalesmanReportPage(
            salesmanReport: salesmanDetailedReport,
            startDate: startDate,
            endDate: endDate,
          ));
    } catch (e) {
      TLoader.errorSnackBar(
          title: 'Error generating report', message: e.toString());
    }
  }

  Future<void> fetchSalesmanDetailedReport(
      DateTime startDate, DateTime endDate, int salesmanId) async {
    try {
      // Call the repository method to fetch detailed report data
      final detailedReportData =
          await reportsRepository.fetchSalesmanDetailedReport(
        salesmanId: salesmanId,
        startDate: startDate,
        endDate: endDate,
      );

      // Assign the fetched data to the RxList
      salesmanDetailedReport.assignAll(detailedReportData);

      if (kDebugMode) {
        print(
            "Fetched ${salesmanDetailedReport.length} detailed records for salesman $salesmanId");
      }
    } catch (e) {
      TLoader.errorSnackBar(
          title: 'Error fetching detailed report', message: e.toString());
      if (kDebugMode) {
        print("Error fetching detailed report: $e");
      }
      // Return an empty list in case of error
      salesmanDetailedReport.clear();
    }
  }

  // Keep the original method for fetching recovery summary data
  Future<void> fetchRecoverySalesmanReport(
      DateTime startDate, DateTime endDate, int salesmanId) async {
    try {
      final salesmanRecoveryList =
          await reportsRepository.fetchSalesmanRecoveryReport(
        salesmanId: salesmanId,
        startDate: startDate,
        endDate: endDate,
      );

      salesmanRecoveryData.assignAll(salesmanRecoveryList);
    } catch (e) {
      TLoader.errorSnackBar(
          title: 'fetchRecoverySalesmanReport', message: e.toString());
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void getStockSummaryReport() {
    try {
      //doing locally
      Get.to(() => StockSummaryReportPage(
            products: productController.allProducts,
          ));
    } catch (e) {
      TLoader.errorSnackBar(
          title: 'fetchRecoverySalesmanReport', message: e.toString());
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void showDateRangePickerDialogPnL(BuildContext context) {
    // Create initial values for start and end date (current date by default)
    DateTime currentDate = DateTime.now();
    DateTime? startDate;
    DateTime? endDate;

    // Show the date range picker dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Date Range"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: 300,
                height: 400, // Increased height to accommodate dropdown
                child: SizedBox(
                  width: 300,
                  height: 250,
                  child: SfDateRangePicker(
                    view: DateRangePickerView.month,
                    selectionMode: DateRangePickerSelectionMode.range,
                    initialSelectedRange:
                        PickerDateRange(currentDate, currentDate),
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                      if (args.value is PickerDateRange) {
                        setState(() {
                          startDate = args.value.startDate;
                          endDate = args.value.endDate;
                        });
                      }
                    },
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without action
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Validate the selected dates
                if (startDate == null || endDate == null) {
                  TLoader.errorSnackBar(
                      title: "Please select a valid date range.");
                  return;
                }

                if (startDate!.isAfter(endDate!)) {
                  TLoader.errorSnackBar(
                      title: "Start date cannot be after end date.");
                  return;
                }

                if (endDate!.isAfter(currentDate)) {
                  TLoader.errorSnackBar(
                      title: "End date cannot exceed the current date.");
                  return;
                }

                showProfitLossReport(startDate!, endDate!);
                Get.back();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  Future<void> showProfitLossReport(
      DateTime startDate, DateTime endDate) async {
    try {
      await fetchReportData(startDate, endDate);

      Get.to(() => PnLReportPage(
            reports: pnLreportList,
          ));
    } catch (e) {
      if (kDebugMode) {
        TLoader.errorSnackBar(title: e.toString());
        print("Error: $e");
      }
    }
  }

  // Fetch the report data
  Future<void> fetchReportData(DateTime startDate, DateTime endDate) async {
    try {
      final data =
          await reportsRepository.fetchPnLReportData(startDate, endDate);
      pnLreportList.assignAll(data);
    } catch (e) {
      if (kDebugMode) {
        TLoader.errorSnackBar(title: e.toString());
        print("Error: $e");
      }
    } finally {}
  }

  Future<void> fetchSimplePnLReport(
      DateTime startDate, DateTime endDate) async {
    try {
      simplePnLReports.assignAll(
          await reportsRepository.fetchSimplePnLReport(startDate, endDate));
    } catch (e) {
      TLoader.errorSnackBar(title: e.toString());
    }
  }

  void showSimplePnLReport(DateTime startDate, DateTime endDate) async {
    try {
      await fetchSimplePnLReport(startDate, endDate);
      Get.to(() => SimplePnLReportPage(reports: simplePnLReports));
    } catch (e) {
      TLoader.errorSnackBar(title: e.toString());
    }
  }

  void showDateRangePickerDialogSimplePnL(BuildContext context) {
    DateTime currentDate = DateTime.now();
    DateTime? startDate;
    DateTime? endDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Date Range"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: 300,
                height: 300,
                child: SfDateRangePicker(
                  view: DateRangePickerView.month,
                  selectionMode: DateRangePickerSelectionMode.range,
                  initialSelectedRange:
                      PickerDateRange(currentDate, currentDate),
                  onSelectionChanged:
                      (DateRangePickerSelectionChangedArgs args) {
                    if (args.value is PickerDateRange) {
                      setState(() {
                        startDate = args.value.startDate;
                        endDate = args.value.endDate;
                      });
                    }
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (startDate == null || endDate == null) {
                  TLoader.errorSnackBar(
                      title: "Please select a valid date range.");
                  return;
                }

                if (startDate!.isAfter(endDate!)) {
                  TLoader.errorSnackBar(
                      title: "Start date cannot be after end date.");
                  return;
                }

                if (endDate!.isAfter(currentDate)) {
                  TLoader.errorSnackBar(
                      title: "End date cannot exceed the current date.");
                  return;
                }

                showSimplePnLReport(startDate!, endDate!);
                Get.back();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }
}
