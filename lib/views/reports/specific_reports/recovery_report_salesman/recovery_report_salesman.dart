import 'dart:typed_data';
import 'dart:io';
import 'package:admin_dashboard_v3/Models/reports/recovey_salesman_report_model.dart';
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
                    'softwareCompanyName': 'OMGz',
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
      final PdfPageFormat format = params['format'] ?? PdfPageFormat.a4;

      final pdf = pw.Document();
      const rowsPerPage = 25;
      final salesmanChunks = _chunkList(salesmanReport, rowsPerPage);

      for (var chunk in salesmanChunks) {
        pdf.addPage(
          pw.MultiPage(
            pageFormat: format,
            build: (context) => [
              pw.Text(companyName,
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 4),
              pw.Text('Branch: $branchName',
                  style: const pw.TextStyle(fontSize: 12)),
              pw.Text(
                  'From: ${_formatDate(startDate)} To: ${_formatDate(endDate)}',
                  style: const pw.TextStyle(fontSize: 12)),
              pw.Text("Generated by: $generatedBy",
                  style: const pw.TextStyle(fontSize: 8)),
              pw.Divider(),
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
              pw.SizedBox(height: 16),
              pw.Align(
                alignment: pw.Alignment.bottomCenter,
                child: pw.Column(
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(softwareCompanyName,
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold)),
                        pw.BarcodeWidget(
                          data: 'https://www.omgzz.com',
                          barcode: pw.Barcode.qrCode(),
                          width: 50,
                          height: 50,
                        ),
                      ],
                    ),
                  ],
                ),
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

  static List<List<T>> _chunkList<T>(List<T> list, int chunkSize) {
    if (list.isEmpty) return [[]];

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
          'softwareCompanyName': 'OMGz',
          'format': PdfPageFormat.a4,
        },
      );

      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        throw Exception("Downloads directory not found");
      }

      final file = File(
          '${downloadsDir.path}/Salesman_Report_${_formatDate(startDate).replaceAll('/', '_')}_${_formatDate(endDate).replaceAll('/', '_')}.pdf');
      await file.writeAsBytes(pdfBytes);

      TLoader.successSnackBar(title: "PDF saved successfully!");
    } catch (e) {
      TLoader.errorSnackBar(title: "Failed to save PDF", message: e.toString());
      if (kDebugMode) {
        print('Error saving PDF: $e');
      }
    }
  }

  static pw.Widget _tableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(text,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
    );
  }

  static pw.Widget _tableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 10)),
    );
  }
}
