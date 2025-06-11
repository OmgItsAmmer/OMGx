import 'dart:typed_data';
import 'dart:io';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/reports/common/report_footer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

import '../../../../Models/products/product_model.dart';
import '../../../../controllers/shop/shop_controller.dart';
import '../../../../controllers/user/user_controller.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../common/widgets/shimmers/shimmer.dart';

class StockSummaryReportPage extends StatelessWidget {
  final List<ProductModel> products;

  const StockSummaryReportPage({required this.products});

  @override
  Widget build(BuildContext context) {
    final ShopController shopController = Get.find<ShopController>();
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Report'),
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
          child: products.isEmpty
              ? const Text('No data to display')
              : PdfPreview(
                  build: (format) => generatePdfInBackground({
                    'products': products,
                    'companyName':
                        shopController.selectedShop?.value.shopname ??
                            'No Name',
                    'branchName': 'MAIN',
                    'cashierName': userController.currentUser.value.fullName,
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
    final List<ProductModel> products = params['products'];
    final String companyName = params['companyName'];
    final String branchName = params['branchName'];
    final String cashierName = params['cashierName'];
    final String softwareCompanyName = params['softwareCompanyName'];
    final String softwareWebsiteLink = params['softwareWebsiteLink'];
    final String softwareContactNo = params['softwareContactNo'];
    final PdfPageFormat format = params['format'];

    final pdf = pw.Document();
    const rowsPerPage = 20;
    final productChunks = _chunkList(products, rowsPerPage);

    for (var chunk in productChunks) {
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
                pw.Text('Stock Summary Report',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.SizedBox(height: 6),
            pw.Text('Branch: $branchName',
                style: const pw.TextStyle(fontSize: 10)),
            pw.Text('Prepared By: $cashierName',
                style: const pw.TextStyle(fontSize: 10)),
            pw.Text('Date: ${DateTime.now().toString().split(' ')[0]}',
                style: const pw.TextStyle(fontSize: 10)),
            pw.Divider(),
            pw.SizedBox(height: 6),
            pw.Table(
              border: pw.TableBorder.all(width: 0.5),
              columnWidths: {
                0: const pw.FlexColumnWidth(2),
                1: const pw.FlexColumnWidth(3),
                2: const pw.FlexColumnWidth(4),
                3: const pw.FlexColumnWidth(2),
                4: const pw.FlexColumnWidth(2),
                5: const pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _tableHeader('Product ID'),
                    _tableHeader('Name'),
                    _tableHeader('Description'),
                    _tableHeader('Base Price'),
                    _tableHeader('Sale Price'),
                    _tableHeader('Stock Qty'),
                  ],
                ),
                for (var product in chunk)
                  pw.TableRow(
                    decoration: (product.alertStock != null &&
                            product.stockQuantity != null &&
                            product.stockQuantity! < product.alertStock!)
                        ? const pw.BoxDecoration(color: PdfColors.amber100)
                        : null,
                    children: [
                      _tableCell(product.productId.toString()),
                      _tableCell(product.name ?? 'N/A'),
                      _tableCell(product.description ?? 'N/A'),
                      _tableCell(product.basePrice?.toString() ?? '0.0'),
                      pw.Container(
                        color: (product.basePrice != null &&
                                product.salePrice != null &&
                                double.tryParse(product.salePrice!) != null &&
                                double.tryParse(product.basePrice!) != null &&
                                double.parse(product.salePrice!) <
                                    double.parse(product.basePrice!))
                            ? PdfColors.red100
                            : null,
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(product.salePrice?.toString() ?? '0.0',
                            style: const pw.TextStyle(fontSize: 8)),
                      ),
                      _tableCell(product.stockQuantity?.toString() ?? '0'),
                    ],
                  ),
              ],
            ),
            pw.SizedBox(height: 20),
            // Add the footer with company information and signature box
            ReportFooter.buildReportFooter(
              signatureTitle: 'Signature by Inventory Manager',
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
    try {
      final ShopController shopController = Get.find<ShopController>();
      final UserController userController = Get.find<UserController>();

      final pdfBytes = await compute(
        generatePdfInBackground,
        {
          'products': products,
          'companyName':
              shopController.selectedShop?.value.shopname ?? 'No Name',
          'branchName': 'MAIN',
          'cashierName': userController.currentUser.value.fullName,
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

      final file = File('${directory!.path}/Stock_Summary_Report.pdf');
      await file.writeAsBytes(pdfBytes);

      TLoaders.successSnackBar(
        title: 'PDF Saved',
        message: 'File saved to: ${file.path}',
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: "Error saving PDF", message: e.toString());
    }
  }

  static pw.Widget _tableHeader(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(2), // Reduced padding
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 8, // Smaller font size
        ),
      ),
    );
  }

  static pw.Widget _tableCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(2), // Reduced padding
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 8), // Smaller font size
      ),
    );
  }
}
