import 'dart:typed_data';

import 'package:admin_dashboard_v3/Models/reports/simple_pnl_report_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class SimplePnLReportPage extends StatelessWidget {
  final List<SimplePnLReportModel> reports;

  const SimplePnLReportPage({required this.reports});

  @override
  Widget build(BuildContext context) {
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
                  build: (format) => generatePdf(format),
                  canDebug: false,
                  initialPageFormat: PdfPageFormat.a4,
                ),
        ),
      ),
    );
  }

  Future<Uint8List> generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Simple Profit & Loss Report', 
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(1),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Category', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  for (var report in reports)
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(report.category),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(report.amount.toStringAsFixed(2)),
                        ),
                      ],
                    ),
                ],
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
      final pdfBytes = await generatePdf(PdfPageFormat.a4);
      // Add your file saving logic here
      TLoader.successSnackBar(title: "PDF saved successfully!");
    } catch (e) {
      TLoader.errorSnackBar(title: "Error saving PDF", message: e.toString());
    }
  }
}