import 'dart:io';
import 'dart:typed_data';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/common/widgets/shimmers/shimmer.dart';
import 'package:admin_dashboard_v3/controllers/shop/shop_controller.dart';
import 'package:admin_dashboard_v3/controllers/user/user_controller.dart';
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
import '../../../../views/reports/common/report_footer.dart';

class InstallmentReportPage extends StatefulWidget {
  final List<InstallmentTableModel> installmentPlans;
  final bool isPrintOnly;

  const InstallmentReportPage({
    super.key,
    required this.installmentPlans,
    this.isPrintOnly = false,
  });

  @override
  _InstallmentReportPageState createState() => _InstallmentReportPageState();
}

class _InstallmentReportPageState extends State<InstallmentReportPage> {
  final RxBool _isLoading = true.obs;
  final RxBool _hasError = false.obs;
  final RxString _errorMessage = ''.obs;
  Uint8List? _pdfBytes;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generatePdfReport();
    });
  }

  Future<void> _generatePdfReport() async {
    try {
      _isLoading.value = true;
      _hasError.value = false;
      _errorMessage.value = '';

      final shopController = Get.find<ShopController>();
      final userController = Get.find<UserController>();

      _pdfBytes = await compute(generatePdfInBackground, {
        'installmentPlans': widget.installmentPlans,
        'companyName': shopController.selectedShop?.value.shopname ?? 'Company',
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
      }).timeout(const Duration(seconds: 10), onTimeout: () {
        _hasError.value = true;
        _errorMessage.value = 'PDF generation timed out. Please try again.';
        return _createEmptyPdf(PdfPageFormat.a4);
      });
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Error generating PDF: ${e.toString()}';
      _pdfBytes = await _createErrorPdf(PdfPageFormat.a4, e.toString());
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get required controllers
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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generatePdfReport,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: TRoundedContainer(
                width: 1000,
                child: widget.installmentPlans.isEmpty && !_isLoading.value
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.info_outline,
                                size: 48, color: Colors.grey),
                            const SizedBox(height: 16),
                            const Text(
                              'No installment data available',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _generatePdfReport,
                              child: const Text('Refresh'),
                            ),
                          ],
                        ),
                      )
                    : Obx(() {
                        if (_isLoading.value) {
                          return const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TShimmerEffect(width: 120, height: 120),
                                SizedBox(height: 16),
                                Text('Generating Installment Report...'),
                              ],
                            ),
                          );
                        } else if (_hasError.value) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.error_outline,
                                    color: Colors.red, size: 48),
                                const SizedBox(height: 16),
                                Text(_errorMessage.value),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _generatePdfReport,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return PdfPreview(
                            maxPageWidth: 800,
                            build: (format) {
                              return Future.value(_pdfBytes!);
                            },
                            loadingWidget: const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TShimmerEffect(width: 120, height: 120),
                                  SizedBox(height: 16),
                                  Text('Loading PDF preview...'),
                                ],
                              ),
                            ),
                            canChangeOrientation: false,
                            canChangePageFormat: false,
                            canDebug: false,
                            allowPrinting: true,
                            allowSharing: true,
                            enableScrollToPage: true,
                            initialPageFormat: PdfPageFormat.a4,
                            pdfPreviewPageDecoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            actions: [
                              IconButton(
                                icon: const Icon(Icons.done),
                                onPressed: () {
                                  if (widget.isPrintOnly) {
                                    Get.offAllNamed(TRoutes.installment);
                                  } else {
                                    installmentController.clearAllFields();
                                    salesController.resetFields();
                                    Get.offAllNamed(TRoutes.sales);
                                  }
                                },
                              ),
                            ],
                          );
                        }
                      }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> _createEmptyPdf(PdfPageFormat format) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) => pw.Center(
          child: pw.Text('PDF generation timed out. Please try again.',
              style: const pw.TextStyle(fontSize: 18)),
        ),
      ),
    );
    return pdf.save();
  }

  Future<Uint8List> _createErrorPdf(PdfPageFormat format, String error) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) => pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('Error generating PDF',
                  style:
                      const pw.TextStyle(fontSize: 18, color: PdfColors.red)),
              pw.SizedBox(height: 20),
              pw.Text('Please try again later.',
                  style: const pw.TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
    return pdf.save();
  }

  static Future<Uint8List> generatePdfInBackground(
      Map<String, dynamic> params) async {
    final List<InstallmentTableModel> installmentPlans =
        params['installmentPlans'];
    final String companyName = params['companyName'];
    final String branchName = params['branchName'];
    final String cashierName = params['cashierName'];
    final String softwareCompanyName = params['softwareCompanyName'];
    final String softwareWebsiteLink = params['softwareWebsiteLink'];
    final String softwareContactNo = params['softwareContactNo'];
    final PdfPageFormat format = params['format'];

    try {
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
                  pw.Text('Installment Report',
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Text('Branch: $branchName',
                  style: const pw.TextStyle(fontSize: 10)),
              pw.Text('Prepared By: $cashierName',
                  style: const pw.TextStyle(fontSize: 10)),
              pw.Text('Date: ${DateTime.now().toString().split(' ')[0]}',
                  style: const pw.TextStyle(fontSize: 10)),
              pw.Divider(),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5),
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
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
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
              ReportFooter.buildReportFooter(
                signatureTitle: 'Signature by Manager',
                softwareCompanyName: softwareCompanyName,
                softwareWebsiteLink: softwareWebsiteLink,
                softwareContactNo: softwareContactNo,
              ),
            ],
          ),
        );
      }

      return pdf.save();
    } catch (e) {
      // Create a simple error PDF if something goes wrong
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageFormat: format,
          build: (context) => pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('Error generating PDF',
                    style:
                        const pw.TextStyle(fontSize: 18, color: PdfColors.red)),
                pw.SizedBox(height: 20),
                pw.Text(e.toString(), style: const pw.TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
      );
      return pdf.save();
    }
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
      if (_pdfBytes == null) {
        TLoaders.errorSnackBar(
          title: "Error",
          message: "PDF not generated yet. Please wait or try again.",
        );
        return;
      }

      final directory = Platform.isIOS || Platform.isAndroid
          ? await getApplicationDocumentsDirectory()
          : await getDownloadsDirectory();

      if (directory == null) {
        throw Exception("Could not find downloads directory");
      }

      final filePath = '${directory.path}/Installment_Report.pdf';
      final file = File(filePath);
      await file.writeAsBytes(_pdfBytes!);

      TLoaders.successSnackBar(
        title: 'PDF Saved',
        message: 'File saved to: ${file.path}',
      );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: "Error saving PDF",
        message: e.toString(),
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
