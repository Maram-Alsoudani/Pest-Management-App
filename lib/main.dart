import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Features/forgotPassword/presentation/manager/forget_password_view_model.dart';
import 'package:pesticides/Features/login/presentation/manager/cubit/login_screen_view_model.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/di/di.dart';
import 'Config/theme/theming.dart';
import 'Core/utils/SharedPrefsLocal.dart';
import 'Features/register/presentation/manager/register_view_model_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPrefsLocal.init();
  var route = autoLogin();
  configureDependencies();
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<LoginScreenViewModel>(),
        ),
        BlocProvider(
          create: (context) => getIt<RegisterViewModelCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<ForgetPasswordViewModel>(),
        )
      ],
      child: MyApp(
        route: route,
      )));
}

String autoLogin() {
  var item = SharedPrefsLocal.getData(key: StringManager.keyUserAdmin);
  String route;
  if (item != null) {
    route = RoutesManger.routeNameCategoryScreen;
  } else {
    route = RoutesManger.routeNameEngOwnerScreen;
  }
  return route;
}

class MyApp extends StatelessWidget {
  final String route;
  const MyApp({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 892),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: route,
          routes: RoutesManger.route,
          theme: MyTheme.theme,
        );
      },
    );
  }
}
