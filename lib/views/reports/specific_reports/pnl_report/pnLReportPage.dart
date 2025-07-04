import 'dart:typed_data';
import 'dart:io';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/views/reports/common/report_footer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

import '../../../../Models/reports/pnl_report_model.dart';
import '../../../../controllers/shop/shop_controller.dart';
import '../../../../controllers/user/user_controller.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../common/widgets/shimmers/shimmer.dart';

class PnLReportPage extends StatelessWidget {
  final List<PnLReportModel> reports;

  // static String softwareCompanyEmail = 'info@omgz.com';

  const PnLReportPage({required this.reports});

  @override
  Widget build(BuildContext context) {
    final ShopController shopController = Get.find<ShopController>();
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profit & Loss Report'),
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
          child: reports.isEmpty
              ? const Text('No data to display')
              : PdfPreview(
                  build: (format) => generatePdfInBackground({
                    'reports': reports,
                    'companyName':
                        shopController.selectedShop?.value.shopname ??
                            'No Name',
                    'branchName': 'MAIN',
                    'preparedBy': userController.currentUser.value.fullName,
                    'softwareCompanyName': shopController
                            .selectedShop?.value.softwareCompanyName ??
                        'OMGz',
                    'softwareWebsiteLink': shopController
                            .selectedShop?.value.softwareWebsiteLink ??
                        'https://www.omgz.com',
                    'softwareContactNo':
                        shopController.selectedShop?.value.softwareContactNo ??
                            '',
                    'format': format,
                  }),
                  loadingWidget: const TShimmerEffect(width: 80, height: 80),
                  canDebug: false,
                  canChangeOrientation: false,
                  canChangePageFormat: false,
                  initialPageFormat: PdfPageFormat.a4,
                ),
        ),
      ),
    );
  }

  static Future<Uint8List> generatePdfInBackground(
      Map<String, dynamic> params) async {
    final List<PnLReportModel> reports = params['reports'];
    final String companyName = params['companyName'];
    final String branchName = params['branchName'];
    final String preparedBy = params['preparedBy'];
    final String softwareCompanyName = params['softwareCompanyName'];
    final String softwareWebsiteLink = params['softwareWebsiteLink'];
    final String softwareContactNo = params['softwareContactNo'];
    final PdfPageFormat format = params['format'];

    final pdf = pw.Document();
    const rowsPerPage = 12;
    final reportChunks = _chunkList(reports, rowsPerPage);

    for (var chunk in reportChunks) {
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
                pw.Text('Profit & Loss Report',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.SizedBox(height: 6),
            pw.Text('Branch: $branchName',
                style: const pw.TextStyle(fontSize: 10)),
            pw.Text('Prepared By: $preparedBy',
                style: const pw.TextStyle(fontSize: 10)),
            pw.Text('Date: ${DateTime.now().toString().split(' ')[0]}',
                style: const pw.TextStyle(fontSize: 10)),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(width: 0.5),
              columnWidths: {
                0: const pw.FlexColumnWidth(2),
                1: const pw.FlexColumnWidth(3),
                2: const pw.FlexColumnWidth(3),
                3: const pw.FlexColumnWidth(3),
                4: const pw.FlexColumnWidth(3),
                5: const pw.FlexColumnWidth(3),
                6: const pw.FlexColumnWidth(3),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _tableHeader('Month'),
                    _tableHeader('Revenue'),
                    _tableHeader('COGS'),
                    _tableHeader('Shipping'),
                    _tableHeader('Commission'),
                    _tableHeader('Gross Profit'),
                    _tableHeader('Net Profit'),
                  ],
                ),
                for (var report in chunk)
                  pw.TableRow(
                    children: [
                      _tableCell(report.reportMonth ?? 'N/A'),
                      _tableCell(_formatCurrency(report.totalRevenue ?? 0)),
                      _tableCell(_formatCurrency(report.totalCogs ?? 0)),
                      _tableCell(
                          _formatCurrency(report.totalShippingFees ?? 0)),
                      _tableCell(
                          _formatCurrency(report.totalSalesmanCommission ?? 0)),
                      _profitCell(report.grossProfit ?? 0),
                      _profitCell(report.netProfit ?? 0),
                    ],
                  ),
              ],
            ),
            pw.SizedBox(height: 20),
            // Summary section
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                        'Total Revenue: ${_formatCurrency(_calculateTotal(reports, (r) => r.totalRevenue))}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                        'Total COGS: ${_formatCurrency(_calculateTotal(reports, (r) => r.totalCogs))}'),
                    pw.Text(
                        'Total Shipping: ${_formatCurrency(_calculateTotal(reports, (r) => r.totalShippingFees))}'),
                    pw.Text(
                        'Total Commission: ${_formatCurrency(_calculateTotal(reports, (r) => r.totalSalesmanCommission))}'),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                        'Total Gross Profit: ${_formatCurrency(_calculateTotal(reports, (r) => r.grossProfit))}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                        'Total Net Profit: ${_formatCurrency(_calculateTotal(reports, (r) => r.netProfit))}',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color:
                              _calculateTotal(reports, (r) => r.netProfit) >= 0
                                  ? PdfColors.green
                                  : PdfColors.red,
                        )),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            // Add the footer with company information and signature box
            ReportFooter.buildReportFooter(
              signatureTitle: 'Signature by Finance Manager',
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

  static String _formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  static double _calculateTotal(
      List<PnLReportModel> reports, double? Function(PnLReportModel) selector) {
    return reports.fold(0.0, (sum, report) => sum + (selector(report) ?? 0));
  }

  static pw.Widget _profitCell(double amount) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      color: amount >= 0 ? PdfColors.green100 : PdfColors.red100,
      child: pw.Text(
        _formatCurrency(amount),
        style: pw.TextStyle(
          color: amount >= 0 ? PdfColors.green : PdfColors.red,
          fontWeight: pw.FontWeight.bold,
        ),
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
    try {
      final ShopController shopController = Get.find<ShopController>();
      final UserController userController = Get.find<UserController>();

      final pdfBytes = await compute(
        generatePdfInBackground,
        {
          'reports': reports,
          'companyName':
              shopController.selectedShop?.value.shopname ?? 'No Name',
          'branchName': 'MAIN',
          'preparedBy': userController.currentUser.value.fullName,
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

      final file = File('${directory!.path}/profit_loss_report.pdf');
      await file.writeAsBytes(pdfBytes);

      TLoaders.successSnackBar(
        title: 'PDF Saved',
        message: 'File saved to: ${file.path}',
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  static pw.Widget _tableHeader(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(5),
      alignment: pw.Alignment.center,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static pw.Widget _tableCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(5),
      alignment: pw.Alignment.center,
      child: pw.Text(text),
    );
  }
}
