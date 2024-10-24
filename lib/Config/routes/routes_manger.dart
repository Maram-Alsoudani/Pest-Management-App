import 'package:flutter/material.dart';
import 'package:pesticides/Features/category/presentation/pages/category_screen.dart';
import 'package:pesticides/Features/material_usage/presentation/pages/material_usage_screen.dart';
import 'package:pesticides/Features/forgotPassword/presentation/pages/forgot_pass_screen.dart';
import 'package:pesticides/Features/profile/presentation/pages/profile_screen.dart';
import 'package:pesticides/Features/recommendations/presentation/pages/recommendations_screen.dart';
import 'package:pesticides/Features/register/presentation/pages/register_screen.dart';
import 'package:pesticides/Features/site_report/presentation/pages/site_report_screen.dart';
import 'package:pesticides/Features/sites/presentation/pages/sites_detailes/sites_detailes.dart';
import 'package:pesticides/Features/sites/presentation/pages/sites_screen.dart';
import '../../Features/conditions/presentation/pages/conditions_screen.dart';
import '../../Features/device/presentation/pages/devcie_screen.dart';
import '../../Features/eng_owner_screen/presentation/pages/eng_owner_screen.dart';
import '../../Features/login/presentation/pages/login_screen.dart';
import '../../Features/notes/presentation/pages/notes_screen.dart';

class RoutesManger {
  static Map<String, Widget Function(BuildContext)> route = {
    routeNameRegister: (context) => RegisterScreen(),
    routeNameEngOwnerScreen: (context) => EngOwnerScreen(),
    routeNameLogin: (context) => LoginScreen(),
    routeNameCategoryScreen: (context) => CategoryScreen(),
    routeNameSiteReportScreen: (context) => SiteReportScreen(),
    routeNameNotesScreen: (context) => NotesScreen(),
    routeNameConditionsScreen: (context) => ConditionsScreen(),
    routeNameSitesDetailes: (context) => SitesDetailes(),
    routeNameSites: (context) => SitesScreen(),
    routeNameProfile: (context) => ProfileScreen(),
    routeNameMaterialUsageScreen: (context) => MaterialUsageScreen(),
    routeNameConditionsScreen: (context) => ConditionsScreen(),
    routeNameSitesDetailes: (context) => SitesDetailes(),
    routeNameSites: (context) => SitesScreen(),
    routeNameProfile: (context) => ProfileScreen(),
    routeNameDevice: (context) => DeviceScreen(),
    routeNameRecommendations: (context) => RecommendationsScreen(),
    routeNameForgotPassScreen: (context) => ForgotPassScreen(),
  };

  static const String routeNameEngOwnerScreen = "EngOwnerScreen";
  static const String routeNameMaterialUsageScreen = "MateriaScreen";
  static const String routeNameRegister = "register";
  static const String routeNameCategoryScreen = "category";
  static const String routeNameLogin = "login";
  static const String routeNameSiteReportScreen = "site_report";
  static const String routeNameNotesScreen = "notes";
  static const String routeNameConditionsScreen = "conditions";
  static const String routeNameSitesDetailes = "sites_detailes";
  static const String routeNameSites = "sites";
  static const String routeNameProfile = "profile";
  static const String routeNameConditionsScreen = "conditions";
  static const String routeNameSitesDetailes = "sites_detailes";
  static const String routeNameSites = "sites";
  static const String routeNameProfile = "profile";
  static const String routeNameDevice = "device";
  static const String routeNameRecommendations = "recommendations";
  static const String routeNameForgotPassScreen = "forgot password";

}
