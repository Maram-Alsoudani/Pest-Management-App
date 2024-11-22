import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Features/register/domain/entities/user_model_entity.dart';
import 'package:pesticides/Features/site/presentation/manager/site_state.dart';

import '../../../../Core/utils/SharedPrefsLocal.dart';
import '../../../../Core/utils/strings.dart';
import '../../../reports/domain/entities/site_entity.dart';
import '../../domain/use_cases/add_site_user_case.dart';
import '../../domain/use_cases/delete_sites_user_case.dart';
import '../../domain/use_cases/fetch_site_data_use_case.dart';
import '../../domain/use_cases/fetch_user_data_user_case.dart';
import '../../domain/use_cases/fetch_user_sites_user_case.dart';

@injectable
class SiteViewModel extends Cubit<SiteState> {
  final fromKey = GlobalKey<FormState>();
  AddSiteUserCase addSiteUserCase;
  FetchSiteDataUseCase fetchSiteDataUseCase;
  FetchUsersDataUseCase fetchUsersDataUseCase;
  FetchUsersSitesUseCase fetchUsersSitesUseCase;
  DeleteSitesUseCase deleteSitesUseCase;
  List<UserAndAdminModelEntity> users = [];
  late UserAndAdminModelEntity user;
  SiteEntity? site;
  List<SiteEntity> sites = [];
  List<SiteEntity> userSites = [];
  List<SiteEntity> searchedSites = [];
  UserAndAdminModelEntity? selectedValue;
  TextEditingController siteNameController = TextEditingController();
  TextEditingController siteLocationController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  bool isLoading = false;

  static SiteViewModel get(context) => BlocProvider.of<SiteViewModel>(context);

  SiteViewModel(
      {required this.addSiteUserCase,
      required this.fetchSiteDataUseCase,
      required this.fetchUsersDataUseCase,
      required this.fetchUsersSitesUseCase,
      required this.deleteSitesUseCase})
      : super(SiteInitialState());

  //todo ============== get user from shared pref ==========

  UserAndAdminModelEntity? getUser() {
    var user = SharedPrefsLocal.getData(key: StringManager.keyUserAdmin);
    return user;
  }

  //todo  ================= Add site to fire base =================
  void addSite() async {
    emit(AddSiteLoadingState());
    var either = await addSiteUserCase.invoke(siteNameController.text,
        siteLocationController.text, selectedValue!.id ?? "");

    either.fold((l) {
      emit(AddSiteErrorState(failure: l));
    }, (response) {
      emit(AddSiteSuccessState());
    });
  }

  //todo =========== get user from fire base ===================

  Future<void> fetchUsers() async {
    isLoading = true;
    emit(UsersSiteLoadingState());
    var data = await fetchUsersDataUseCase.invoke();
    data.fold((l) {
      isLoading = false;
      emit(UsersSiteErrorState(failure: l));
    }, (r) {
      isLoading = false;
      users = r;
      emit(UsersSiteSuccessState());
    });
  }

//todo ============= Get Sites from firebase =================

  Future<void> fetchSite() async {
    isLoading = true;
    emit(SiteLoadingState());
    var data = await fetchSiteDataUseCase.invoke();
    data.fold((l) {
      isLoading = false;
      emit(SiteErrorState(failure: l));
    }, (r) {
      if (r.isNotEmpty) {
        sites = r;
        searchedSites = sites;
        isLoading = false;
        emit(SiteSuccessState());
      } else {
        isLoading = false;
        emit(NoResultSearchSiteSuccessState());
      }
    });
  }

  //todo ================= clear =============
  void clearDate() {
    siteNameController.clear();
    siteLocationController.clear();
    selectedValue = null;
  }

  //todo ================= get user sites =============

  Future<void> fetchUserSites() async {
    isLoading = true;
    emit(GetUserSiteLoadingState());
    var data = await fetchUsersSitesUseCase.invoke(user.id!);
    data.fold((l) {
      isLoading = false;
      emit(GetUserSiteErrorState(failure: l));
    }, (r) {
      userSites = r;
      isLoading = false;
      emit(GetUserSiteSuccessState());
    });
  }

//todo ========================= Delete Sites ============

  Future<void> deleteSite(SiteEntity site) async {
    isLoading = true;
    emit(DeleteSiteLoadingState());
    var data = await deleteSitesUseCase.invoke(site);
    data.fold((l) {
      isLoading = false;
      emit(DeleteSiteErrorState(failure: l));
    }, (r) {
      isLoading = false;
      emit(DeleteSiteSuccessState());
    });
  }

  //todo ============= Animations =========================

  late AnimationController animationController;
  late Animation<Offset> slideAnimation;
  double opacity = 0.0;

  void doAnimation(SingleTickerProviderStateMixin single) {
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      opacity = 1.0;
      emit(AnimationsSiteSuccessState());

      animationController.forward();
    });
  }

  //todo ======== Search ====================
  void filterSites(String query) {
    if (query.isEmpty) {
      searchedSites = sites;
    } else {
      searchedSites = sites
          .where((site) =>
              site.siteName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    if (searchedSites.isEmpty) {
      emit(NoResultSearchSiteSuccessState());
    } else {
      emit(SearchSiteSuccessState());
    }
  }
}
