import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Features/register/domain/entities/user_model_entity.dart';
import 'package:bug_away/Features/site/presentation/manager/site_state.dart';

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

  // Get user from shared preferences
  UserAndAdminModelEntity? getUser() {
    return SharedPrefsLocal.getData(key: StringManager.userAdmin);
  }

  // Add site to Firebase
  void addSite() async {
    emit(AddSiteLoadingState());
    final result = await addSiteUserCase.invoke(
      siteNameController.text,
      siteLocationController.text,
      selectedValue!.id ?? "",
      selectedValue!.userName ?? "",
    );
    result.fold(
      (failure) => emit(AddSiteErrorState(failure: failure)),
      (_) => emit(AddSiteSuccessState()),
    );
  }

  // Fetch users from Firebase
  Future<void> fetchUsers() async {
    isLoading = true;
    emit(UsersSiteLoadingState());
    final result = await fetchUsersDataUseCase.invoke();
    result.fold(
      (failure) {
        isLoading = false;
        emit(UsersSiteErrorState(failure: failure));
      },
      (users) {
        this.users = users;
        isLoading = false;
        emit(UsersSiteSuccessState());
      },
    );
  }

  // Fetch sites from Firebase
  Future<void> fetchSite() async {
    isLoading = true;
    emit(SiteLoadingState());
    final result = await fetchSiteDataUseCase.invoke();
    result.fold(
      (failure) {
        isLoading = false;
        emit(SiteErrorState(failure: failure));
      },
      (sites) {
        this.sites = sites;
        searchedSites = sites;
        isLoading = false;
        emit(SiteSuccessState());
      },
    );
  }

  // Clear data
  void clearDate() {
    siteNameController.clear();
    siteLocationController.clear();
    selectedValue = null;
  }

  // Fetch user sites from Firebase
  Future<void> fetchUserSites() async {
    isLoading = true;
    emit(GetUserSiteLoadingState());
    final result = await fetchUsersSitesUseCase.invoke(user.id!);
    result.fold(
      (failure) {
        isLoading = false;
        emit(GetUserSiteErrorState(failure: failure));
      },
      (sites) {
        userSites = sites;
        isLoading = false;
        emit(GetUserSiteSuccessState());
      },
    );
  }

  // Delete site from Firebase
  Future<void> deleteSite(SiteEntity site) async {
    isLoading = true;
    emit(DeleteSiteLoadingState());
    final result = await deleteSitesUseCase.invoke(site);
    result.fold(
      (failure) {
        isLoading = false;
        emit(DeleteSiteErrorState(failure: failure));
      },
      (_) {
        isLoading = false;
        emit(DeleteSiteSuccessState());
      },
    );
  }

  // Animations
  late AnimationController animationController;
  late Animation<Offset> slideAnimation;
  double opacity = 0.0;

  void doAnimation(TickerProvider ticker) {
    animationController = AnimationController(
      vsync: ticker,
      duration: const Duration(seconds: 1),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    Future.delayed(const Duration(milliseconds: 300), () {
      opacity = 1.0;
      animationController.forward();
      emit(AnimationsSiteSuccessState());
    });
  }

  @override
  Future<void> close() {
    animationController.dispose();
    return super.close();
  }

  // Search
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
