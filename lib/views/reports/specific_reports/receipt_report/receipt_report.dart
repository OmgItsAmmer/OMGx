import 'dart:io';
import 'dart:typed_data';
import 'package:admin_dashboard_v3/Models/orders/order_item_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/common/widgets/shimmers/shimmer.dart';
import 'package:admin_dashboard_v3/controllers/shop/shop_controller.dart';
import 'package:admin_dashboard_v3/controllers/user/user_controller.dart';

import 'package:admin_dashboard_v3/Models/customer/customer_model.dart';
import 'package:admin_dashboard_v3/Models/address/address_model.dart';
import 'package:admin_dashboard_v3/controllers/customer/customer_controller.dart';
import 'package:admin_dashboard_v3/controllers/address/address_controller.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../routes/routes.dart';
import '../../../../views/reports/common/report_footer.dart';

class ReceiptReportPage extends StatefulWidget {
  final OrderModel order;
  final bool isPrintOnly;

  const ReceiptReportPage({
    super.key,
    required this.order,
    this.isPrintOnly = false,
  });

  @override
  _ReceiptReportPageState createState() => _ReceiptReportPageState();
}

class _ReceiptReportPageState extends State<ReceiptReportPage> {
  final RxBool _isLoading = true.obs;
  final RxBool _hasError = false.obs;
  final RxString _errorMessage = ''.obs;
  Uint8List? _pdfBytes;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generatePdfReceipt();
    });
  }

  Future<void> _generatePdfReceipt() async {
    try {
      _isLoading.value = true;
      _hasError.value = false;
      _errorMessage.value = '';

      final shopController = Get.find<ShopController>();
      final userController = Get.find<UserController>();
      final customerController = Get.find<CustomerController>();
      final addressController = Get.find<AddressController>();

      // Get customer and address information
      CustomerModel customer = CustomerModel.empty();
      AddressModel address = AddressModel.empty();

      try {
        if (widget.order.customerId != null) {
          customer = customerController.allCustomers.firstWhere(
            (c) => c.customerId == widget.order.customerId,
            orElse: () => CustomerModel.empty(),
          );
        }

        if (widget.order.addressId != null) {
          address = addressController.allCustomerAddresses.firstWhere(
            (a) => a.addressId == widget.order.addressId,
            orElse: () => AddressModel.empty(),
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error getting customer/address: $e');
        }
      }

      _pdfBytes = await compute(generateReceiptPdfInBackground, {
        'order': widget.order,
        'customer': customer,
        'address': address,
        'shopName': shopController.selectedShop?.value.shopname ?? 'Shop Name',
        'shopAddress': '', // ShopModel doesn't have address field
        'shopPhone': '', // ShopModel doesn't have phoneNumber field
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              await savePdf(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generatePdfReceipt,
          ),
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              if (widget.isPrintOnly) {
                Navigator.of(context).pop();
              } else {
                Get.offAllNamed(TRoutes.sales);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: TRoundedContainer(
                width: 800,
                child: Obx(() {
                  if (_isLoading.value) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TShimmerEffect(width: 120, height: 120),
                          SizedBox(height: 16),
                          Text('Generating Receipt...'),
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
                            onPressed: _generatePdfReceipt,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return PdfPreview(
                      maxPageWidth: 600,
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
                              Navigator.of(context).pop();
                            } else {
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

  static Future<Uint8List> generateReceiptPdfInBackground(
      Map<String, dynamic> params) async {
    final OrderModel order = params['order'];
    final CustomerModel customer = params['customer'];
    final AddressModel address = params['address'];
    final String shopName = params['shopName'];
    final String shopAddress = params['shopAddress'];
    final String shopPhone = params['shopPhone'];
    final String cashierName = params['cashierName'];
    final String softwareCompanyName = params['softwareCompanyName'];
    final String softwareWebsiteLink = params['softwareWebsiteLink'];
    final String softwareContactNo = params['softwareContactNo'];
    final PdfPageFormat format = params['format'];

    try {
      final pdf = pw.Document();

      // Calculate receipt net total from subTotal plus fees
      double receiptNetTotal = order.subTotal +
          order.tax +
          order.shippingFee +
          order.salesmanComission;

      pdf.addPage(
        pw.Page(
          pageFormat: format,
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Shop Information Header
              pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Column(
                  children: [
                    pw.Text(
                      shopName,
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    if (shopAddress.isNotEmpty)
                      pw.Text(
                        shopAddress,
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                    if (shopPhone.isNotEmpty)
                      pw.Text(
                        'Phone: $shopPhone',
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                    pw.Text(
                      'Time: ${DateFormat('HH:mm:ss').format(DateTime.now())}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),

              pw.Divider(thickness: 2),
              pw.SizedBox(height: 8),

              // Order Information
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Order #${order.orderId}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'Date: ${order.orderDate}',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),

              // Customer Information
              pw.Container(
                width: double.infinity,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Customer Information:',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    if (customer.customerId != null)
                      pw.Text(
                        'Name: ${customer.fullName}',
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                    if (customer.phoneNumber.isNotEmpty)
                      pw.Text(
                        'Phone: ${customer.phoneNumber}',
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                    if (address.location != null &&
                        address.location!.isNotEmpty)
                      pw.Text(
                        'Address: ${address.location}',
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Divider(),

              // Items Table
              pw.Table(
                border: pw.TableBorder.all(width: 0.5),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(1),
                  2: const pw.FlexColumnWidth(1.5),
                  3: const pw.FlexColumnWidth(1.5),
                },
                children: [
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      _tableHeader('Product'),
                      _tableHeader('Qty'),
                      _tableHeader('Price'),
                      _tableHeader('Total'),
                    ],
                  ),
                  for (var item in order.orderItems ?? [])
                    pw.TableRow(
                      children: [
                        _tableCell('Product ID: ${item.productId}'),
                        _tableCell('${item.quantity} ${item.unit}'),
                        _tableCell(item.price.toStringAsFixed(2)),
                        _tableCell(
                            (item.quantity * item.price).toStringAsFixed(2)),
                      ],
                    ),
                ],
              ),

              pw.SizedBox(height: 16),

              // Totals Section
              pw.Container(
                width: double.infinity,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Container(
                      width: 200,
                      child: pw.Column(
                        children: [
                          _totalRow(
                              'Subtotal:', order.subTotal.toStringAsFixed(2)),
                          _totalRow('Tax:', order.tax.toStringAsFixed(2)),
                          _totalRow('Shipping:',
                              order.shippingFee.toStringAsFixed(2)),
                          _totalRow('Commission:',
                              order.salesmanComission.toStringAsFixed(2)),
                          pw.Divider(),
                          _totalRow(
                              'Total:', receiptNetTotal.toStringAsFixed(2),
                              isTotal: true),
                          _totalRow('Paid:',
                              (order.paidAmount ?? 0).toStringAsFixed(2)),
                          _totalRow(
                              'Change:',
                              ((order.paidAmount ?? 0) - receiptNetTotal)
                                  .toStringAsFixed(2)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 24),
              pw.Divider(),

              // Thank you message
              pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'Thank you for your purchase!',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.Spacer(),

              // Footer
              ReportFooter.buildReportFooter(
                signatureTitle: 'Cashier: $cashierName',
                softwareCompanyName: softwareCompanyName,
                softwareWebsiteLink: softwareWebsiteLink,
                softwareContactNo: softwareContactNo,
              ),
            ],
          ),
        ),
      );

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
                pw.Text('Error generating receipt PDF',
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

      final filePath = '${directory.path}/Receipt_${widget.order.orderId}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(_pdfBytes!);

      TLoaders.successSnackBar(
        title: 'PDF Saved',
        message: 'Receipt saved to: ${file.path}',
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

  static pw.Widget _totalRow(String label, String value,
      {bool isTotal = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: isTotal ? 12 : 10,
              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: isTotal ? 12 : 10,
              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// Helper method to show receipt PDF report
void showReceiptPdfReport(OrderModel order, {bool isPrintOnly = false}) {
  try {
    Get.to(() => ReceiptReportPage(
          order: order,
          isPrintOnly: isPrintOnly,
        ));
  } catch (e) {
    TLoaders.errorSnackBar(title: 'Error', message: e.toString());
  }
}
