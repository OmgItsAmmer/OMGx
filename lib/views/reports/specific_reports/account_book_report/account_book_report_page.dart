import 'dart:typed_data';
import 'dart:io';
import 'package:admin_dashboard_v3/controllers/shop/shop_controller.dart';
import 'package:admin_dashboard_v3/controllers/user/user_controller.dart';
import 'package:admin_dashboard_v3/Models/account_book/account_book_model.dart';
import 'package:admin_dashboard_v3/Models/entity/entity_model.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/views/reports/common/report_footer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../common/widgets/loaders/tloaders.dart';
import '../../../../common/widgets/shimmers/shimmer.dart';

class AccountBookReportPage extends StatelessWidget {
  final List<AccountBookModel> reports;
  final EntityModel entity;
  final EntityType entityType;
  final DateTime startDate;
  final DateTime endDate;

  const AccountBookReportPage({
    super.key,
    required this.reports,
    required this.entity,
    required this.entityType,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final ShopController shopController = Get.find<ShopController>();
    final UserController userController = Get.find<UserController>();

    // Calculate summary
    double totalIncoming = reports
        .where((r) => r.transactionType == TransactionType.buy)
        .fold(0.0, (sum, r) => sum + r.amount);

    double totalOutgoing = reports
        .where((r) => r.transactionType == TransactionType.sell)
        .fold(0.0, (sum, r) => sum + r.amount);

    double netBalance = totalIncoming - totalOutgoing;

    return Scaffold(
      appBar: AppBar(
        title: Text('Account Book Report - ${entity.name}'),
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
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.receipt_long,
                          size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'No transactions found',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No account book entries for ${entity.name} between ${_formatDate(startDate)} and ${_formatDate(endDate)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Summary Cards
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildSummaryCard(
                              'Total Incoming',
                              'Rs ${totalIncoming.toStringAsFixed(2)}',
                              Colors.green,
                              Icons.arrow_downward,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSummaryCard(
                              'Total Outgoing',
                              'Rs ${totalOutgoing.toStringAsFixed(2)}',
                              Colors.red,
                              Icons.arrow_upward,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSummaryCard(
                              'Net Balance',
                              'Rs ${netBalance.toStringAsFixed(2)}',
                              netBalance >= 0 ? Colors.green : Colors.red,
                              netBalance >= 0
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // PDF Preview
                    Expanded(
                      child: PdfPreview(
                        build: (format) => generatePdfInBackground({
                          'reports': reports,
                          'entity': entity,
                          'entityType': entityType,
                          'startDate': startDate,
                          'endDate': endDate,
                          'totalIncoming': totalIncoming,
                          'totalOutgoing': totalOutgoing,
                          'netBalance': netBalance,
                          'companyName':
                              shopController.selectedShop?.value.shopname ??
                                  'No Name',
                          'branchName': 'MAIN',
                          'generatedBy':
                              userController.currentUser.value.fullName,
                          'softwareCompanyName': shopController
                                  .selectedShop?.value.softwareCompanyName ??
                              'OMGz',
                          'softwareWebsiteLink': shopController
                                  .selectedShop?.value.softwareWebsiteLink ??
                              'https://www.omgz.com',
                          'softwareContactNo': shopController
                                  .selectedShop?.value.softwareContactNo ??
                              '',
                          'format': PdfPageFormat.a4,
                        }),
                        loadingWidget:
                            const TShimmerEffect(width: 80, height: 80),
                        initialPageFormat: PdfPageFormat.a4,
                        canChangeOrientation: false,
                        canChangePageFormat: false,
                        canDebug: false,
                        allowPrinting: true,
                        allowSharing: true,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static Future<Uint8List> generatePdfInBackground(
      Map<String, dynamic> params) async {
    final List<AccountBookModel> reports = params['reports'];
    final EntityModel entity = params['entity'];
    final EntityType entityType = params['entityType'];
    final DateTime startDate = params['startDate'];
    final DateTime endDate = params['endDate'];
    final double totalIncoming = params['totalIncoming'];
    final double totalOutgoing = params['totalOutgoing'];
    final double netBalance = params['netBalance'];
    final String companyName = params['companyName'];
    final String branchName = params['branchName'];
    final String generatedBy = params['generatedBy'];
    final String softwareCompanyName = params['softwareCompanyName'];
    final String softwareWebsiteLink = params['softwareWebsiteLink'];
    final String softwareContactNo = params['softwareContactNo'];
    final PdfPageFormat format = params['format'];

    final pdf = pw.Document();
    const rowsPerPage = 20;
    final reportChunks = _chunkList(reports, rowsPerPage);

    for (int chunkIndex = 0; chunkIndex < reportChunks.length; chunkIndex++) {
      final chunk = reportChunks[chunkIndex];

      pdf.addPage(
        pw.MultiPage(
          pageFormat: format,
          build: (context) => [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(companyName,
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Text('Account Book Report',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Text('Branch: $branchName',
                style: const pw.TextStyle(fontSize: 10)),
            pw.Text(
                'Entity: ${entity.name} (${entityType.toString().split('.').last.capitalize!})',
                style: const pw.TextStyle(fontSize: 10)),
            pw.Text(
                'Period: ${_formatDate(startDate)} to ${_formatDate(endDate)}',
                style: const pw.TextStyle(fontSize: 10)),
            pw.Text("Generated by: $generatedBy",
                style: const pw.TextStyle(fontSize: 10)),
            pw.Text('Date: ${DateTime.now().toString().split(' ')[0]}',
                style: const pw.TextStyle(fontSize: 10)),
            pw.Divider(),
            pw.SizedBox(height: 10),

            // Summary (only on first page)
            if (chunkIndex == 0) ...[
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  color: PdfColors.grey100,
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Column(
                      children: [
                        pw.Text('Total Incoming',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Rs ${totalIncoming.toStringAsFixed(2)}',
                            style: const pw.TextStyle(color: PdfColors.green)),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text('Total Outgoing',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Rs ${totalOutgoing.toStringAsFixed(2)}',
                            style: const pw.TextStyle(color: PdfColors.red)),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text('Net Balance',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Rs ${netBalance.toStringAsFixed(2)}',
                            style: pw.TextStyle(
                                color: netBalance >= 0
                                    ? PdfColors.green
                                    : PdfColors.red)),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 15),
            ],

            // Transactions Table
            pw.Table(
              border: pw.TableBorder.all(width: 1),
              columnWidths: {
                0: const pw.FlexColumnWidth(1),
                1: const pw.FlexColumnWidth(2),
                2: const pw.FlexColumnWidth(2),
                3: const pw.FlexColumnWidth(1.5),
                4: const pw.FlexColumnWidth(3),
                5: const pw.FlexColumnWidth(1.5),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _tableHeader('Date'),
                    _tableHeader('Type'),
                    _tableHeader('Amount'),
                    _tableHeader('Reference'),
                    _tableHeader('Description'),
                    _tableHeader('Balance'),
                  ],
                ),
                for (int i = 0; i < chunk.length; i++)
                  pw.TableRow(
                    children: [
                      _tableCell(_formatDate(chunk[i].transactionDate)),
                      _tableCell(chunk[i].transactionTypeDisplay),
                      _tableCell('Rs ${chunk[i].amount.toStringAsFixed(2)}'),
                      _tableCell(chunk[i].reference ?? '-'),
                      _tableCell(chunk[i].description),
                      _tableCell(_getRunningBalance(
                          reports, chunkIndex * rowsPerPage + i)),
                    ],
                  ),
              ],
            ),

            pw.SizedBox(height: 20),

            // Footer (only on last page)
            if (chunkIndex == reportChunks.length - 1)
              ReportFooter.buildReportFooter(
                signatureTitle: 'Signature by Accounts Manager',
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

  static String _getRunningBalance(
      List<AccountBookModel> allReports, int upToIndex) {
    double balance = 0.0;
    for (int i = 0; i <= upToIndex && i < allReports.length; i++) {
      if (allReports[i].transactionType == TransactionType.buy) {
        balance += allReports[i].amount;
      } else {
        balance -= allReports[i].amount;
      }
    }
    return 'Rs ${balance.toStringAsFixed(2)}';
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
          'reports': reports,
          'entity': entity,
          'entityType': entityType,
          'startDate': startDate,
          'endDate': endDate,
          'totalIncoming': reports
              .where((r) => r.transactionType == TransactionType.buy)
              .fold(0.0, (sum, r) => sum + r.amount),
          'totalOutgoing': reports
              .where((r) => r.transactionType == TransactionType.sell)
              .fold(0.0, (sum, r) => sum + r.amount),
          'netBalance': reports
                  .where((r) => r.transactionType == TransactionType.buy)
                  .fold(0.0, (sum, r) => sum + r.amount) -
              reports
                  .where((r) => r.transactionType == TransactionType.sell)
                  .fold(0.0, (sum, r) => sum + r.amount),
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
          '${directory!.path}/Account_Book_Report_${entity.name.replaceAll(' ', '_')}_${_formatDate(startDate)}_to_${_formatDate(endDate)}.pdf');
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
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
    );
  }
}
