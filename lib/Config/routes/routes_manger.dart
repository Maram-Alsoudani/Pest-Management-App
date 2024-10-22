import 'package:flutter/material.dart';
import 'package:pesticides/Features/category/presentation/pages/category_screen.dart';
import 'package:pesticides/Features/register/presentation/pages/register_screen.dart';

import '../../Features/login/presentation/pages/login_screen.dart';

class RoutesManger{
static Map<String,Widget Function(BuildContext)>route={
  routeNameRegister:(context)=> RegisterScreen(),
    routeNameLogin: (context) => LoginScreen(),
    routeNameCategoryScreen:(context)=> CategoryScreen(),

};

static const String routeNameRegister="register";
static const String routeNameCategoryScreen="category";
static const String routeNameLogin = "login";

}


