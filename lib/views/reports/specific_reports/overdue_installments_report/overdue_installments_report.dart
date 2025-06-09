import 'dart:typed_data';
import 'dart:io';

import 'package:admin_dashboard_v3/Models/reports/overdue_installments_report_model.dart';
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

class OverdueInstallmentsReportPage extends StatelessWidget {
  final List<OverdueInstallmentsReportModel> reports;

  const OverdueInstallmentsReportPage({
    super.key,
    required this.reports,
  });

  @override
  Widget build(BuildContext context) {
    final ShopController shopController = Get.find<ShopController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overdue Installments Report'),
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
          width: 1200,
          child: reports.isEmpty
              ? const Center(child: Text('No overdue installments found'))
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
                  canDebug: false,
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
                  pw.Text('Overdue Installments Report',
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 6),
              pw.Text('Date: ${DateTime.now().toString().split(' ')[0]}',
                  style: const pw.TextStyle(fontSize: 10)),
              pw.Text('Total Records: ${reports.length}',
                  style: const pw.TextStyle(fontSize: 10)),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1.5),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(1.5),
                  3: const pw.FlexColumnWidth(1.2),
                  4: const pw.FlexColumnWidth(1),
                  5: const pw.FlexColumnWidth(1.2),
                  6: const pw.FlexColumnWidth(1),
                  7: const pw.FlexColumnWidth(1),
                },
                children: [
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text('Customer',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text('Contact',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text('Salesman',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text('Due Date',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text('Days',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text('Amount',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text('Seq#',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text('Status',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8)),
                      ),
                    ],
                  ),
                  for (var report in reports)
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(report.customerName,
                              style: const pw.TextStyle(fontSize: 8)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(report.customerContact,
                              style: const pw.TextStyle(fontSize: 8)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(report.salesmanName,
                              style: const pw.TextStyle(fontSize: 8)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(report.dueDate,
                              style: const pw.TextStyle(fontSize: 8)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(report.daysOverdue.toString(),
                              style: const pw.TextStyle(
                                  fontSize: 8, color: PdfColors.red)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(
                              double.parse(report.amountDue).toStringAsFixed(2),
                              style: const pw.TextStyle(fontSize: 8)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(report.sequenceNo.toString(),
                              style: const pw.TextStyle(fontSize: 8)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(report.status,
                              style: const pw.TextStyle(
                                  fontSize: 8, color: PdfColors.red)),
                        ),
                      ],
                    ),
                ],
              ),
              pw.SizedBox(height: 20),
              // Summary
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Total Overdue Amount: ${reports.fold(0.0, (sum, report) => sum + double.parse(report.amountDue)).toStringAsFixed(2)}',
                    style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.red),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Average Days Overdue: ${reports.isNotEmpty ? (reports.fold(0, (sum, report) => sum + report.daysOverdue) / reports.length).toStringAsFixed(1) : "0"} days',
                    style: pw.TextStyle(
                        fontSize: 10, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.SizedBox(height: 30),
              // Add the footer
              ReportFooter.buildReportFooter(
                signatureTitle: 'Signature by Manager',
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

      final file = File('${directory!.path}/overdue_installments_report.pdf');
      await file.writeAsBytes(pdfBytes);

      TLoader.successSnackBar(
        title: 'PDF Saved',
        message: 'File saved to: ${file.path}',
      );
    } catch (e) {
      TLoader.errorSnackBar(title: "Error saving PDF", message: e.toString());
    }
  }
}
