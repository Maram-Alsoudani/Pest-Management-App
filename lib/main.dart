import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/di/di.dart';

import 'Config/theme/theming.dart';
import 'Features/register/presentation/manager/register_view_model_cubit.dart';
import 'firebase_options.dart';

void main()async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  configureDependencies();
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<RegisterViewModelCubit>(),)
      ],
      child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize:  const Size(412, 892),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_ , child) {
        return  MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: RoutesManger.routeNameEngOwnerScreen  ,
          routes: RoutesManger.route,
          theme: MyTheme.theme,

        );
      },
    );
  }
}