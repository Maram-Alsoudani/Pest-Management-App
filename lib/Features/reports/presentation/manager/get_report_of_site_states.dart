import 'package:bug_away/Features/site_report/domain/entities/report_entity.dart';

abstract class GetReportOfSiteState {}

class GetReportOfSiteLoadingState extends GetReportOfSiteState {}

class GetReportOfSiteErrorState extends GetReportOfSiteState {
  String errorMessage;

  GetReportOfSiteErrorState({required this.errorMessage});
}

class GetReportOfSiteSuccessState extends GetReportOfSiteState {
  ReportEntity siteReport;

  GetReportOfSiteSuccessState({required this.siteReport});
}
