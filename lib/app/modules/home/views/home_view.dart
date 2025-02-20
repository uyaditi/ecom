import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/screen_widget.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet.builder(
      builder: (context, delegate, currentRoute) {
        var arg = Get.rootDelegate.arguments();
        if (arg != null) {
          controller.chosenRole.value = arg["role"];
        }
        var route = controller.chosenRole.value.tabs[0].route;
        return ScreenWidget(
          screen: screen!,
          body: GetRouterOutlet(
            initialRoute: route,
            key: Get.nestedKey(route),
          ),
          role: controller.chosenRole.value,
          delegate: delegate,
          currentRoute: currentRoute,
          isWeb: kIsWeb,
        );
      },
    );
  }
}
