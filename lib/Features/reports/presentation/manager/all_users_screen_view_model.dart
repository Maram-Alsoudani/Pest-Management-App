import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Features/register/domain/entities/user_model_entity.dart';
import 'package:bug_away/Features/reports/domain/use_cases/get_users_use_case.dart';

import 'get_all_users_states.dart';

@injectable
class AllUsersScreenViewModel extends Cubit<GetAllUsersState> {
  GetUsersUseCase getUsersUseCase;

  AllUsersScreenViewModel({required this.getUsersUseCase})
      : super(GetAllUsersLoadingState());

  List<UserAndAdminModelEntity> originalUsersList = [];
  List<UserAndAdminModelEntity> allUsers = [];
  List<UserAndAdminModelEntity> queryMatchList = [];

  bool isLoading = false;

  late AnimationController animationController;
  late Animation<Offset> slideAnimation;
  double opacity = 0.0;

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

  Future<void> getUsers() async {
    isLoading = true;
    emit(GetAllUsersLoadingState());

    var result = await getUsersUseCase.invoke();
    result.fold(
      (failure) {
        isLoading = false;
        emit(GetAllUsersErrorState(errorMessage: failure.errorMessage));
      },
      (users) {
        originalUsersList = users;
        allUsers = users;
        isLoading = false;
        emit(GetAllUsersSuccessState(usersList: users));
        opacity = 1.0;
        emit(GetAllUsersAnimationState());
        animationController.forward();
      },
    );
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      allUsers = originalUsersList;
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
        allUsers = queryMatchList;
        emit(GetAllUsersSuccessState(usersList: allUsers));
      }
    }
  }
}
