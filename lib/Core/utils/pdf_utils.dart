import 'package:flutter/services.dart'; // Import the services package
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:bug_away/Core/utils/color_extension.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/strings.dart';

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
    required String submittedBy,
  }) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'Site: $title',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color:
                          PdfColor.fromHex(ColorManager.primaryColor.toHex()),
                      font: ttf,
                    ),
                  ),
                ),
                pw.SizedBox(height: 7.2),
                pw.Divider(
                  color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
                ),
                pw.SizedBox(height: 7.2),
                pw.Text(
                  StringManager.notes,
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
                    font: ttf,
                  ),
                ),
                pw.SizedBox(height: 7.2),
                pw.Text(notes, style: pw.TextStyle(fontSize: 16, font: ttf)),
                pw.Divider(
                  color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
                ),
                pw.SizedBox(height: 7.2),
                pw.Text(
                  StringManager.conditions,
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
                    font: ttf,
                  ),
                ),
                pw.SizedBox(height: 7.2),
                pw.Text(conditions,
                    style: pw.TextStyle(fontSize: 16, font: ttf)),
                pw.Divider(
                  color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
                ),
                pw.SizedBox(height: 7.2),
                pw.Text(
                  StringManager.recommendations,
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
                    font: ttf,
                  ),
                ),
                pw.SizedBox(height: 7.2),
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
                pw.SizedBox(height: 7.2),
                pw.Text(
                  StringManager.materialUsages,
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
                    font: ttf,
                  ),
                ),
                pw.SizedBox(height: 7.2),
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
                pw.SizedBox(height: 7.2),
                pw.Text(
                  StringManager.photos,
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
                    font: ttf,
                  ),
                ),
                pw.SizedBox(height: 7.2),
                pw.Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: photos
                      .map((photo) => pw.Container(
                            width: 90,
                            height: 90,
                            decoration: pw.BoxDecoration(
                              borderRadius: pw.BorderRadius.circular(12),
                              border: pw.Border.all(
                                color: PdfColor.fromHex(
                                    ColorManager.primaryColor.toHex()),
                                width: 2,
                              ),
                            ),
                            child: pw.ClipRRect(
                              verticalRadius: 12,
                              horizontalRadius: 12,
                              child: pw.Image(
                                pw.MemoryImage(photo),
                                fit: pw.BoxFit.cover,
                              ),
                            ),
                          ))
                      .toList(),
                ),
                pw.Divider(
                  color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
                ),
                pw.SizedBox(height: 7.2),
                pw.Text(
                  StringManager.devices,
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
                    font: ttf,
                  ),
                ),
                pw.SizedBox(height: 7.2),
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
                pw.SizedBox(height: 7.2),
                pw.Text(
                  StringManager.signatures,
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
                    font: ttf,
                  ),
                ),
                pw.SizedBox(height: 7.2),
                pw.Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: signatures
                      .map((signature) => pw.Container(
                            width: 90,
                            height: 90,
                            decoration: pw.BoxDecoration(
                              borderRadius: pw.BorderRadius.circular(12),
                              border: pw.Border.all(
                                color: PdfColor.fromHex(
                                    ColorManager.primaryColor.toHex()),
                                width: 2,
                              ),
                            ),
                            child: pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Image(pw.MemoryImage(signature),
                                  fit: pw.BoxFit.fill),
                            ),
                          ))
                      .toList(),
                ),
                pw.Divider(
                  color: PdfColor.fromHex(ColorManager.primaryColor.toHex()),
                ),
                pw.SizedBox(height: 7.2),
                pw.Center(
                  child: pw.Text(
                    'Submitted by: $submittedBy',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color:
                          PdfColor.fromHex(ColorManager.primaryColor.toHex()),
                      font: ttf,
                    ),
                  ),
                ),
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static String generatePdfFileName(String siteName) {
    return '${siteName}_Report.pdf';
  }
}
