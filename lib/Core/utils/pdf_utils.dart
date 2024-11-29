import 'dart:typed_data';
import 'package:flutter/services.dart'; // Import the services package
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pesticides/Core/utils/color_extension.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/strings.dart';

class PdfUtils {
  static Future<Uint8List> generatePdfReport({
    required String title,
    required String notes,
    required String conditions,
    required List<String> recommendations,
    required Map<String, int> materialUsages,
    required List<Uint8List> photos,
    required List<String> devices,
    required List<Uint8List> signatures,
  }) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  title,
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
                    font: ttf,
                  ),
                ),
              ),
              pw.Divider(
                color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                StringManager.notes,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
                  font: ttf,
                ),
              ),
              pw.Text(notes, style: pw.TextStyle(fontSize: 16, font: ttf)),
              pw.Divider(
                color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                StringManager.conditions,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
                  font: ttf,
                ),
              ),
              pw.Text(conditions, style: pw.TextStyle(fontSize: 16, font: ttf)),
              pw.Divider(
                color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                StringManager.recommendations,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
                  font: ttf,
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: recommendations
                    .map((rec) => pw.Text(rec,
                        style: pw.TextStyle(fontSize: 16, font: ttf)))
                    .toList(),
              ),
              pw.Divider(
                color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                StringManager.materialUsages,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
                  font: ttf,
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: materialUsages.entries
                    .map((entry) => pw.Text('${entry.key}: ${entry.value}',
                        style: pw.TextStyle(fontSize: 16, font: ttf)))
                    .toList(),
              ),
              pw.Divider(
                color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                StringManager.photos,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
                  font: ttf,
                ),
              ),
              pw.Wrap(
                spacing: 8,
                runSpacing: 8,
                children: photos
                    .map((photo) => pw.Image(pw.MemoryImage(photo),
                        width: 100, height: 100))
                    .toList(),
              ),
              pw.Divider(
                color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                StringManager.devices,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
                  font: ttf,
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: devices
                    .map((device) => pw.Text(device,
                        style: pw.TextStyle(fontSize: 16, font: ttf)))
                    .toList(),
              ),
              pw.Divider(
                color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                StringManager.signatures,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
                  font: ttf,
                ),
              ),
              pw.Wrap(
                spacing: 8,
                runSpacing: 8,
                children: signatures
                    .map((signature) => pw.Image(pw.MemoryImage(signature),
                        width: 100, height: 100))
                    .toList(),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static String generatePdfFileName(String siteName) {
    return '${siteName}_Report.pdf';
  }
}
