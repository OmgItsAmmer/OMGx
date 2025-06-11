import 'dart:typed_data';
import 'dart:io';
import 'package:admin_dashboard_v3/Models/reports/recovey_salesman_report_model.dart';
import 'package:admin_dashboard_v3/views/reports/common/report_footer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../common/widgets/loaders/tloaders.dart';
import '../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../controllers/shop/shop_controller.dart';
import '../../../../controllers/user/user_controller.dart';

class SalesmanReportPage extends StatelessWidget {
  final List<RecoveryReportModel> salesmanReport;
  final DateTime startDate;
  final DateTime endDate;

  const SalesmanReportPage({
    required this.salesmanReport,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final ShopController shopController = Get.find<ShopController>();
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Salesman Report'),
        actions: [
          if (salesmanReport.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () async {
                await savePdf(context);
              },
            ),
        ],
      ),
      body: Center(
        child: TRoundedContainer(
          width: 1000,
          child: salesmanReport.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info_outline,
                          size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'No data available for this salesman in the selected date range.',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Get.back(),
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                )
              : PdfPreview(
                  build: (format) => generatePdfInBackground({
                    'salesmanReport': salesmanReport,
                    'startDate': startDate,
                    'endDate': endDate,
                    'companyName':
                        shopController.selectedShop?.value.shopname ??
                            'No Name',
                    'branchName': 'MAIN',
                    'generatedBy':
                        userController.currentUser.value.fullName ?? 'Admin',
                    'softwareCompanyName': shopController
                            .selectedShop?.value.softwareCompanyName ??
                        'OMGz',
                    'softwareWebsiteLink': shopController
                            .selectedShop?.value.softwareWebsiteLink ??
                        'https://www.omgz.com',
                    'softwareContactNo':
                        shopController.selectedShop?.value.softwareContactNo ??
                            '',
                    'format': PdfPageFormat.a4,
                  }),
                  loadingWidget: const TShimmerEffect(width: 80, height: 80),
                  canChangeOrientation: false,
                  canChangePageFormat: false,
                  canDebug: false,
                  initialPageFormat: PdfPageFormat.a4,
                  allowPrinting: true,
                  allowSharing: true,
                  pageFormats: const {
                    'A3': PdfPageFormat.a3,
                    'A4': PdfPageFormat.a4,
                    'A5': PdfPageFormat.a5,
                  },
                ),
        ),
      ),
    );
  }

  static Future<Uint8List> generatePdfInBackground(
      Map<String, dynamic> params) async {
    try {
      final List<RecoveryReportModel> salesmanReport =
          params['salesmanReport'] ?? [];
      final String companyName = params['companyName'] ?? 'Company';
      final String branchName = params['branchName'] ?? 'Branch';
      final DateTime startDate = params['startDate'] ?? DateTime.now();
      final DateTime endDate = params['endDate'] ?? DateTime.now();
      final String generatedBy = params['generatedBy'] ?? 'Admin';
      final String softwareCompanyName =
          params['softwareCompanyName'] ?? 'OMGz';
      final String softwareWebsiteLink = params['softwareWebsiteLink'] ?? '';
      final String softwareContactNo = params['softwareContactNo'] ?? '';
      final PdfPageFormat format = params['format'] ?? PdfPageFormat.a4;

      final pdf = pw.Document();
      const rowsPerPage = 25;
      final salesmanChunks = _chunkList(salesmanReport, rowsPerPage);

      for (var chunk in salesmanChunks) {
        pdf.addPage(
          pw.MultiPage(
            pageFormat: format,
            build: (context) => [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(companyName,
                      style: pw.TextStyle(
                          fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Salesman Recovery Report',
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Text('Branch: $branchName',
                  style: const pw.TextStyle(fontSize: 10)),
              pw.Text(
                  'From: ${_formatDate(startDate)} To: ${_formatDate(endDate)}',
                  style: const pw.TextStyle(fontSize: 10)),
              pw.Text("Generated by: $generatedBy",
                  style: const pw.TextStyle(fontSize: 10)),
              pw.Text('Date: ${_formatDate(DateTime.now())}',
                  style: const pw.TextStyle(fontSize: 10)),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1),
                  1: const pw.FlexColumnWidth(3),
                  2: const pw.FlexColumnWidth(2),
                  3: const pw.FlexColumnWidth(2),
                  4: const pw.FlexColumnWidth(2),
                  5: const pw.FlexColumnWidth(2),
                  6: const pw.FlexColumnWidth(1.5),
                  7: const pw.FlexColumnWidth(2),
                },
                children: [
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      _tableHeader('Order ID'),
                      _tableHeader('Salesman Name'),
                      _tableHeader('Customer Name'),
                      _tableHeader('Order Date'),
                      _tableHeader('Sale Price'),
                      _tableHeader('Order Type'),
                      _tableHeader('Commission %'),
                      _tableHeader('Commission (Rs)'),
                    ],
                  ),
                  for (var item in chunk)
                    pw.TableRow(
                      children: [
                        _tableCell(item.orderId?.toString() ?? 'N/A'),
                        _tableCell(item.salesmanName ?? 'N/A'),
                        _tableCell(item.customerName ?? 'N/A'),
                        _tableCell(_formatDate(item.orderDate)),
                        _tableCell(_formatCurrency(item.salePrice)),
                        _tableCell(item.orderType ?? 'N/A'),
                        _tableCell(_formatNumber(item.commissionPercent)),
                        _tableCell(_formatCurrency(item.commissionInRs)),
                      ],
                    ),
                ],
              ),
              pw.SizedBox(height: 20),
              // Calculate and add summary section
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                color: PdfColors.grey200,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Total Orders: ${salesmanReport.length}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'Total Commission: ${_formatCurrency(_calculateTotalCommission(salesmanReport))}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              // Add the footer with company information and signature box
              ReportFooter.buildReportFooter(
                signatureTitle: 'Signature by Sales Manager',
                softwareCompanyName: softwareCompanyName,
                softwareWebsiteLink: softwareWebsiteLink,
                softwareContactNo: softwareContactNo,
              ),
            ],
          ),
        );
      }

      return pdf.save();
    } catch (e) {
      if (kDebugMode) {
        print('Error generating PDF: $e');
      }
      // Return an empty PDF if there's an error
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (context) => pw.Center(
            child: pw.Text('Error generating report: $e',
                style: pw.TextStyle(color: PdfColors.red)),
          ),
        ),
      );
      return pdf.save();
    }
  }

  // Calculate total commission from all records
  static double _calculateTotalCommission(List<RecoveryReportModel> report) {
    return report.fold(0, (sum, item) => sum + (item.commissionInRs ?? 0));
  }

  // Helper method to format dates safely
  static String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    try {
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  // Helper method to format currency values safely
  static String _formatCurrency(double? value) {
    if (value == null) return 'Rs 0.00';
    try {
      return 'Rs ${value.toStringAsFixed(2)}';
    } catch (e) {
      return 'Rs 0.00';
    }
  }

  // Helper method to format number values safely
  static String _formatNumber(double? value) {
    if (value == null) return '0.00';
    try {
      return value.toStringAsFixed(2);
    } catch (e) {
      return '0.00';
    }
  }

  static pw.Widget _tableHeader(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      alignment: pw.Alignment.center,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 9,
        ),
      ),
    );
  }

  static pw.Widget _tableCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      alignment: pw.Alignment.center,
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 9),
      ),
    );
  }

  static List<List<T>> _chunkList<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }

  Future<void> savePdf(BuildContext context) async {
    final ShopController shopController = Get.find<ShopController>();
    final UserController userController = Get.find<UserController>();
    try {
      final pdfBytes = await compute(
        generatePdfInBackground,
        {
          'salesmanReport': salesmanReport,
          'startDate': startDate,
          'endDate': endDate,
          'companyName':
              shopController.selectedShop?.value.shopname ?? 'No Name',
          'branchName': 'MAIN',
          'generatedBy': userController.currentUser.value.fullName ?? 'Admin',
          'softwareCompanyName':
              shopController.selectedShop?.value.softwareCompanyName ?? 'OMGz',
          'softwareWebsiteLink':
              shopController.selectedShop?.value.softwareWebsiteLink ??
                  'https://www.omgz.com',
          'softwareContactNo':
              shopController.selectedShop?.value.softwareContactNo ?? '',
          'format': PdfPageFormat.a4,
        },
      );

      final directory = Platform.isIOS || Platform.isAndroid
          ? await getApplicationDocumentsDirectory()
          : await getDownloadsDirectory();

      final startDateStr = DateFormat('yyyyMMdd').format(startDate);
      final endDateStr = DateFormat('yyyyMMdd').format(endDate);
      final file = File(
          '${directory!.path}/Salesman_Report_${startDateStr}_to_${endDateStr}.pdf');
      await file.writeAsBytes(pdfBytes);

      TLoaders.successSnackBar(
        title: 'PDF Saved',
        message: 'File saved to: ${file.path}',
      );
    } catch (e) {
      TLoaders.errorSnackBar(
          title: "Failed to save PDF", message: e.toString());
    }
  }
}
