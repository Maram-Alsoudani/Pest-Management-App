// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../Features/category/data/data_source/category_data_source.dart'
    as _i903;
import '../Features/category/data/data_source/impl/category_data_source_impl.dart'
    as _i53;
import '../Features/category/data/repo/category_repo_impl.dart' as _i781;
import '../Features/category/domin/repo/category_repo.dart' as _i78;
import '../Features/category/domin/use_case/edit_image.dart' as _i43;
import '../Features/category/domin/use_case/edit_user_data_use_case.dart'
    as _i706;
import '../Features/category/domin/use_case/read_user_or_admin_from_fireStore_use_case.dart'
    as _i899;
import '../Features/category/presentation/manager/category_cubit.dart' as _i386;
import '../Features/category/profile/presentation/manager/profile_cubit.dart'
    as _i833;
import '../Features/forgotPassword/data/data_sources/forget_password_data_source.dart'
    as _i134;
import '../Features/forgotPassword/data/data_sources/forget_password_data_source_impl.dart'
    as _i290;
import '../Features/forgotPassword/data/repositories/forget_password_repository_impl.dart'
    as _i657;
import '../Features/forgotPassword/domain/repositories/forget_password_repository.dart'
    as _i58;
import '../Features/forgotPassword/domain/use_cases/forget_password_user_case.dart'
    as _i513;
import '../Features/forgotPassword/presentation/manager/forget_password_view_model.dart'
    as _i1037;
import '../Features/login/data/data_sources/login_data_source.dart' as _i121;
import '../Features/login/data/data_sources/login_data_source_impl.dart'
    as _i535;
import '../Features/login/data/repositories/login_repository_impl.dart'
    as _i313;
import '../Features/login/domain/repositories/login_repository.dart' as _i558;
import '../Features/login/domain/use_cases/login_use_case.dart' as _i203;
import '../Features/login/presentation/manager/cubit/login_screen_view_model.dart'
    as _i1073;
import '../Features/register/data/data_source/data/register_data_source.dart'
    as _i969;
import '../Features/register/data/data_source/register_data_source_impl.dart'
    as _i1056;
import '../Features/register/data/repositories/register_repo_impl.dart'
    as _i391;
import '../Features/register/domain/repositories/register_repo.dart' as _i20;
import '../Features/register/domain/use_cases/register_use_case.dart' as _i841;
import '../Features/register/presentation/manager/register_view_model_cubit.dart'
    as _i451;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i903.CategoryDataSource>(() => _i53.CategoryDataSourceImpl());
    gh.factory<_i134.ForgetPasswordDataSource>(
        () => _i290.ForgetPasswordDataSourceImpl());
    gh.factory<_i121.LoginDataSource>(() => _i535.LoginDataSourceImpl());
    gh.factory<_i969.RegisterDataSource>(() => _i1056.RegisterDataSourceImpl());
    gh.factory<_i78.CategoryRepo>(() => _i781.CategoryRepoImpl(
        categoryDataSource: gh<_i903.CategoryDataSource>()));
    gh.factory<_i58.ForgetPasswordRepository>(() =>
        _i657.ForgetPasswordRepositoryImpl(
            forgetPasswordDataSource: gh<_i134.ForgetPasswordDataSource>()));
    gh.factory<_i20.RegisterRepo>(() => _i391.RegisterRepoImpl(
        registerDataSource: gh<_i969.RegisterDataSource>()));
    gh.factory<_i558.LoginRepository>(() => _i313.LoginRepositoryImpl(
        loginDataSource: gh<_i121.LoginDataSource>()));
    gh.factory<_i513.ForgetPasswordUserCase>(() => _i513.ForgetPasswordUserCase(
        forgetPasswordRepository: gh<_i58.ForgetPasswordRepository>()));
    gh.factory<_i899.ReadUserOrAdminFromFireStoreUseCase>(() =>
        _i899.ReadUserOrAdminFromFireStoreUseCase(
            categoryRepo: gh<_i78.CategoryRepo>()));
    gh.factory<_i706.EditUserDataUserCase>(() =>
        _i706.EditUserDataUserCase(categoryRepo: gh<_i78.CategoryRepo>()));
    gh.factory<_i43.EditImageInFireStoreUseCase>(() =>
        _i43.EditImageInFireStoreUseCase(
            categoryRepo: gh<_i78.CategoryRepo>()));
    gh.factory<_i833.ProfileCubit>(() => _i833.ProfileCubit(
          readUserOrAdminFromFireStoreUseCase:
              gh<_i899.ReadUserOrAdminFromFireStoreUseCase>(),
          editUserDataUserCase: gh<_i706.EditUserDataUserCase>(),
          editImageInFireStoreUseCase: gh<_i43.EditImageInFireStoreUseCase>(),
        ));
    gh.factory<_i386.CategoryCubit>(() => _i386.CategoryCubit(
        readUserOrAdminFromFireStoreUseCase:
            gh<_i899.ReadUserOrAdminFromFireStoreUseCase>()));
    gh.factory<_i1037.ForgetPasswordViewModel>(() =>
        _i1037.ForgetPasswordViewModel(
            forgetPasswordUseCase: gh<_i513.ForgetPasswordUserCase>()));
    gh.factory<_i841.RegisterUseCase>(
        () => _i841.RegisterUseCase(registerRepo: gh<_i20.RegisterRepo>()));
    gh.factory<_i203.LoginUseCase>(
        () => _i203.LoginUseCase(loginRepository: gh<_i558.LoginRepository>()));
    gh.factory<_i1073.LoginScreenViewModel>(() =>
        _i1073.LoginScreenViewModel(loginUseCase: gh<_i203.LoginUseCase>()));
    gh.factory<_i451.RegisterViewModelCubit>(() => _i451.RegisterViewModelCubit(
        registerUseCase: gh<_i841.RegisterUseCase>()));
    return this;
  }
}
