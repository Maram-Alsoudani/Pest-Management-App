// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

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
    gh.factory<_i969.RegisterDataSource>(() => _i1056.RegisterDataSourceImpl());
    gh.factory<_i20.RegisterRepo>(() => _i391.RegisterRepoImpl(
        registerDataSource: gh<_i969.RegisterDataSource>()));
    gh.factory<_i841.RegisterUseCase>(
        () => _i841.RegisterUseCase(registerRepo: gh<_i20.RegisterRepo>()));
    gh.factory<_i451.RegisterViewModelCubit>(() => _i451.RegisterViewModelCubit(
        registerUseCase: gh<_i841.RegisterUseCase>()));
    return this;
  }
}
