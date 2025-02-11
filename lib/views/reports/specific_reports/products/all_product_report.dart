import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

import '../../../../Models/products/product_model.dart'; // Import for compute


class ReportPage extends StatelessWidget {
  final List<ProductModel> products;
  final String companyName;
  final String branchName;
  final String cashierName;
  final String softwareCompanyName;

  ReportPage({
    required this.products,
    required this.companyName,
    required this.branchName,
    required this.cashierName,
    this.softwareCompanyName = 'OMGz',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              await savePdf(context); // Pass context to show a SnackBar
            },
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) => generatePdfInBackground({
          'products': products,
          'companyName': companyName,
          'branchName': branchName,
          'cashierName': cashierName,
          'softwareCompanyName': softwareCompanyName,
          'format': format,
        }),
      ),
    );
  }

  // Top-level function for PDF generation (must be static)
  static Future<Uint8List> generatePdfInBackground(Map<String, dynamic> params) async {
    final List<ProductModel> products = params['products'];
    final String companyName = params['companyName'];
    final String branchName = params['branchName'];
    final String cashierName = params['cashierName'];
    final String softwareCompanyName = params['softwareCompanyName'];
    final PdfPageFormat format = params['format'];

    final pdf = pw.Document();

    // Define how many rows to display per page
    const rowsPerPage = 20; // Adjust this number based on your content size

    // Split the products list into chunks
    final productChunks = _chunkList(products, rowsPerPage);

    for (var chunk in productChunks) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: format,
          build: (context) => [
            // Header Section (repeated on every page)
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(companyName, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                // pw.FlutterLogo(), // Replace with your company logo if available
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Text('Branch: $branchName', style: const pw.TextStyle(fontSize: 14)),
            pw.Text('Cashier: $cashierName', style: const pw.TextStyle(fontSize: 14)),
            pw.Divider(),
            pw.SizedBox(height: 10),

            // Table Section for the current chunk
            pw.Table(
              border: pw.TableBorder.all(width: 1),
              columnWidths: {
                0: const pw.FlexColumnWidth(2), // Product ID
                1: const pw.FlexColumnWidth(3), // Name
                2: const pw.FlexColumnWidth(4), // Description
                3: const pw.FlexColumnWidth(2), // Base Price
                4: const pw.FlexColumnWidth(2), // Sale Price
                5: const pw.FlexColumnWidth(2), // Stock Qty
              },
              children: [
                // Table Header
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Product ID', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Name', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Description', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Base Price', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Sale Price', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Stock Qty', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  ],
                ),
                // Data Rows for the current chunk
                for (var product in chunk)
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(product.productId.toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(product.name ?? 'N/A')),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(product.description ?? 'N/A')),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(product.basePrice?.toString() ?? '0.0')),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(product.salePrice?.toString() ?? '0.0')),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(product.stockQuantity.toString())),
                    ],
                  ),
              ],
            ),

            // Footer Section (repeated on every page)
            pw.SizedBox(height: 20),
            pw.Align(
              alignment: pw.Alignment.bottomCenter,
              child: pw.Column(
                children: [
                  pw.Text(softwareCompanyName, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Generated by: $softwareCompanyName", style: const pw.TextStyle(fontSize: 10)),
                      pw.BarcodeWidget(
                        data: 'https://www.yourcompany.com',
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
  }

  // Helper function to split a list into chunks
  static List<List<T>> _chunkList<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }

  Future<void> savePdf(BuildContext context) async {
    try {
      // Use compute to run the PDF generation in a background isolate
      final pdfBytes = await compute(
        generatePdfInBackground,
        {
          'products': products,
          'companyName': companyName,
          'branchName': branchName,
          'cashierName': cashierName,
          'softwareCompanyName': softwareCompanyName,
          'format': PdfPageFormat.a4,
        },
      );

      // Get the downloads directory
      Directory? downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        throw Exception("Could not find downloads directory");
      }

      // Define the file path
      final filePath = '${downloadsDir.path}/Product_Report.pdf';

      // Save the file
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      print("PDF saved at: $filePath");

      // Show a SnackBar to inform the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PDF saved in Downloads folder!")),
      );
    } catch (e) {
      print("Error generating or saving PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save PDF: $e")),
      );
    }
  }
}