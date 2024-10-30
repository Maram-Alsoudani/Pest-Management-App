import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Core/component/error_widget.dart';
import 'package:pesticides/di/di.dart';
import 'Config/theme/theming.dart';
import 'Features/register/presentation/manager/register_view_model_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    configureDependencies();

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      runApp(ErrorWidgetApp(details));
    };

    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<RegisterViewModelCubit>()),
        ],
        child: const MyApp(),
      ),
    );
  } catch (error, stackTrace) {
    runApp(ErrorWidgetApp(
      FlutterErrorDetails(exception: error, stack: stackTrace),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 892),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: RoutesManger.routeNameEngOwnerScreen,
          routes: RoutesManger.route,
          theme: MyTheme.theme,
        );
      },
    );
  }
}
