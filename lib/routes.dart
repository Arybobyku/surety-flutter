import 'package:get/get.dart';
import 'package:surety/ui/admin/article/admin_article_page.dart';
import 'package:surety/ui/admin/info/admin_info_page.dart';
import 'package:surety/ui/admin/product/admin_product_page.dart';
import 'package:surety/ui/auth/login_page.dart';
import 'package:surety/ui/auth/register_expertise_page.dart';
import 'package:surety/ui/auth/register_page.dart';
import 'package:surety/ui/auth/reset_page.dart';
import 'package:surety/ui/navigator_page.dart';
import 'package:surety/ui/user/article/user_article_detail_page.dart';
import 'package:surety/ui/user/comment/user_comment_page.dart';
import 'package:surety/ui/user/form/user_form_detail_page.dart';
import 'package:surety/ui/user/home/user_home_page.dart';
import 'package:surety/ui/user/main_menu_page.dart';
import 'package:surety/ui/user/product/user_product_detail_page.dart';
import 'package:surety/ui/user/profile/user_detail_profile_page.dart';
import 'package:surety/ui/web_view.dart';

class Routes {
  Routes._();

  static const String navigator = "/navigator";
  static const String login = "/login";
  static const String register = "/register";
  static const String registerExpertise = "/registerExpertise";
  static const String forgotPassword = "/forgotPassword";
  static const String mainMenu = "/mainMenu";
  static const String webView = "/webView";

  static const String adminDashboard = "/adminDashboard";
  static const String adminArticles = "/adminArticles";
  static const String adminProducts = "/adminProducts";

  static const String userHomePage = "/userHomePage";
  static const String userCommentPage = "/userCommentPage";
  static const String userProfileDetail = "/userProfileDetail";
  static const String userProductDetail = "/userProductDetail";
  static const String userArticleDetail = "/userArticleDetail";
  static const String userFormDetail = "/userFormDetail";

  static final newRoutes = <GetPage>[
    GetPage(name: navigator, page: () => NavigatorPage()),
    GetPage(name: login, page: () => LoginPage()),
    GetPage(name: register, page: () => RegisterPage()),
    GetPage(name: registerExpertise, page: () => RegisterExpertisePage()),
    GetPage(name: forgotPassword, page: () => ResetPage()),

    GetPage(name: webView, page: () => WebViewPage()),

    /// Admin Screen
    GetPage(name: adminDashboard, page: () => AdminInfoPage()),
    GetPage(name: adminArticles, page: () => AdminArticlePage()),
    GetPage(name: adminProducts, page: () => AdminProductPage()),

    /// User Screen
    GetPage(name: mainMenu, page: () => MainMenuPage()),
    GetPage(name: userHomePage, page: () => UserHomePage()),
    GetPage(name: userCommentPage, page: () => UserCommentPage()),
    GetPage(name: userProfileDetail, page: () => UserDetailProfilePage()),
    GetPage(name: userProductDetail, page: () => UserProductDetailPage()),
    GetPage(name: userArticleDetail, page: () => UserArticleDetailPage()),
    GetPage(name: userFormDetail, page: () => UserFormDetailPage()),
  ];
}
