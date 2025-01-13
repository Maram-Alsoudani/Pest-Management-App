import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/register/domain/entities/user_model_entity.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final UserAndAdminModelEntity user;

  ProfileSuccess({required this.user});
}

class ProfileLoading extends ProfileState {}

class ProfileError extends ProfileState {
  final Failure error;

  ProfileError({required this.error});
}

class ProfileChangeImage extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {}

class ProfileAnimationSuccess extends ProfileState {}

class ProfileUpdateLoading extends ProfileState {}

class ProfileUpdateError extends ProfileState {
  final Failure error;

  ProfileUpdateError({required this.error});
}

class ProfileLogOutSuccess extends ProfileState {}

class ProfileLogOutLoading extends ProfileState {}

class ProfileLogOutError extends ProfileState {
  final Failure error;

  ProfileLogOutError({required this.error});
}
