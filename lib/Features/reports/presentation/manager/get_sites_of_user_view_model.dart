import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Features/reports/domain/use_cases/get_sites_of_user_use_case.dart';
import 'package:pesticides/Features/reports/presentation/manager/get_sites_states.dart';

@injectable
class GetSitesOfUsersViewModel extends Cubit<GetSitesState> {
  GetSitesOfUserUseCase getSitesOfUserUseCase;

  GetSitesOfUsersViewModel({required this.getSitesOfUserUseCase})
      : super(GetSitesLoadingState());

  bool isLoading = false;

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
        emit(GetSitesSuccessState(sitesList: sites));

        animationController.forward(from: 0);
      },
    );
  }
}
