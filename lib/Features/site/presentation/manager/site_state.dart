import 'package:bug_away/Core/errors/failures.dart';

abstract class SiteState {}

class SiteInitialState extends SiteState {}

class SiteLoadingState extends SiteState {}

class SiteErrorState extends SiteState {
  Failure failure;
  SiteErrorState({required this.failure});
}

class SiteSuccessState extends SiteState {}

//todo ===========================

class UsersSiteLoadingState extends SiteState {}

class UsersSiteErrorState extends SiteState {
  Failure failure;
  UsersSiteErrorState({required this.failure});
}

class UsersSiteSuccessState extends SiteState {}

//todo ===========================

class AddSiteLoadingState extends SiteState {}

class AddSiteErrorState extends SiteState {
  Failure failure;
  AddSiteErrorState({required this.failure});
}

class AddSiteSuccessState extends SiteState {}

//todo =======================

class AnimationsSiteSuccessState extends SiteState {}

//todo ===========================

class GetUserSiteLoadingState extends SiteState {}

class GetUserSiteErrorState extends SiteState {
  Failure failure;
  GetUserSiteErrorState({required this.failure});
}

class GetUserSiteSuccessState extends SiteState {}

//todo ==================================

class DeleteSiteLoadingState extends SiteState {}

class DeleteSiteErrorState extends SiteState {
  Failure failure;
  DeleteSiteErrorState({required this.failure});
}

class DeleteSiteSuccessState extends SiteState {}

//todo =============================
class SearchSiteSuccessState extends SiteState {}

class NoResultSearchSiteSuccessState extends SiteState {}
