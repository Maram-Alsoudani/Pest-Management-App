import 'package:flutter/material.dart';
import 'package:bug_away/Features/category/presentation/pages/category_screen.dart';
import 'package:bug_away/Features/chat/presentation/pages/chat_screen.dart';
import 'package:bug_away/Features/device_inspection/presentation/pages/device_inspection.dart';
import 'package:bug_away/Features/forgotPassword/presentation/pages/forgot_pass_screen.dart';
import 'package:bug_away/Features/preview_report/presentation/pages/preview_report_screen.dart';
import 'package:bug_away/Features/register/presentation/pages/register_screen.dart';
import 'package:bug_away/Features/reports/presentation/pages/report_of_site.dart';
import 'package:bug_away/Features/reports/presentation/pages/sites_of_user.dart';
import 'package:bug_away/Features/account_request_admin/presentation/pages/request_screen.dart';
import 'package:bug_away/Features/signatures/presentation/pages/signatures_screen.dart';
import 'package:bug_away/Features/site_report/presentation/pages/site_report_screen.dart';
import 'package:bug_away/Features/user_request_account/presentation/pages/user_request_account.dart';

import '../../Features/category/profile/presentation/pages/profile_screen.dart';
import '../../Features/conditions/presentation/pages/conditions_screen.dart';
import '../../Features/material_usage/presentation/pages/material_usage_screen.dart';
import '../../Features/notes/presentation/pages/notes_screen.dart';
import '../../Features/photos/presentation/pages/add_photos_screen.dart';
import '../../Features/recommendations/presentation/pages/recommendations_screen.dart';
import '../../Features/device/presentation/pages/devcie_screen.dart';
import '../../Features/eng_manager_screen/presentation/pages/eng_manager_screen.dart';
import '../../Features/inventory/presentation/pages/inventory_screen.dart';
import '../../Features/login/presentation/pages/login_screen.dart';
import '../../Features/site/presentation/pages/sites_screen.dart';
import '../../Features/reports/presentation/pages/all_users.dart';

class RoutesManger {
  static Map<String, Widget Function(BuildContext)> route = {
    routeNameRegister: (context) => const RegisterScreen(),
    routeNameEngOwnerScreen: (context) => const EngManagerScreen(),
    routeNameLogin: (context) => const LoginScreen(),
    routeNameCategoryScreen: (context) => const CategoryScreen(),
    routeNameSiteReportScreen: (context) => const SiteReportScreen(),
    routeNameNotesScreen: (context) => const NotesScreen(),
    routeNameConditionsScreen: (context) => const ConditionsScreen(),
    routeNameSites: (context) => const SitesScreen(),
    routeNameProfile: (context) => const ProfileScreen(),
    routeNameMaterialUsageScreen: (context) => const MaterialUsageScreen(),
    routeNameDevice: (context) => const DeviceScreen(),
    routeNameRecommendations: (context) => const RecommendationsScreen(),
    routeNameForgotPassScreen: (context) => ForgotPassScreen(),
    routeNameAddPhotosScreen: (context) => const AddPhotosScreen(),
    routeNamePreviewReport: (context) => const PreviewReportScreen(),
    routeNameDeviceInspectionScreen: (context) => const DeviceInspection(),
    routeNameInventory: (context) => const InventoryScreen(),
    routeNameReportsOfAllUsersForAdmin: (context) => const AllUsers(),
    routeNameSitesOfUserForAdmin: (context) => const SitesOFUser(),
    routeNameSignature: (context) => const SignaturesScreen(),
    routeNameChat: (context) => const ChatScreen(),
    routeNameRequiest: (context) => const RequestScreen(),
    routeNameUserRequestAccount: (context) => const UserRequestAccount(),
    routeNameReportOfSiteScreen: (context) => const ReportOfSite()
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
  static const String routeNameReportsOfAllUsersForAdmin = "reports";
  static const String routeNameSitesOfUserForAdmin = "sites of user";
  static const String routeNameSignature = "signature";
  static const String routeNameChat = "chat";
  static const String routeNameRequiest = "requiest";
  static const String routeNameUserRequestAccount = "userRequestAccount";
  static const String routeNameReportOfSiteScreen = "report of site screen";
}
