import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Features/register/domain/entities/user_model_entity.dart';
import 'package:pesticides/Features/reports/domain/use_cases/get_users_use_case.dart';
import 'package:pesticides/Features/reports/presentation/manager/get_all_users_states.dart';

@injectable
class AllUsersScreenViewModel extends Cubit<GetAllUsersState> {
  GetUsersUseCase getUsersUseCase;

  AllUsersScreenViewModel({required this.getUsersUseCase})
      : super(GetAllUsersLoadingState());

  List<UserAndAdminModelEntity> allUsers = [];
  List<UserAndAdminModelEntity> queryMatchList = [];

  Future<void> getUsers() async {
    emit(GetAllUsersLoadingState());
    var result = await getUsersUseCase.invoke();
    result.fold(
      (failure) =>
          emit(GetAllUsersErrorState(errorMessage: failure.errorMessage)),
      (users) {
        allUsers = users;
        emit(GetAllUsersSuccessState(usersList: users));
      },
    );
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      emit(GetAllUsersSuccessState(usersList: allUsers));
    } else {
      queryMatchList = allUsers
          .where((user) =>
              user.userName?.toLowerCase().contains(query.toLowerCase()) ??
              false)
          .toList();

      if (queryMatchList.isEmpty) {
        emit(NoSearchResultsState());
      } else {
        emit(GetAllUsersSuccessState(usersList: queryMatchList));
      }
    }
  }
}
