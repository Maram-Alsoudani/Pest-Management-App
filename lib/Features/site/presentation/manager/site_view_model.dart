import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Features/register/domain/entities/user_model_entity.dart';
import 'package:pesticides/Features/site/presentation/manager/site_state.dart';
import '../../../reports/domain/entities/site_entity.dart';
import '../../domain/use_cases/add_site_user_case.dart';
import '../../domain/use_cases/fetch_site_data_use_case.dart';
import '../../domain/use_cases/fetch_user_data_user_case.dart';

@injectable
class SiteViewModel extends Cubit<SiteState> {
  final fromKey = GlobalKey<FormState>();
  AddSiteUserCase addSiteUserCase;
  FetchSiteDataUseCase fetchSiteDataUseCase;
  FetchUsersDataUseCase fetchUsersDataUseCase;
  List<UserAndAdminModelEntity> users = [];
  List<SiteEntity> sites = [];
  UserAndAdminModelEntity? selectedValue;
  TextEditingController siteNameController = TextEditingController();
  TextEditingController siteLocationController = TextEditingController();

  bool isLoading = false;

  static SiteViewModel get(context) => BlocProvider.of<SiteViewModel>(context);

  SiteViewModel(
      {required this.addSiteUserCase,
      required this.fetchSiteDataUseCase,
      required this.fetchUsersDataUseCase})
      : super(SiteInitialState());

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
//todo ============= Get Sites from fire base =================

  Future<void> fetchSite() async {
    isLoading = true;
    emit(SiteLoadingState());
    var data = await fetchSiteDataUseCase.invoke();
    data.fold((l) {
      isLoading = false;
      emit(SiteErrorState(failure: l));
    }, (r) {
      isLoading = false;
      sites = r;
      emit(SiteSuccessState());
    });
  }

  void clearDate() {
    siteNameController.clear();
    siteLocationController.clear();
    selectedValue = null;
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
}
