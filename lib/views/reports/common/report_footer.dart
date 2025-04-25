import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportFooter {
  /// Creates a standard footer for reports with signature box on the left and company info on the right
  static pw.Widget buildReportFooter({
    String signatureTitle = 'Signature',
    String softwareCompanyName = '',
    String softwareWebsiteLink = '',
    String softwareContactNo = '',
  }) {
    return pw.Column(
      children: [
        pw.SizedBox(height: 20),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Left side: Signature box
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 150,
                  height: 1,
                  color: PdfColors.black,
                ),
                pw.SizedBox(height: 5),
                pw.Text(signatureTitle,
                    style: pw.TextStyle(
                        fontSize: 10, fontWeight: pw.FontWeight.bold)),
              ],
            ),

            // Right side: Company info with barcode
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Contact Us:',
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 3),
                      pw.Text(softwareCompanyName,
                          style: const pw.TextStyle(fontSize: 8)),
                      if (softwareContactNo.isNotEmpty)
                        pw.Text(softwareContactNo,
                            style: const pw.TextStyle(fontSize: 8)),
                      pw.SizedBox(height: 3),
                      if (softwareWebsiteLink.isNotEmpty)
                        pw.Text('Scan for more info:',
                            style: const pw.TextStyle(fontSize: 8)),
                    ],
                  ),
                  pw.SizedBox(width: 10),
                  if (softwareWebsiteLink.isNotEmpty)
                    pw.BarcodeWidget(
                      data: softwareWebsiteLink,
                      barcode: pw.Barcode.qrCode(),
                      width: 50,
                      height: 50,
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
