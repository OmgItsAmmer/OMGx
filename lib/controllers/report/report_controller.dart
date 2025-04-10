import 'package:admin_dashboard_v3/Models/reports/sale_report_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/controllers/salesman/salesman_controller.dart';
import 'package:admin_dashboard_v3/views/reports/specific_reports/recovery_report_salesman/recovery_report_salesman.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../Models/reports/recovey_salesman_report_model.dart';
import '../../Models/salesman/salesman_model.dart';
import '../../repositories/reports/reports_repository.dart';
import '../../views/reports/specific_reports/monthly_item_sale_report/monthly_item_sale_report.dart';


class ReportController extends GetxController {
  static ReportController get instance => Get.find();
 final  ReportsRepository reportsRepository = Get.put(ReportsRepository());
  final SalesmanController salesmanController = Get.find<SalesmanController>();



  //Product Profitability Report
  final selectedProduct = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  //Monthly Sales Report
  RxList<SalesReportModel> salesReports = <SalesReportModel>[].obs;




  //Recovery Report
  RxList<RecoveryReportModel> salesmanRecoveryData = <RecoveryReportModel>[].obs;


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


  void showMonthlyItemSaleReport(int month , int year) async {
    try {
      await fetchMonthlySalesReport(month , year);

      Get.to(() => MonthlySalesReportPage(
        salesReport: salesReports,
        month: month.toString() ,
        year: year.toString() ,
      ));

    }
    catch(e)
    {
      TLoader.errorSnackBar(title: 'fetchMonthlySalesReport' ,message: e.toString());
    }
  }




  Future<void> fetchMonthlySalesReport(int month, int year)  async {
  try {

    final salesReportData = await reportsRepository.fetchMonthlySalesReport(month: month , year: year ,);

    salesReports.assignAll(salesReportData);


  }
  catch(e)
    {
      TLoader.errorSnackBar(title: 'fetchMonthlySalesReport' ,message: e.toString());
    }

  }




  void showDateRangePickerDialog(BuildContext context) {
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
                    DropdownButton<String?>( // Change this to String?
                      value: selectedSalesmanId,
                      hint: const Text("Select Salesman"),
                      isExpanded: true,
                      items: salesmanController.allSalesman.map((SalesmanModel salesman) {
                        return DropdownMenuItem<String?>(
                          value: salesman.salesmanId.toString(), // Convert to String
                          child: Text(salesman.fullName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSalesmanId = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16), // Spacer between dropdown and picker
                    // Date Range Picker
                    SizedBox(
                      width: 300,
                      height: 250, // Adjust the height of the date picker
                      child: SfDateRangePicker(
                        view: DateRangePickerView.month,
                        selectionMode: DateRangePickerSelectionMode.range,
                        initialSelectedRange: PickerDateRange(currentDate, currentDate),
                        onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
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
                Get.back(); // Close the dialog without action
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
                  TLoader.errorSnackBar(title: "Please select a valid date range.");
                  return;
                }

                if (startDate!.isAfter(endDate!)) {
                  TLoader.errorSnackBar(title: "Start date cannot be after end date.");
                  return;
                }

                if (endDate!.isAfter(currentDate)) {
                  TLoader.errorSnackBar(title: "End date cannot exceed the current date.");
                  return;
                }

                // Call the function with selected start and end dates and salesmanId
                showRecoverySalesmanReport(startDate!, endDate!, int.parse(selectedSalesmanId!)); // Convert back if needed
                Get.back(); // Close the dialog after confirmation
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }


  void showRecoverySalesmanReport(DateTime startDate, DateTime endDate, int salesmanId) async {
    try {
      // Assuming fetchRecoverySalesmanReport is an async method
      await fetchRecoverySalesmanReport(startDate, endDate , salesmanId);

      Get.to(() => SalesmanReportPage(
        salesmanReport: salesmanRecoveryData,
        startDate: startDate,
        endDate: endDate,
      ));
    } catch (e) {
      TLoader.errorSnackBar(title: 'fetchRecoverySalesmanReport', message: e.toString());
    }
  }


  Future<void> fetchRecoverySalesmanReport(DateTime startDate, DateTime endDate, int salesmanId)  async {
    try {

      final salesmanRecoveryList = await reportsRepository.getSalesmanRecoveryReport(salesmanId: salesmanId , startDate: startDate, endDate: endDate, );

      salesmanRecoveryData.assignAll(salesmanRecoveryList);


    }
    catch(e)
    {
      TLoader.errorSnackBar(title: 'fetchRecoverySalesmanReport' ,message: e.toString());
      if (kDebugMode) {
        print(e);
      }
    }

  }





}
