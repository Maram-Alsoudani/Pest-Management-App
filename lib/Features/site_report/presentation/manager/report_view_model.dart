import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Features/site_report/presentation/manager/report_state.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../../../Core/component/custom_dialog.dart';
import '../../../../Core/utils/SharedPrefsLocal.dart';
import '../../../../Core/utils/firebase_utils.dart';
import '../../../../Core/utils/strings.dart';
import '../../../../Core/utils/pdf_utils.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/use_cases/create_report_use_case.dart';
import '../../domain/use_cases/fetch_reports_use_case.dart';
import 'package:bug_away/Config/routes/routes_manger.dart';

@injectable
class ReportViewModel extends Cubit<ReportState> {
  final CreateReportUseCase createReportUseCase;
  final FetchReportsUseCase fetchReportsUseCase;

  String _notes = '';
  String _conditions = '';
  List<String> _recommendations = [];
  Map<String, int> _materials = {};
  Map<String, int> _availableQuantities = {};
  List<String> _devices = [];
  List<String> _photos = [];
  List<String> _signatures = [];
  String? userName;

  ReportViewModel(this.createReportUseCase, this.fetchReportsUseCase)
      : super(ReportInitial());

  Future<void> createReport(ReportEntity report, BuildContext context) async {
    emit(ReportLoading());

    // Get the current user's information
    userName = SharedPrefsLocal.getData(key: StringManager.userAdmin)?.userName;

    // Upload photos and signatures to Firebase Storage
    final photoUrls = await Future.wait(_photos.map((path) async {
      final result = await FirebaseUtils.addImageToFirebaseStorage(File(path));
      return result.fold((failure) => null, (url) => url);
    }).toList());

    final signatureUrls = await Future.wait(_signatures.map((path) async {
      final result = await FirebaseUtils.addImageToFirebaseStorage(File(path));
      return result.fold((failure) => null, (url) => url);
    }).toList());

    // Filter out null values
    final nonNullPhotoUrls = photoUrls.whereType<String>().toList();
    final nonNullSignatureUrls = signatureUrls.whereType<String>().toList();

    final updatedReport = report.copyWith(
      photos: nonNullPhotoUrls,
      signatures: nonNullSignatureUrls,
      createdBy: userName,
    );

    final result = await createReportUseCase(updatedReport);
    result.fold(
      (failure) {
        emit(ReportError(failure.errorMessage));
        DialogUtils.showAlertDialog(
          context: context,
          title: StringManager.error,
          message: failure.errorMessage,
          posActionTitle: StringManager.ok,
        );
      },
      (_) async {
        // Subtract material quantities from inventory
        for (var entry in _materials.entries) {
          try {
            await FirebaseUtils.updateMaterialQuantityByName(
                entry.key, -entry.value);
          } catch (e) {
            DialogUtils.showAlertDialog(
              context: context,
              title: StringManager.error,
              message:
                  "Error updating material quantity for name ${entry.key}: $e",
              posActionTitle: StringManager.ok,
            );
          }
        }

        emit(ReportCreated());
        clearForm();
        DialogUtils.showAlertDialog(
          context: context,
          title: StringManager.success,
          message: StringManager.reportSubmitSuccess,
          posActionTitle: StringManager.ok,
          posAction: () {
            Navigator.popUntil(context,
                ModalRoute.withName(RoutesManger.routeNameCategoryScreen));
          },
        );
      },
    );
  }

  Future<void> generateAndDownloadPdf(ReportEntity report) async {
    // Read photos and signatures as bytes
    final photoBytes = await Future.wait(report.photos.map((path) async {
      if (path != 'No photos') {
        final file = File(path);
        return await file.readAsBytes();
      }
      return Uint8List(0);
    }).toList());

    final signatureBytes =
        await Future.wait(report.signatures.map((path) async {
      if (path != 'No signatures') {
        final file = File(path);
        return await file.readAsBytes();
      }
      return Uint8List(0);
    }).toList());

    // Generate PDF report
    final pdfData = await PdfUtils.generatePdfReport(
      title: report.siteName,
      notes: report.notes,
      conditions: report.conditions,
      recommendations: report.recommendations,
      materialUsages: report.materialUsages,
      photos: photoBytes.where((bytes) => bytes.isNotEmpty).toList(),
      devices: report.devices,
      signatures: signatureBytes.where((bytes) => bytes.isNotEmpty).toList(),
      submittedBy: report.createdBy,
    );

    // Generate PDF file name
    final pdfFileName = PdfUtils.generatePdfFileName(report.siteName);

    // Share or download the PDF
    await Printing.sharePdf(bytes: pdfData, filename: pdfFileName);
  }

  void fetchReports(String userId) async {
    emit(ReportLoading());
    final result = await fetchReportsUseCase(userId);
    result.fold(
      (failure) => emit(ReportError(failure.errorMessage)),
      (reports) => emit(ReportsLoaded(reports)),
    );
  }

  void updateNotes(String notes) {
    _notes = notes;
  }

  String get notes => _notes;

  void updateConditions(String conditions) {
    _conditions = conditions;
  }

  String get conditions => _conditions;

  void updateRecommendations(List<String> recommendations) {
    _recommendations = recommendations;
  }

  List<String> get recommendations => _recommendations;

  void updateMaterials(Map<String, int> materials) {
    _materials = materials;
  }

  Map<String, int> get materials => _materials;

  void updateAvailableQuantities(Map<String, int> availableQuantities) {
    _availableQuantities = availableQuantities;
  }

  Map<String, int> get availableQuantities => _availableQuantities;

  void updateDevices(List<String> devices) {
    _devices = devices;
  }

  List<String> get devices => _devices;

  void updatePhotos(List<String> photos) {
    _photos = photos;
  }

  List<String> get photos => _photos;

  void updateSignatures(List<String> signatures) {
    _signatures = signatures;
  }

  List<String> get signatures => _signatures;

  void clearForm() {
    _notes = '';
    _conditions = '';
    _recommendations = [];
    _materials = {};
    _availableQuantities = {};
    _devices = [];
    _photos = [];
    _signatures = [];
  }
}
