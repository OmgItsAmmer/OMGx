import 'package:ecommerce_dashboard/Models/reports/sale_report_model.dart';
import 'package:ecommerce_dashboard/Models/reports/simple_pnl_report_model.dart';
import 'package:ecommerce_dashboard/Models/reports/upcoming_installments_report_model.dart';
import 'package:ecommerce_dashboard/Models/reports/overdue_installments_report_model.dart';
import 'package:ecommerce_dashboard/Models/account_book/account_book_model.dart';
import 'package:ecommerce_dashboard/Models/entity/entity_model.dart';
import 'package:ecommerce_dashboard/utils/constants/enums.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:ecommerce_dashboard/controllers/product/product_controller.dart';
import 'package:ecommerce_dashboard/controllers/salesman/salesman_controller.dart';
import 'package:ecommerce_dashboard/views/reports/specific_reports/pnl_report/pnLReportPage.dart';
import 'package:ecommerce_dashboard/views/reports/specific_reports/recovery_report_salesman/recovery_report_salesman.dart';
import 'package:ecommerce_dashboard/views/reports/specific_reports/simplePnLReport.dart';
import 'package:ecommerce_dashboard/views/reports/specific_reports/upcoming_installments_report/upcoming_installments_report.dart';
import 'package:ecommerce_dashboard/views/reports/specific_reports/overdue_installments_report/overdue_installments_report.dart';
import 'package:ecommerce_dashboard/views/reports/all_reports/widgets/account_book_report_dialog.dart';
import 'package:ecommerce_dashboard/views/reports/specific_reports/account_book_report/account_book_report_page.dart';
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
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import '../../Models/orders/order_item_model.dart';
import '../../Models/products/product_model.dart';
import '../../controllers/shop/shop_controller.dart';
import '../../controllers/product/product_controller.dart';
import '../../controllers/customer/customer_controller.dart';
import '../../controllers/salesman/salesman_controller.dart';
import '../../repositories/products/product_variants_repository.dart';

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

//Upcoming Installments Report
  RxList<UpcomingInstallmentsReportModel> upcomingInstallmentsReports =
      <UpcomingInstallmentsReportModel>[].obs;

//Overdue Installments Report
  RxList<OverdueInstallmentsReportModel> overdueInstallmentsReports =
      <OverdueInstallmentsReportModel>[].obs;

//Account Book Report by Entity
  RxList<AccountBookModel> accountBookReports = <AccountBookModel>[].obs;

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
      TLoaders.errorSnackBar(
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
      TLoaders.errorSnackBar(
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
                  TLoaders.errorSnackBar(title: "Please select a salesman.");
                  return;
                }

                // Validate the selected dates
                if (startDate == null || endDate == null) {
                  TLoaders.errorSnackBar(
                      title: "Please select a valid date range.");
                  return;
                }

                if (startDate!.isAfter(endDate!)) {
                  TLoaders.errorSnackBar(
                      title: "Start date cannot be after end date.");
                  return;
                }

                if (endDate!.isAfter(currentDate)) {
                  TLoaders.errorSnackBar(
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
      TLoaders.errorSnackBar(
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
      TLoaders.errorSnackBar(
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
      TLoaders.errorSnackBar(
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
      TLoaders.errorSnackBar(
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
                  TLoaders.errorSnackBar(
                      title: "Please select a valid date range.");
                  return;
                }

                if (startDate!.isAfter(endDate!)) {
                  TLoaders.errorSnackBar(
                      title: "Start date cannot be after end date.");
                  return;
                }

                if (endDate!.isAfter(currentDate)) {
                  TLoaders.errorSnackBar(
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
        TLoaders.errorSnackBar(title: e.toString());
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
        TLoaders.errorSnackBar(title: e.toString());
        print("Error: $e");
      }
    } finally {}
  }

  Future<void> fetchSimplePnLReport(
      DateTime startDate, DateTime endDate) async {
    try {
      final reports =
          await reportsRepository.fetchSimplePnLReport(startDate, endDate);
      simplePnLReports.assignAll(reports);
    } catch (e) {
      TLoaders.errorSnackBar(title: e.toString());
    }
  }

  void showSimplePnLReport(DateTime startDate, DateTime endDate) async {
    try {
      await fetchSimplePnLReport(startDate, endDate);
      Get.to(() => SimplePnLReportPage(reports: simplePnLReports));
    } catch (e) {
      TLoaders.errorSnackBar(title: e.toString());
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
                  TLoaders.errorSnackBar(
                      title: "Please select a valid date range.");
                  return;
                }

                if (startDate!.isAfter(endDate!)) {
                  TLoaders.errorSnackBar(
                      title: "Start date cannot be after end date.");
                  return;
                }

                if (endDate!.isAfter(currentDate)) {
                  TLoaders.errorSnackBar(
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

  void showUpcomingInstallmentsDialog(BuildContext context) {
    int selectedDays = 7; // Default to 7 days

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Upcoming Installments Report'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: 120,
                width: 300,
                child: Column(
                  children: [
                    const Text('Select number of days to look ahead:'),
                    const SizedBox(height: 16),
                    DropdownButton<int>(
                      isExpanded: true,
                      value: selectedDays,
                      items: [7, 15, 30, 60, 90].map((days) {
                        return DropdownMenuItem(
                          value: days,
                          child: Text('$days days'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDays = value!;
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
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                showUpcomingInstallmentsReport(selectedDays);
                Get.back();
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Generate Report'),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> showUpcomingInstallmentsReport(int daysAhead) async {
    try {
      await fetchUpcomingInstallmentsReport(daysAhead);
      Get.to(() => UpcomingInstallmentsReportPage(
            reports: upcomingInstallmentsReports,
            daysAhead: daysAhead,
          ));
    } catch (e) {
      TLoaders.errorSnackBar(title: e.toString());
    }
  }

  Future<void> fetchUpcomingInstallmentsReport(int daysAhead) async {
    try {
      // Debug calls to check data
      // if (kDebugMode) {
      //   print('Debugging installment data before fetching report...');
      //   await reportsRepository.debugInstallmentPayments();
      //   await reportsRepository.debugInstallmentPlans();
      //   await reportsRepository.debugSimpleUpcomingInstallments();
      // }

      upcomingInstallmentsReports.assignAll(
          await reportsRepository.fetchUpcomingInstallmentsReport(daysAhead));

      if (kDebugMode) {
        print(
            'Fetched ${upcomingInstallmentsReports.length} upcoming installments');
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: e.toString());
      if (kDebugMode) {
        print('Error fetching upcoming installments: $e');
      }
    }
  }

  Future<void> showOverdueInstallmentsReport() async {
    try {
      await fetchOverdueInstallmentsReport();
      Get.to(() =>
          OverdueInstallmentsReportPage(reports: overdueInstallmentsReports));
    } catch (e) {
      TLoaders.errorSnackBar(title: e.toString());
    }
  }

  Future<void> fetchOverdueInstallmentsReport() async {
    try {
      // Debug calls to check data
      if (kDebugMode) {
        print('Debugging installment data before fetching overdue report...');
        // await reportsRepository.debugInstallmentPayments();
      }

      overdueInstallmentsReports
          .assignAll(await reportsRepository.fetchOverdueInstallmentsReport());

      if (kDebugMode) {
        print(
            'Fetched ${overdueInstallmentsReports.length} overdue installments');
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: e.toString());
      if (kDebugMode) {
        print('Error fetching overdue installments: $e');
      }
    }
  }

  // Account Book Report by Entity Methods
  void showAccountBookReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AccountBookReportDialog(),
    );
  }

  Future<void> showAccountBookReportByEntity(
    EntityModel entity,
    EntityType entityType,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      await fetchAccountBookReportByEntity(
          entity.id!, entityType, startDate, endDate);

      // Navigate to the report page
      Get.to(() => AccountBookReportPage(
            reports: accountBookReports,
            entity: entity,
            entityType: entityType,
            startDate: startDate,
            endDate: endDate,
          ));
    } catch (e) {
      TLoaders.errorSnackBar(title: e.toString());
    }
  }

  Future<void> fetchAccountBookReportByEntity(
    int entityId,
    EntityType entityType,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      // Get the account book repository
      // For now, we'll use a placeholder - you'll need to add this method to the reports repository
      final accountBookData = await reportsRepository.fetchAccountBookByEntity(
        entityId: entityId,
        entityType: entityType.toString().split('.').last,
        startDate: startDate,
        endDate: endDate,
      );

      accountBookReports.assignAll(accountBookData);

      if (kDebugMode) {
        print('Fetched ${accountBookReports.length} account book entries');
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: e.toString());
      if (kDebugMode) {
        print('Error fetching account book report: $e');
      }
    }
  }

  // Thermal Printer Function for Order Receipt
  Future<void> printThermalReceipt(OrderModel order) async {
    try {
      // Generate receipt bytes using esc_pos_utils
      final List<int> receiptBytes = await _generateReceiptBytes(order);

      // TODO: Integrate with actual thermal printer hardware
      // For actual thermal printer integration, you would:
      // 1. Use flutter_thermal_printer package to connect to printer
      // 2. Send the receiptBytes to the printer
      // 3. Handle printer connection status and errors

      // Example integration code (uncomment when hardware is available):
      // final FlutterThermalPrinter printer = FlutterThermalPrinter();
      // bool isConnected = await printer.isConnected();
      // if (isConnected) {
      //   await printer.startPrint();
      //   await printer.printBytes(receiptBytes);
      //   await printer.endPrint();
      // }

      // TLoaders.successSnackBar(
      //   title: 'Receipt Generated',
      //   message:
      //       'Thermal receipt has been generated successfully. Ready for printing.',
      // );

      if (kDebugMode) {
        print('Receipt bytes generated: ${receiptBytes.length} bytes');
        print('To print: Send these bytes to thermal printer hardware');
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Print Error',
        message: 'Failed to generate receipt: ${e.toString()}',
      );
      if (kDebugMode) {
        print('Thermal printer error: $e');
      }
    }
  }

  // Helper method to generate receipt bytes
  Future<List<int>> _generateReceiptBytes(OrderModel order) async {
    final ShopController shopController = Get.find<ShopController>();
    final CustomerController customerController =
        Get.find<CustomerController>();
    final SalesmanController salesmanController =
        Get.find<SalesmanController>();

    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    // Print shop information
    bytes += generator.text(
      shopController.selectedShop?.value.shopname ?? 'Shop Name',
      styles: const PosStyles(
        bold: true,
        align: PosAlign.center,
      ),
    );
    bytes += generator.text(
      'Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.text(
      'Time: ${DateFormat('HH:mm:ss').format(DateTime.now())}',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.hr();

    // Print order details
    bytes += generator.text(
      'Order #${order.orderId}',
      styles: const PosStyles(bold: true),
    );
    bytes += generator.hr();

    // Print customer information
    final customer = customerController.selectedCustomer.value;
    if (customer.fullName != null && customer.fullName!.isNotEmpty) {
      bytes += generator.text(
        'Customer: ${customer.fullName}',
        styles: const PosStyles(bold: true),
      );
      if (customer.phoneNumber != null && customer.phoneNumber!.isNotEmpty) {
        bytes += generator.text(
          'Phone: ${customer.phoneNumber}',
          styles: const PosStyles(align: PosAlign.left),
        );
      }
      bytes += generator.text(''); // Empty line for spacing
    }

    // Print salesman information if available
    if (order.salesmanId != null) {
      final salesman = salesmanController.selectedSalesman?.value;
      if (salesman != null &&
          salesman.fullName != null &&
          salesman.fullName!.isNotEmpty) {
        bytes += generator.text(
          'Salesman: ${salesman.fullName}',
          styles: const PosStyles(bold: true),
        );
        bytes += generator.text(''); // Empty line for spacing
      }
    }

    bytes += generator.hr();

    // Print items - use the order items that are already loaded
    for (var item in order.orderItems ?? []) {
      // Get product information from ProductController
      final product = productController.allProducts.firstWhere(
        (product) => product.productId == item.productId,
        orElse: () => ProductModel(name: 'Not Found'),
      );

      // Get product display name with variant if available
      String displayName = await _getProductDisplayName(product, item);

      // Print item details
      bytes += generator.text(
        displayName,
        styles: const PosStyles(bold: true),
      );
      bytes += generator.text(
        '${item.quantity} x Rs. ${item.price.toStringAsFixed(2)} = Rs. ${(item.quantity * item.price).toStringAsFixed(2)}',
        styles: const PosStyles(align: PosAlign.right),
      );
      bytes += generator.text(''); // Empty line for spacing
    }

    bytes += generator.hr();

    // Calculate totals
    final subTotal = order.subTotal;
    final discountAmount = subTotal * (order.discount / 100);
    final tax = order.tax;
    final shippingFee = order.shippingFee;

    // Calculate commission
    double commissionAmount = 0.0;
    if (order.salesmanComission != null && order.salesmanComission! > 0) {
      final commissionBase = subTotal - discountAmount;
      commissionAmount = commissionBase * order.salesmanComission! / 100;
    }

    // Print totals
    bytes += generator.row([
      PosColumn(text: 'Subtotal:', width: 6),
      PosColumn(
        text: 'Rs. ${subTotal.toStringAsFixed(2)}',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    if (order.discount > 0) {
      bytes += generator.row([
        PosColumn(text: 'Discount:', width: 6),
        PosColumn(
          text: '${order.discount}% (Rs. ${discountAmount.toStringAsFixed(2)})',
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    bytes += generator.row([
      PosColumn(text: 'Tax:', width: 6),
      PosColumn(
        text: 'Rs. ${tax.toStringAsFixed(2)}',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(text: 'Shipping:', width: 6),
      PosColumn(
        text: 'Rs. ${shippingFee.toStringAsFixed(2)}',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    if (commissionAmount > 0) {
      bytes += generator.row([
        PosColumn(text: 'Commission:', width: 6),
        PosColumn(
          text: 'Rs. ${commissionAmount.toStringAsFixed(2)}',
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    bytes += generator.hr();

    // Calculate grand total
    final grandTotal =
        subTotal - discountAmount + tax + shippingFee + commissionAmount;

    bytes += generator.row([
      PosColumn(text: 'TOTAL:', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(
        text: 'Rs. ${grandTotal.toStringAsFixed(2)}',
        width: 6,
        styles: const PosStyles(bold: true, align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(text: 'Paid:', width: 6),
      PosColumn(
        text: 'Rs. ${(order.paidAmount ?? 0).toStringAsFixed(2)}',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    final change = (order.paidAmount ?? 0) - grandTotal;
    if (change != 0) {
      bytes += generator.row([
        PosColumn(text: 'Change:', width: 6),
        PosColumn(
          text: 'Rs. ${change.toStringAsFixed(2)}',
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    bytes += generator.hr();

    // Print footer
    bytes += generator.text(
      'Thank you for your purchase!',
      styles: const PosStyles(
        bold: true,
        align: PosAlign.center,
      ),
    );

    bytes += generator.text(
      'Please visit again',
      styles: const PosStyles(align: PosAlign.center),
    );

    bytes += generator.cut();

    return bytes;
  }

  // Helper method to get the product display name with variant if available
  Future<String> _getProductDisplayName(
      ProductModel product, OrderItemModel item) async {
    String displayName = product.name ?? 'Not Found';

    // Check if this item has a variant ID
    if (item.variantId != null) {
      try {
        final ProductVariantsRepository variantsRepository =
            Get.put(ProductVariantsRepository());
        // Fetch the variant information
        final variants = await variantsRepository
            .fetchProductVariants(product.productId ?? -1);
        final variant =
            variants.firstWhereOrNull((v) => v.variantId == item.variantId);

        if (variant != null) {
          // Append the variant name to the product name
          displayName = '$displayName (${variant.variantName})';
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching variant: $e');
        }
      }
    }

    return displayName;
  }
}
