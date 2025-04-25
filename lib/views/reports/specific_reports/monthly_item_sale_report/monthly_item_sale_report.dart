import 'dart:typed_data';
import 'dart:io';
import 'package:admin_dashboard_v3/controllers/shop/shop_controller.dart';
import 'package:admin_dashboard_v3/controllers/user/user_controller.dart';
import 'package:admin_dashboard_v3/views/reports/common/report_footer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

import '../../../../Models/reports/sale_report_model.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../common/widgets/loaders/tloaders.dart';
import '../../../../common/widgets/shimmers/shimmer.dart';

class MonthlySalesReportPage extends StatelessWidget {
  final List<SalesReportModel> salesReport;
  final String month;
  final String year; // 🔹 New field added

  const MonthlySalesReportPage({
    required this.salesReport,
    required this.month,
    required this.year, // 🔹 Added to constructor
  });

  @override
  Widget build(BuildContext context) {
    final ShopController shopController = Get.find<ShopController>();
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Item Sales Report'),
        actions: [
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
          child: salesReport.isEmpty
              ? const Text('No data to display')
              : PdfPreview(
                  build: (format) => generatePdfInBackground({
                    'salesReport': salesReport,
                    'month': month,
                    'year': year,
                    'companyName':
                        shopController.selectedShop?.value.shopname ??
                            'No Name',
                    'branchName': 'MAIN',
                    'generatedBy': userController.currentUser.value.fullName,
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
                  canChangePageFormat: true,
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
    final List<SalesReportModel> salesReport = params['salesReport'];
    final String companyName = params['companyName'];
    final String branchName = params['branchName'];
    final String month = params['month'];
    final String year = params['year']; // 🔹 Extract year
    final String generatedBy = params['generatedBy'];
    final String softwareCompanyName = params['softwareCompanyName'];
    final String softwareWebsiteLink = params['softwareWebsiteLink'];
    final String softwareContactNo = params['softwareContactNo'];
    final PdfPageFormat format = params['format'];

    final pdf = pw.Document();
    const rowsPerPage = 25;
    final salesChunks = _chunkList(salesReport, rowsPerPage);

    for (var chunk in salesChunks) {
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
                pw.Text('Monthly Item Sales Report',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Text('Branch: $branchName',
                style: const pw.TextStyle(fontSize: 10)),
            pw.Text('Month: $month, Year: $year',
                style: const pw.TextStyle(fontSize: 10)), // 🔹 Added year
            pw.Text("Generated by: $generatedBy",
                style: const pw.TextStyle(fontSize: 10)),
            pw.Text('Date: ${DateTime.now().toString().split(' ')[0]}',
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
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _tableHeader('ID'),
                    _tableHeader('Product Name'),
                    _tableHeader('Items Sold'),
                    _tableHeader('Profit'),
                    _tableHeader('Stock Remaining'),
                  ],
                ),
                for (var item in chunk)
                  pw.TableRow(
                    children: [
                      _tableCell(item.id.toString()),
                      _tableCell(item.name),
                      _tableCell(item.itemsSold.toString()),
                      _tableCell('Rs ${item.profit.toStringAsFixed(2)}'),
                      _tableCell(item.stockRemaining.toString()),
                    ],
                  ),
              ],
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
          'salesReport': salesReport,
          'month': month,
          'year': year, // 🔹 Add year here
          'companyName':
              shopController.selectedShop?.value.shopname ?? 'No Name',
          'branchName': 'MAIN',
          'generatedBy': userController.currentUser.value.fullName,
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

      final file = File(
          '${directory!.path}/Monthly_Sales_Report_${month}_$year.pdf'); // 🔹 Updated file name
      await file.writeAsBytes(pdfBytes);

      TLoader.successSnackBar(
        title: 'PDF Saved',
        message: 'File saved to: ${file.path}',
      );
    } catch (e) {
      TLoader.errorSnackBar(title: "Failed to save PDF", message: e.toString());
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
