import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Features/site_report/presentation/manager/report_state.dart';
import 'package:flutter/material.dart';
import '../../../../Core/component/custom_dialog.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/use_cases/create_report_use_case.dart';
import '../../domain/use_cases/fetch_reports_use_case.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';

@injectable
class ReportViewModel extends Cubit<ReportState> {
  final CreateReportUseCase createReportUseCase;
  final FetchReportsUseCase fetchReportsUseCase;

  String _notes = '';
  String _conditions = '';
  List<String> _recommendations = [];
  Map<String, int> _materials = {};
  List<String> _devices = [];
  List<String> _photos = [];
  List<String> _signatures = [];

  ReportViewModel(this.createReportUseCase, this.fetchReportsUseCase)
      : super(ReportInitial());

  Future<void> createReport(ReportEntity report, BuildContext context) async {
    emit(ReportLoading());
    final result = await createReportUseCase(report);
    result.fold(
      (failure) {
        emit(ReportError(failure.errorMessage));
        DialogUtils.showAlertDialog(
          context: context,
          title: 'Error',
          message: failure.errorMessage,
          posActionTitle: 'OK',
        );
      },
      (_) {
        emit(ReportCreated());
        clearForm();
        DialogUtils.showAlertDialog(
          context: context,
          title: 'Success',
          message: 'Report submitted successfully.',
          posActionTitle: 'OK',
          posAction: () {
            Navigator.popUntil(context,
                ModalRoute.withName(RoutesManger.routeNameCategoryScreen));
          },
        );
      },
    );
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
    _devices = [];
    _photos = [];
    _signatures = [];
  }
}
