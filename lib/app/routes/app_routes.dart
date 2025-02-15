// ignore_for_file: non_constant_identifier_names, constant_identifier_names

part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  static const HOME = _Paths.HOME;
  static String SHOPPING_ASSISTANT = Screen.SHOPPING_ASSISTANT.route;
  // static String PROFILE = Screen.PROFILE.fullPath;
  // static String SETTINGS = Screen.SETTINGS.fullPath;
  static String LOGIN = Screen.LOGIN.route;
  static String PERSONA_SELECTION = Screen.PERSONA_SELECTION.route;
  static String REGISTER = Screen.REGISTER.route;
  // static String DASHBOARD = Screen.DASHBOARD.fullPath;
  // static String PRODUCTS = Screen.PRODUCTS.fullPath;
  // static String CART = Screen.CART.fullPath;
  // static String CHECKOUT = Screen.CHECKOUT.fullPath;
  // static const CATEGORIES = _Paths.HOME + _Paths.CATEGORIES;
  // static const TASKS = _Paths.HOME + _Paths.TASKS;
  // static const USERS = _Paths.HOME + _Paths.USERS;
  // static const MY_PRODUCTS = _Paths.HOME + _Paths.MY_PRODUCTS;
  static String SHOPPING_ASSISTANT_THEN(String afterSuccessfulLogin) =>
      '${Screen.SHOPPING_ASSISTANT.route}?then=${Uri.encodeQueryComponent(afterSuccessfulLogin)}';
  static String PRODUCT_DETAILS(String productId) =>
      '${Screen.PRODUCTS.route}/$productId';
  static String CART_DETAILS(String productId) =>
      '${Screen.CART.route}/$productId';
  static String TASK_DETAILS(String taskId) => '${Screen.TASKS.route}/$taskId';
  static String USER_PROFILE(String uId) => '${Screen.USERS.route}/$uId';

  Routes._();
  static String LOGIN_THEN(String afterSuccessfulLogin) =>
      '${Screen.LOGIN.route}?then=${Uri.encodeQueryComponent(afterSuccessfulLogin)}';
  static String REGISTER_THEN(String afterSuccessfulLogin) =>
      '${Screen.REGISTER.route}?then=${Uri.encodeQueryComponent(afterSuccessfulLogin)}';
  // static const SEARCH = _Paths.SEARCH;
}

// Keeping this as Get_Cli will require it. Any addition can later be added to Screen
abstract class _Paths {
  static const String HOME = '/home';
  static const String PERSONA_SELECTION = '/persona-selection';
  static const String SHOPPING_ASSISTANT = '/shopping-assistant';
  // static const DASHBOARD = '/dashboard';
  // static const PRODUCTS = '/products';
  // static const PROFILE = '/profile';
  // static const SETTINGS = '/settings';
  // static const PRODUCT_DETAILS = '/:productId';
  // static const CART_DETAILS = '/:productId';
  // static const LOGIN = '/login';
  // static const CART = '/cart';
  // static const CHECKOUT = '/checkout';
  // static const REGISTER = '/register';
  // static const CATEGORIES = '/categories';
  // static const TASKS = '/tasks';
  // static const TASK_DETAILS = '/:taskId';
  // static const USERS = '/users';
  // static const USER_PROFILE = '/:uId';
  // static const MY_PRODUCTS = '/my-products';
  // static const SEARCH = '/search';
}
