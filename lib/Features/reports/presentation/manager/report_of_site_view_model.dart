import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:bug_away/Features/reports/domain/use_cases/get_report_of_site.dart';
import 'package:bug_away/Features/reports/presentation/manager/get_report_of_site_states.dart';
import 'package:printing/printing.dart';
import '../../../../Core/utils/pdf_utils.dart';
import '../../../site_report/domain/entities/report_entity.dart';

@injectable
class ReportOfSiteViewModel extends Cubit<GetReportOfSiteState> {
  GetReportOfSiteUseCase useCase;

  ReportOfSiteViewModel({required this.useCase})
      : super(GetReportOfSiteLoadingState());
  bool isLoading = false;
  double opacity = 1.0;

  late AnimationController animationController;
  late Animation<Offset> slideAnimation;

  void initializeAnimation(SingleTickerProviderStateMixin single) {
    animationController = AnimationController(
        vsync: single, duration: const Duration(seconds: 1));

    slideAnimation =
        Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
    animationController.forward();
  }

  Future<void> getReportOfSite(String siteId) async {
    isLoading = true;
    emit(GetReportOfSiteLoadingState());
    var reportResponse = await useCase.invoke(siteId);
    reportResponse.fold((failure) {
      isLoading = false;
      emit(GetReportOfSiteErrorState(errorMessage: failure.errorMessage));
    }, (report) {
      isLoading = false;
      emit(GetReportOfSiteSuccessState(siteReport: report));
    });
  }

  Future<void> generateAndDownloadPdf(ReportEntity report) async {
    // Use the createdBy field from the report
    String submittedBy = report.createdBy;

    // Download photos and signatures as bytes
    final photoBytes = await Future.wait(report.photos.map((url) async {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load photo');
      }
    }).toList());

    final signatureBytes = await Future.wait(report.signatures.map((url) async {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load signature');
      }
    }).toList());

    // Generate PDF report
    final pdfData = await PdfUtils.generatePdfReport(
      title: report.siteName,
      notes: report.notes,
      conditions: report.conditions,
      recommendations: report.recommendations,
      materialUsages: report.materialUsages,
      photos: photoBytes,
      devices: report.devices,
      signatures: signatureBytes,
      submittedBy: submittedBy,
    );

    // Generate PDF file name
    final pdfFileName = PdfUtils.generatePdfFileName(report.siteName);

    // Share or download the PDF
    await Printing.sharePdf(bytes: pdfData, filename: pdfFileName);
  }

  @override
  Future<void> close() {
    animationController.dispose();
    return super.close();
  }
}
