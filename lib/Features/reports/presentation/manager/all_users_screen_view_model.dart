import 'package:flutter/cupertino.dart';
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
        allUsers = users;
        isLoading = false;
        emit(GetAllUsersSuccessState(usersList: users));

        WidgetsBinding.instance.addPostFrameCallback((_) {
          opacity = 1.0;
          emit(GetAllUsersAnimationState());
          animationController.forward();
        });
      },
    );
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      emit(GetAllUsersSuccessState(usersList: allUsers));
      animationController.forward(from: 0);
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
        animationController.forward(from: 0);
      }
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close

    return super.close();
  }
}
