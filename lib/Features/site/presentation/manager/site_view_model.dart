import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Features/register/domain/entities/user_model_entity.dart';
import 'package:pesticides/Features/site/domain/entities/site_entitiy.dart';
import 'package:pesticides/Features/site/presentation/manager/site_state.dart';
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
  List<SiteEntitiy> sites = [];
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
}
