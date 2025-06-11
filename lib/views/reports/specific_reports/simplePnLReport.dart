import 'dart:typed_data';
import 'dart:io';

import 'package:admin_dashboard_v3/Models/reports/simple_pnl_report_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/controllers/shop/shop_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/reports/common/report_footer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class SimplePnLReportPage extends StatelessWidget {
  final List<SimplePnLReportModel> reports;

  const SimplePnLReportPage({required this.reports});

  @override
  Widget build(BuildContext context) {
    final ShopController shopController = Get.find<ShopController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple P&L Report'),
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
                  build: (format) => generatePdf(
                    format,
                    shopController.selectedShop?.value.shopname ?? 'No Name',
                    shopController.selectedShop?.value.softwareCompanyName ??
                        'OMGz',
                    shopController.selectedShop?.value.softwareWebsiteLink ??
                        'https://www.omgz.com',
                    shopController.selectedShop?.value.softwareContactNo ?? '',
                  ),
                  canChangeOrientation: false,
                  canChangePageFormat: false,
                  canDebug: false,
                  allowPrinting: true,
                  allowSharing: true,
                  initialPageFormat: PdfPageFormat.a4,
                ),
        ),
      ),
    );
  }

  Future<Uint8List> generatePdf(
    PdfPageFormat format,
    String companyName,
    String softwareCompanyName,
    String softwareWebsiteLink,
    String softwareContactNo,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(companyName,
                      style: pw.TextStyle(
                          fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Simple Profit & Loss Report',
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 6),
              pw.Text('Date: ${DateTime.now().toString().split(' ')[0]}',
                  style: const pw.TextStyle(fontSize: 10)),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(1),
                },
                children: [
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Field',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Value',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  for (var report in reports) ...[
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Report Period'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(report.reportPeriod),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Total Sales'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(report.totalSales.toStringAsFixed(2)),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Total COGS'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(report.totalCogs.toStringAsFixed(2)),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Total Profit'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(report.totalProfit.toStringAsFixed(2)),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Profit Margin %'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                              report.profitMarginPercent.toStringAsFixed(2)),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Total Orders'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(report.totalOrders.toString()),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Total Installments Paid'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                              report.totalInstallmentsPaid.toStringAsFixed(2)),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Total Installments Pending'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(report.totalInstallmentsPending
                              .toStringAsFixed(2)),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              pw.SizedBox(height: 30),
              // Add the footer with company information and signature box
              ReportFooter.buildReportFooter(
                signatureTitle: 'Signature by Accountant',
                softwareCompanyName: softwareCompanyName,
                softwareWebsiteLink: softwareWebsiteLink,
                softwareContactNo: softwareContactNo,
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> savePdf(BuildContext context) async {
    try {
      final ShopController shopController = Get.find<ShopController>();

      final pdfBytes = await generatePdf(
        PdfPageFormat.a4,
        shopController.selectedShop?.value.shopname ?? 'No Name',
        shopController.selectedShop?.value.softwareCompanyName ?? 'OMGz',
        shopController.selectedShop?.value.softwareWebsiteLink ??
            'https://www.omgz.com',
        shopController.selectedShop?.value.softwareContactNo ?? '',
      );

      final directory = Platform.isIOS || Platform.isAndroid
          ? await getApplicationDocumentsDirectory()
          : await getDownloadsDirectory();

      final file = File('${directory!.path}/simple_pnl_report.pdf');
      await file.writeAsBytes(pdfBytes);

      TLoaders.successSnackBar(
        title: 'PDF Saved',
        message: 'File saved to: ${file.path}',
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: "Error saving PDF", message: e.toString());
    }
  }
}
