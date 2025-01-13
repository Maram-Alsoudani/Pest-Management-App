import '../../../register/domain/entities/user_model_entity.dart';

abstract class GetAllUsersState {}

class GetAllUsersLoadingState extends GetAllUsersState {}

class GetAllUsersErrorState extends GetAllUsersState {
  String errorMessage;

  GetAllUsersErrorState({required this.errorMessage});
}

class GetAllUsersSuccessState extends GetAllUsersState {
  List<UserAndAdminModelEntity?> usersList;

  GetAllUsersSuccessState({required this.usersList});
}

class NoSearchResultsState extends GetAllUsersState {}

class GetAllUsersAnimationState extends GetAllUsersState {}

