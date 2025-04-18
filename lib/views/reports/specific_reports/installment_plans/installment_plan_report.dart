import 'dart:typed_data';
import 'dart:io';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/shimmers/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../routes/routes.dart';
import '../../../../controllers/installments/installments_controller.dart';
import '../../../../controllers/sales/sales_controller.dart';

import '../../../../Models/installments/installment_table_model/installment_table_model.dart';

class InstallmentReportPage extends StatelessWidget {
  final List<InstallmentTableModel> installmentPlans;
  final String companyName;
  final String branchName;
  final String cashierName;
  final String softwareCompanyName;

  InstallmentReportPage({
    required this.installmentPlans,
    required this.companyName,
    required this.branchName,
    required this.cashierName,
    this.softwareCompanyName = 'OMGz',
  });

  @override
  Widget build(BuildContext context) {
    final installmentController = Get.find<InstallmentController>();
    final salesController = Get.find<SalesController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Installment Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              await savePdf(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: TRoundedContainer(
                width: 1000,
                child: PdfPreview(
                  build: (format) => generatePdfInBackground({
                    'installmentPlans': installmentPlans,
                    'companyName': companyName,
                    'branchName': branchName,
                    'cashierName': cashierName,
                    'softwareCompanyName': softwareCompanyName,
                    'format': PdfPageFormat.a4,
                  }),
                  loadingWidget: const TShimmerEffect(width: 80, height: 80),
                  canChangeOrientation: false,
                  canChangePageFormat: false,
                  allowPrinting: true,
                  allowSharing: true,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Clear both installment and sales fields
                installmentController.clearAllFields();
                salesController.resetField();
                // Navigate back to sales screen
                Get.offAllNamed(TRoutes.sales);
              },
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }

  static Future<Uint8List> generatePdfInBackground(
      Map<String, dynamic> params) async {
    final List<InstallmentTableModel> installmentPlans =
        params['installmentPlans'];
    final String companyName = params['companyName'];
    final String branchName = params['branchName'];
    final String cashierName = params['cashierName'];
    final String softwareCompanyName = params['softwareCompanyName'];
    final PdfPageFormat format = params['format'];

    final pdf = pw.Document();

    const rowsPerPage = 15;
    final installmentChunks = _chunkList(installmentPlans, rowsPerPage);

    for (var chunk in installmentChunks) {
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
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Text('Branch: $branchName',
                style: const pw.TextStyle(fontSize: 12)),
            pw.Text('Cashier: $cashierName',
                style: const pw.TextStyle(fontSize: 12)),
            pw.Divider(),
            pw.SizedBox(height: 8),
            pw.Table(
              border: pw.TableBorder.all(width: 1),
              columnWidths: {
                0: const pw.FlexColumnWidth(1.5),
                1: const pw.FlexColumnWidth(2.5),
                2: const pw.FlexColumnWidth(2.5),
                3: const pw.FlexColumnWidth(2.5),
                4: const pw.FlexColumnWidth(1.5),
                5: const pw.FlexColumnWidth(1.5),
                6: const pw.FlexColumnWidth(2.5),
                7: const pw.FlexColumnWidth(1.5),
                8: const pw.FlexColumnWidth(1.5),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _tableHeader('Seq No'),
                    _tableHeader('Description'),
                    _tableHeader('Due Date'),
                    _tableHeader('Paid Date'),
                    _tableHeader('Amount Due'),
                    _tableHeader('Paid Amount'),
                    _tableHeader('Remarks'),
                    _tableHeader('Balance'),
                    _tableHeader('Status'),
                  ],
                ),
                for (var installment in chunk)
                  pw.TableRow(
                    children: [
                      _tableCell(installment.sequenceNo.toString()),
                      _tableCell(installment.description),
                      _tableCell(installment.dueDate),
                      _tableCell(installment.paidDate ?? 'N/A'),
                      _tableCell(installment.amountDue.toString()),
                      _tableCell(installment.paidAmount.toString()),
                      _tableCell(installment.remarks ?? ''),
                      _tableCell(installment.remaining.toString()),
                      _tableCell(installment.status ?? 'NA'),
                    ],
                  ),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Align(
              alignment: pw.Alignment.bottomCenter,
              child: pw.Column(
                children: [
                  pw.Text(softwareCompanyName,
                      style: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Generated by: $softwareCompanyName",
                          style: const pw.TextStyle(fontSize: 8)),
                      pw.BarcodeWidget(
                        data: 'https://www.omgzz.com',
                        barcode: pw.Barcode.qrCode(),
                        width: 40,
                        height: 40,
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
      final pdfBytes = await compute(
        generatePdfInBackground,
        {
          'installmentPlans': installmentPlans,
          'companyName': companyName,
          'branchName': branchName,
          'cashierName': cashierName,
          'softwareCompanyName': softwareCompanyName,
          'format': PdfPageFormat.a4,
        },
      );

      Directory? downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        throw Exception("Could not find downloads directory");
      }

      final filePath = '${downloadsDir.path}/Installment_Report.pdf';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PDF saved in Downloads folder!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save PDF: $e")),
      );
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
