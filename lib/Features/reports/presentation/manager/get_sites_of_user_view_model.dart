import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Features/reports/domain/use_cases/get_sites_of_user_use_case.dart';

import '../../domain/entities/site_entity.dart';
import 'get_sites_states.dart';

@injectable
class GetSitesOfUsersViewModel extends Cubit<GetSitesState> {
  GetSitesOfUserUseCase getSitesOfUserUseCase;

  GetSitesOfUsersViewModel({required this.getSitesOfUserUseCase})
      : super(GetSitesLoadingState());
  List<SiteEntity> originalSitesList = [];
  List<SiteEntity> allSites = [];
  List<SiteEntity> queryMatchList = [];
  bool isLoading = false;
  double opacity = 1.0;

  late AnimationController animationController;
  late Animation<Offset> slideAnimation;

  void initializeAnimation(SingleTickerProviderStateMixin single) {
    animationController = AnimationController(
        vsync: single, duration: const Duration(seconds: 1));

    slideAnimation =
        Tween<Offset>(begin: const Offset(-2, 0), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> getSites(String userId) async {
    isLoading = true;
    emit(GetSitesLoadingState());
    var sitesResponse = await getSitesOfUserUseCase.invoke(userId);
    sitesResponse.fold(
      (failure) {
        isLoading = false;
        emit(GetSitesErrorState(errorMessage: failure.errorMessage));
      },
      (sites) {
        isLoading = false;
        originalSitesList = sites;
        allSites = sites;
        emit(GetSitesSuccessState(sitesList: sites));
        opacity = 1.0;
        emit(GetAllUsersAnimationState());
        animationController.forward();
      },
    );
  }

  void searchSites(String query) {
    if (query.isEmpty) {
      allSites = originalSitesList;
      emit(GetSitesSuccessState(sitesList: allSites));
    } else {
      queryMatchList = allSites
          .where((site) =>
              site.siteName?.toLowerCase().contains(query.toLowerCase()) ??
              false)
          .toList();

      if (queryMatchList.isEmpty) {
        emit(NoSearchResultsState());
      } else {
        allSites = queryMatchList;
        emit(GetSitesSuccessState(sitesList: allSites));
      }
    }
  }
}
