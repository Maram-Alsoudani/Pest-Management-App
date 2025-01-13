import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For orientation lock
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Config/routes/routes_manger.dart';
import 'package:bug_away/Core/component/error_widget.dart';
import 'package:bug_away/Core/my_bloc_observer.dart';
import 'package:bug_away/Core/utils/FCM.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/account_request_admin/presentation/manager/requests_screen_viewmodel_cubit.dart';
import 'package:bug_away/Features/category/presentation/manager/category_cubit.dart';
import 'package:bug_away/Features/chat/presentation/manager/chat_view_model_cubit.dart';
import 'package:bug_away/Features/forgotPassword/presentation/manager/forget_password_view_model.dart';
import 'package:bug_away/Features/inventory/presentation/manager/inventory_view_model_cubit.dart';
import 'package:bug_away/Features/login/presentation/manager/cubit/login_screen_view_model.dart';
import 'package:bug_away/Features/user_request_account/presentation/manager/user_request_account_view_model_cubit.dart';
import 'package:bug_away/Features/site_report/presentation/manager/report_view_model.dart';
import 'package:bug_away/di/di.dart';

import 'Config/theme/theming.dart';
import 'Core/utils/SharedPrefsLocal.dart';
import 'Features/category/profile/presentation/manager/profile_cubit.dart';
import 'Features/register/presentation/manager/register_view_model_cubit.dart';
import 'Features/site/presentation/manager/site_view_model.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firebase Cloud Messaging
  await FCM.fcmInit();
  var token = await FCM.getToken();
  print('FCM Token: $token');

  // Lock the app in portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set up BLoC observer for debugging
  Bloc.observer = MyBlocObserver();

  // Initialize Shared Preferences
  await SharedPrefsLocal.init();
  var route = autoLogin();

  // Dependency Injection setup
  configureDependencies();

  // Global error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    runApp(ErrorWidgetApp(details));
  };

  // Custom error widget
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(errorMessage: details.exceptionAsString());
  };

  // Run the app with multi BLoC providers
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => getIt<LoginScreenViewModel>()),
      BlocProvider(create: (context) => getIt<RegisterViewModelCubit>()),
      BlocProvider(create: (context) => getIt<ForgetPasswordViewModel>()),
      BlocProvider(create: (context) => getIt<CategoryCubit>()),
      BlocProvider(create: (context) => getIt<ProfileCubit>()),
      BlocProvider(create: (context) => getIt<SiteViewModel>()),
      BlocProvider(create: (context) => getIt<InventoryViewModelCubit>()),
      BlocProvider(create: (context) => getIt<ReportViewModel>()),
      BlocProvider(create: (context) => getIt<ChatViewModelCubit>()),
      BlocProvider(create: (context) => getIt<UserRequestAccountCubit>()),
      BlocProvider(create: (context) => getIt<RequestsScreenViewmodelCubit>()),
    ],
    child: MyApp(route: route),
  ));
}

String autoLogin() {
  var item = SharedPrefsLocal.getData(key: StringManager.userAdmin);
  return item != null
      ? RoutesManger.routeNameCategoryScreen
      : RoutesManger.routeNameEngOwnerScreen;
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
