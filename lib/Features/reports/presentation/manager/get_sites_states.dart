import 'package:pesticides/Features/reports/domain/entities/site_entity.dart';

abstract class GetSitesState {}

class GetSitesLoadingState extends GetSitesState {}

class GetSitesErrorState extends GetSitesState {
  String errorMessage;

  GetSitesErrorState({required this.errorMessage});
}

class GetSitesSuccessState extends GetSitesState {
  List<SiteEntity> sitesList;

  GetSitesSuccessState({required this.sitesList});
}
