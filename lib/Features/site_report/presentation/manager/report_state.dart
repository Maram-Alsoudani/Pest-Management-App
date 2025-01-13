import 'package:bug_away/Features/site_report/domain/entities/report_entity.dart';

abstract class ReportState {
  const ReportState();

  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportCreated extends ReportState {}

class ReportError extends ReportState {
  final String message;

  const ReportError(this.message);

  @override
  List<Object> get props => [message];
}

class ReportsLoaded extends ReportState {
  final List<ReportEntity> reports;

  const ReportsLoaded(this.reports);

  @override
  List<Object> get props => [reports];
}
