import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PdfService {
  static const PdfColor primaryColor = PdfColor.fromInt(
    0xFF3B82F6,
  ); // Your AppColors.primaryColor
  static const PdfColor secondaryColor = PdfColor.fromInt(0xFF10B981);
  static const PdfColor accentColor = PdfColor.fromInt(0xFFF59E0B);
  static const PdfColor dangerColor = PdfColor.fromInt(0xFFEF4444);

  // Generate booking voucher
  static Future<File> generateBookingVoucher({
    required String bookingReference,
    required String customerName,
    required String tourName,
    required DateTime travelDate,
    required int guests,
    required double totalAmount,
    required String paymentMethod,
    required String bookingDate,
    String? customMessage,
  }) async {
    final pdf = pw.Document();

    // Load custom font (optional - add your fonts to assets)
    // final fontData = await rootBundle.load("assets/fonts/Inter-Regular.ttf");
    // final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header with Logo and Title
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: primaryColor,
                  borderRadius: const pw.BorderRadius.only(
                    topLeft: pw.Radius.circular(10),
                    topRight: pw.Radius.circular(10),
                  ),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'TRAVEL & TOUR',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.Text(
                          'Explore the World',
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.white,
                          ),
                        ),
                      ],
                    ),
                    pw.Container(
                      width: 60,
                      height: 60,
                      decoration: pw.BoxDecoration(
                        color: PdfColors.white,
                        shape: pw.BoxShape.circle,
                      ),
                      child: pw.Center(
                        child: pw.Text('✈️', style: pw.TextStyle(fontSize: 30)),
                      ),
                    ),
                  ],
                ),
              ),

              // Title
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                child: pw.Column(
                  children: [
                    pw.Center(
                      child: pw.Text(
                        'BOOKING CONFIRMATION',
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Center(
                      child: pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromInt(0xFFDEEBF7),
                          borderRadius: pw.BorderRadius.circular(20),
                        ),
                        child: pw.Text(
                          bookingReference,
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Success Message
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 20),
                child: pw.Row(
                  children: [
                    pw.Container(
                      width: 30,
                      height: 30,
                      decoration: pw.BoxDecoration(
                        color: PdfColors.green,
                        shape: pw.BoxShape.circle,
                      ),
                      child: pw.Center(
                        child: pw.Text(
                          '✓',
                          style: pw.TextStyle(
                            fontSize: 20,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Text(
                      'Your booking has been confirmed successfully!',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.green700,
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Customer & Booking Details
              pw.Container(
                margin: const pw.EdgeInsets.symmetric(horizontal: 20),
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Booking Details',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    pw.SizedBox(height: 15),
                    _buildInfoRow('Customer Name:', customerName),
                    _buildInfoRow('Booking Date:', bookingDate),
                    _buildInfoRow(
                      'Travel Date:',
                      '${travelDate.day}/${travelDate.month}/${travelDate.year}',
                    ),
                    _buildInfoRow('Number of Guests:', guests.toString()),
                    _buildInfoRow('Payment Method:', paymentMethod),
                    _buildInfoRow(
                      'Payment Status:',
                      'Paid ✓',
                      color: PdfColors.green700,
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Tour Details
              pw.Container(
                margin: const pw.EdgeInsets.symmetric(horizontal: 20),
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Tour Package',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    pw.SizedBox(height: 15),
                    _buildInfoRow('Tour Name:', tourName),
                    pw.SizedBox(height: 10),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(10),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey100,
                        borderRadius: pw.BorderRadius.circular(5),
                      ),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Total Amount',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            '\$${totalAmount.toStringAsFixed(2)}',
                            style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              // Terms & Conditions
              pw.Container(
                margin: const pw.EdgeInsets.symmetric(horizontal: 20),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Terms & Conditions:',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      '• This voucher is valid only for the mentioned travel date.',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.Text(
                      '• Please carry a printout of this voucher along with valid ID proof.',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.Text(
                      '• Cancellation policy applies as per terms agreed at time of booking.',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                    if (customMessage != null) ...[
                      pw.SizedBox(height: 10),
                      pw.Text(
                        customMessage,
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: accentColor,
                          fontStyle: pw.FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              pw.Spacer(),

              // Footer
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: const pw.BorderRadius.only(
                    bottomLeft: pw.Radius.circular(10),
                    bottomRight: pw.Radius.circular(10),
                  ),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Thank you for choosing Travel & Tour!',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontStyle: pw.FontStyle.italic,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.Text(
                      'www.traveltour.com',
                      style: pw.TextStyle(fontSize: 10, color: primaryColor),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save PDF to device
    return await _savePdf(pdf, 'voucher_$bookingReference.pdf');
  }

  // Helper method to create info rows
  static pw.Widget _buildInfoRow(
    String label,
    String value, {
    PdfColor? color,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 120,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey700,
              ),
            ),
          ),
          pw.Text(':  '),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(
                color: color ?? PdfColors.black,
                fontWeight: color != null
                    ? pw.FontWeight.bold
                    : pw.FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Save PDF to device
  static Future<File> _savePdf(pw.Document pdf, String fileName) async {
    final bytes = await pdf.save();

    // Get device document directory
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');

    await file.writeAsBytes(bytes);
    return file;
  }

  // Share PDF
  static Future<void> sharePdf(File file, {String? text}) async {
    await Share.shareXFiles([
      XFile(file.path),
    ], text: text ?? 'My Travel & Tour Booking Voucher');
  }

  // Generate invoice PDF (simpler version for quick view)
  static Future<Uint8List> generateInvoicePdf({
    required String bookingReference,
    required String tourName,
    required double amount,
    required DateTime date,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Container(
              width: 300,
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Text(
                    'INVOICE',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  pw.Divider(),
                  pw.Text('Ref: $bookingReference'),
                  pw.Text('Tour: $tourName'),
                  pw.Text('Date: ${date.day}/${date.month}/${date.year}'),
                  pw.Divider(),
                  pw.Text(
                    'Total: \$${amount.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    return await pdf.save();
  }
}

// import 'dart:io';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class PdfService {
//   static Future<File> generateBookingVoucher({
//     required String bookingReference,
//     required String customerName,
//     required String tourName,
//     required DateTime travelDate,
//     required int guests,
//     required double totalAmount,
//     required String paymentMethod,
//   }) async {
//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Center(
//                 child: pw.Text(
//                   'Travel & Tour',
//                   style: pw.TextStyle(
//                     fontSize: 24,
//                     fontWeight: pw.FontWeight.bold,
//                     color: PdfColors.blue,
//                   ),
//                 ),
//               ),
//               pw.SizedBox(height: 20),
//               pw.Center(
//                 child: pw.Text(
//                   'Booking Voucher',
//                   style: pw.TextStyle(
//                     fontSize: 18,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//               ),
//               pw.SizedBox(height: 30),
//               pw.Container(
//                 padding: const pw.EdgeInsets.all(20),
//                 decoration: pw.BoxDecoration(
//                   border: pw.Border.all(color: PdfColors.grey),
//                   borderRadius: const pw.BorderRadius.all(
//                     pw.Radius.circular(10),
//                   ),
//                 ),
//                 child: pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     _buildInfoRow('Booking Reference:', bookingReference),
//                     _buildInfoRow('Customer Name:', customerName),
//                     _buildInfoRow('Tour/Package:', tourName),
//                     _buildInfoRow(
//                       'Travel Date:',
//                       '${travelDate.day}/${travelDate.month}/${travelDate.year}',
//                     ),
//                     _buildInfoRow('Number of Guests:', guests.toString()),
//                     _buildInfoRow(
//                       'Total Amount:',
//                       '\$${totalAmount.toStringAsFixed(2)}',
//                     ),
//                     _buildInfoRow('Payment Method:', paymentMethod),
//                     _buildInfoRow('Payment Status:', 'Paid'),
//                     _buildInfoRow(
//                       'Booking Date:',
//                       '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
//                     ),
//                   ],
//                 ),
//               ),
//               pw.SizedBox(height: 30),
//               pw.Text(
//                 'Terms & Conditions:',
//                 style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//               ),
//               pw.SizedBox(height: 10),
//               pw.Text(
//                 '1. This voucher is valid only for the mentioned travel date.',
//                 style: const pw.TextStyle(fontSize: 10),
//               ),
//               pw.Text(
//                 '2. Please carry a printout of this voucher along with valid ID proof.',
//                 style: const pw.TextStyle(fontSize: 10),
//               ),
//               pw.Text(
//                 '3. Cancellation policy applies as per terms agreed at time of booking.',
//                 style: const pw.TextStyle(fontSize: 10),
//               ),
//               pw.SizedBox(height: 30),
//               pw.Center(
//                 child: pw.Text(
//                   'Thank you for choosing Travel & Tour!',
//                   style: pw.TextStyle(
//                     fontSize: 12,
//                     fontStyle: pw.FontStyle.italic,
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );

//     // Save PDF to temporary file
//     final bytes = await pdf.save();
//     final dir = Directory.systemTemp;
//     final file = File('${dir.path}/voucher_$bookingReference.pdf');
//     await file.writeAsBytes(bytes);

//     return file;
//   }

//   static pw.Widget _buildInfoRow(String label, String value) {
//     return pw.Padding(
//       padding: const pw.EdgeInsets.symmetric(vertical: 4),
//       child: pw.Row(
//         children: [
//           pw.Container(
//             width: 120,
//             child: pw.Text(
//               label,
//               style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//             ),
//           ),
//           pw.Text(':'),
//           pw.SizedBox(width: 10),
//           pw.Expanded(child: pw.Text(value)),
//         ],
//       ),
//     );
//   }
// }
