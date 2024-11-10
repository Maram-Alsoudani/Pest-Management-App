import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Features/reports/domain/use_cases/get_sites_of_user_use_case.dart';
import 'package:pesticides/Features/reports/presentation/manager/get_sites_states.dart';

@injectable
class GetSitesOfUsersViewModel extends Cubit<GetSitesState> {
  GetSitesOfUserUseCase getSitesOfUserUseCase;

  GetSitesOfUsersViewModel({required this.getSitesOfUserUseCase})
      : super(GetSitesLoadingState());

  Future<void> getSites(String userId) async {
    emit(GetSitesLoadingState());
    var sitesResponse = await getSitesOfUserUseCase.invoke(userId);
    sitesResponse.fold(
      (failure) => emit(GetSitesErrorState(errorMessage: failure.errorMessage)),
      (sites) {
        emit(GetSitesSuccessState(sitesList: sites));
      },
    );
  }
}
