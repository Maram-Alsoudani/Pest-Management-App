import 'package:flutter/material.dart';
import 'package:pesticides/Features/category/presentation/pages/category_screen.dart';
import 'package:pesticides/Features/device_inspection/presentation/pages/device_inspection.dart';
import 'package:pesticides/Features/forgotPassword/presentation/pages/forgot_pass_screen.dart';
import 'package:pesticides/Features/preview_report/presentation/pages/preview_report_screen.dart';
import 'package:pesticides/Features/register/presentation/pages/register_screen.dart';
import 'package:pesticides/Features/reports/presentation/pages/sites_of_user.dart';
import 'package:pesticides/Features/site_report/presentation/pages/site_report_screen.dart';

import '../../Features/category/profile/presentation/pages/profile_screen.dart';
import '../../Features/conditions/presentation/pages/conditions_screen.dart';
import '../../Features/material_usage/presentation/pages/material_usage_screen.dart';
import '../../Features/notes/presentation/pages/notes_screen.dart';
import '../../Features/photos/presentation/pages/add_photos_screen.dart';
import '../../Features/recommendations/presentation/pages/recommendations_screen.dart';
import '../../Features/signatures/presentation/pages/signatures_screen.dart';
import '../../Features/device/presentation/pages/devcie_screen.dart';
import '../../Features/eng_owner_screen/presentation/pages/eng_owner_screen.dart';
import '../../Features/inventory/presentation/pages/inventory_screen.dart';
import '../../Features/login/presentation/pages/login_screen.dart';
import '../../Features/inventory/presentation/pages/inventory_screen.dart';
import '../../Features/site/presentation/pages/sites_screen.dart';
import '../../Features/reports/presentation/pages/all_users.dart';

class RoutesManger {
  static Map<String, Widget Function(BuildContext)> route = {
    routeNameRegister: (context) => RegisterScreen(),
    routeNameEngOwnerScreen: (context) => EngOwnerScreen(),
    routeNameLogin: (context) => const LoginScreen(),
    routeNameCategoryScreen: (context) => const CategoryScreen(),
    routeNameSiteReportScreen: (context) => const SiteReportScreen(),
    routeNameNotesScreen: (context) => NotesScreen(),
    routeNameConditionsScreen: (context) => ConditionsScreen(),
    routeNameSites: (context) => SitesScreen(),
    routeNameProfile: (context) => ProfileScreen(),
    routeNameMaterialUsageScreen: (context) => MaterialUsageScreen(),
    routeNameDevice: (context) => DeviceScreen(),
    routeNameRecommendations: (context) => RecommendationsScreen(),
    routeNameForgotPassScreen: (context) => ForgotPassScreen(),
    routeNameAddPhotosScreen: (context) => AddPhotosScreen(),
    routeNamePreviewReport: (context) => PreviewReportScreen(),
    routeNameDeviceInspectionScreen: (context) => DeviceInspection(),
    routeNameInventory: (context) => InventoryScreen(),
    routeNameReports: (context) => AllUsers(),
    routeNameSitesOfUser: (context) => SitesOFUser(),
    routeNameSignature: (context) => SignaturesScreen(),
  };

  static const String routeNameEngOwnerScreen = "EngOwnerScreen";
  static const String routeNameMaterialUsageScreen = "MaterialScreen";
  static const String routeNameRegister = "register";
  static const String routeNameCategoryScreen = "category";
  static const String routeNameLogin = "login";
  static const String routeNameSiteReportScreen = "site_report";
  static const String routeNameNotesScreen = "notes";
  static const String routeNameConditionsScreen = "conditions";
  static const String routeNameSites = "sites";
  static const String routeNameProfile = "profile";
  static const String routeNameDevice = "device";
  static const String routeNameRecommendations = "recommendations";
  static const String routeNameForgotPassScreen = "forgot password";
  static const String routeNameAddPhotosScreen = "add photos";
  static const String routeNamePreviewReport = "previewReport";
  static const String routeNameDeviceInspectionScreen = "device inespection";
  static const String routeNameInventory = "inventory";
  static const String routeNameReports = "reports";
  static const String routeNameSitesOfUser = "sites of user";
  static const String routeNameSignature = "signature";
}
